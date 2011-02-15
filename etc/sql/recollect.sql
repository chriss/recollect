BEGIN;

-- Avoid the implicit index warnings
SET client_min_messages='warning';

CREATE SEQUENCE area_seq;
ALTER SEQUENCE area_seq OWNER TO recollect;
CREATE TABLE areas (
    id     integer PRIMARY KEY DEFAULT nextval('area_seq'),
    name   text NOT NULL,
    centre text NOT NULL
);
CREATE UNIQUE INDEX zone_name_idx ON areas (LOWER(name));
ALTER TABLE areas OWNER TO recollect;


CREATE SEQUENCE zone_seq;
ALTER SEQUENCE zone_seq OWNER TO recollect;
CREATE TABLE zones (
    id     integer PRIMARY KEY DEFAULT nextval('zone_seq'),
    area_id integer references areas(id) NOT NULL,
    name   text NOT NULL,
    title  text NOT NULL,
    colour_name text NOT NULL,
    line_colour text NOT NULL,
    poly_colour text NOT NULL
);
SELECT AddGeometryColumn('', 'zones','geom',-1,'MULTIPOLYGON',2);
CREATE INDEX zones_name_idx ON zones (name);
CREATE UNIQUE INDEX zones_area_name_idx ON zones (area_id, name);
ALTER TABLE zones OWNER TO recollect;


CREATE SEQUENCE pickup_seq;
ALTER SEQUENCE pickup_seq OWNER TO recollect;
CREATE TABLE pickups (
    id      integer PRIMARY KEY DEFAULT nextval('pickup_seq'),
    zone_id integer references zones(id) NOT NULL,
    day     timestamptz NOT NULL,
    flags   text DEFAULT '' NOT NULL
);
CREATE INDEX pickups_zone_idx ON pickups (zone_id);
CREATE INDEX pickups_day_idx  ON pickups (day);
CREATE UNIQUE INDEX pickups_zone_day_idx ON pickups (zone_id, day);
ALTER TABLE pickups OWNER TO recollect;


CREATE SEQUENCE user_seq;
ALTER SEQUENCE user_seq OWNER TO recollect;
CREATE TABLE users (
    id    integer PRIMARY KEY,
    email text NOT NULL,
    created_at  timestamptz DEFAULT LOCALTIMESTAMP NOT NULL,
    twittername text,
    is_admin BOOLEAN DEFAULT FALSE
);
CREATE UNIQUE INDEX users_email_idx ON users (email);
CREATE UNIQUE INDEX users_twittername_idx ON users (twittername);
INSERT INTO users VALUES (nextval('user_seq'), 'radmin@recollect.net', 'now'::timestamptz, 'recollectnet', TRUE);
ALTER TABLE users OWNER TO recollect;

CREATE TABLE subscriptions (
    id         text    PRIMARY KEY,
    user_id    integer references users(id) NOT NULL,
    created_at timestamptz DEFAULT LOCALTIMESTAMP NOT NULL,
    free       BOOLEAN NOT NULL,
    active     BOOLEAN DEFAULT FALSE,
    payment_period TEXT
);
CREATE INDEX subscriptions_user_idx ON subscriptions (user_id);
ALTER TABLE subscriptions OWNER TO recollect;


CREATE SEQUENCE reminder_seq;
ALTER SEQUENCE reminder_seq OWNER TO recollect;
CREATE TABLE reminders (
    id              integer PRIMARY KEY,
    subscription_id text    references subscriptions(id) NOT NULL,
    zone_id         integer references zones(id) NOT NULL,
    created_at      timestamptz DEFAULT LOCALTIMESTAMP NOT NULL,
    last_notified   timestamptz DEFAULT '-infinity'::timestamptz NOT NULL,
    delivery_offset interval DAY TO MINUTE DEFAULT '-6hours'::interval NOT NULL,
    target          text NOT NULL
);
CREATE INDEX reminders_sub_idx ON reminders (subscription_id);
CREATE INDEX reminders_last_notified_idx ON reminders (last_notified);
ALTER TABLE reminders OWNER TO recollect;

--- Views to make life easier
CREATE VIEW next_pickup AS
    SELECT zone_id, min(day) AS next_pickup
      FROM pickups
     WHERE day > 'now'::timestamptz
     GROUP BY zone_id;


CREATE TABLE place_interest (
    at    timestamptz NOT NULL
);
CREATE INDEX place_interest_time_idx  ON place_interest (at);
SELECT AddGeometryColumn('', 'place_interest','point',-1,'POINT',2);
ALTER TABLE place_interest OWNER TO recollect;

CREATE TABLE place_notify (
    at    timestamptz NOT NULL,
    email text NOT NULL
);
CREATE INDEX place_notify_time_idx  ON place_notify (at);
SELECT AddGeometryColumn('', 'place_notify','point',-1,'POINT',2);
ALTER TABLE place_notify OWNER TO recollect;

CREATE TABLE trials (
    at timestamptz NOT NULL,
    target text NOT NULL
);
CREATE INDEX trials_target_idx ON trials (target);
ALTER TABLE trials OWNER TO recollect;

COMMIT;

BEGIN;

CREATE SEQUENCE area_seq;
CREATE TABLE areas (
    id     integer PRIMARY KEY DEFAULT nextval('area_seq'),
    name   text NOT NULL,
    centre text NOT NULL
);
CREATE UNIQUE INDEX zone_name_idx ON areas (LOWER(name));


CREATE SEQUENCE zone_seq;
CREATE TABLE zones (
    id     integer PRIMARY KEY DEFAULT nextval('zone_seq'),
    area_id integer references areas(id) NOT NULL,
    name   text NOT NULL,
    title  text NOT NULL,
    colour text NOT NULL
);
CREATE INDEX zones_name_idx ON zones (name);
CREATE UNIQUE INDEX zones_area_name_idx ON zones (area_id, name);


CREATE SEQUENCE pickup_seq;
CREATE TABLE pickups (
    id      integer PRIMARY KEY DEFAULT nextval('pickup_seq'),
    zone_id integer references zones(id) NOT NULL,
    day     timestamptz NOT NULL,
    flags   text DEFAULT '' NOT NULL
);
CREATE INDEX pickups_zone_idx ON pickups (zone_id);
CREATE INDEX pickups_day_idx  ON pickups (day);
CREATE UNIQUE INDEX pickups_zone_day_idx ON pickups (zone_id, day);


CREATE SEQUENCE user_seq;
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

CREATE TABLE subscriptions (
    id         text    PRIMARY KEY,
    user_id    integer references users(id) NOT NULL,
    created_at timestamptz DEFAULT LOCALTIMESTAMP NOT NULL,
    free       BOOLEAN NOT NULL,
    active     BOOLEAN DEFAULT FALSE
);
CREATE INDEX subscriptions_user_idx ON subscriptions (user_id);


CREATE SEQUENCE reminder_seq;
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

--- Views to make life easier
CREATE VIEW next_pickup AS
    SELECT zone_id, min(day) AS next_pickup
      FROM pickups
     WHERE day > 'now'::timestamptz
     GROUP BY zone_id;


CREATE TABLE place_interest (
    at    timestamptz NOT NULL,
    place text NOT NULL
);
CREATE INDEX place_interest_time_idx  ON place_interest (at);
CREATE INDEX place_interest_place_idx ON place_interest (place);

CREATE TABLE place_notify (
    at    timestamptz NOT NULL,
    place text NOT NULL,
    email text NOT NULL
);
CREATE INDEX place_notify_time_idx  ON place_notify (at);
CREATE INDEX place_notify_place_idx ON place_notify (place);

COMMIT;

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
    area_id integer references areas(id),
    name   text NOT NULL,
    title  text NOT NULL,
    colour text NOT NULL
);
CREATE INDEX zones_name_idx ON zones (name);
CREATE UNIQUE INDEX zones_area_name_idx ON zones (area_id, name);


CREATE SEQUENCE pickup_seq;
CREATE TABLE pickups (
    id      integer PRIMARY KEY DEFAULT nextval('pickup_seq'),
    zone_id integer references zones(id),
    day     timestamptz NOT NULL,
    flags   text DEFAULT ''
);
CREATE INDEX pickups_zone_idx ON pickups (zone_id);
CREATE INDEX pickups_day_idx  ON pickups (day);
CREATE UNIQUE INDEX pickups_zone_day_idx ON pickups (zone_id, day);


CREATE SEQUENCE user_seq;
CREATE TABLE users (
    id    integer PRIMARY KEY,
    email text NOT NULL,
    created_at  timestamptz DEFAULT LOCALTIMESTAMP
);
CREATE UNIQUE INDEX users_email_idx ON users (email);

CREATE TABLE subscriptions (
    id         text    PRIMARY KEY,
    user_id    integer references users(id),
    created_at timestamptz DEFAULT LOCALTIMESTAMP,
    free       BOOLEAN NOT NULL,
    active     BOOLEAN DEFAULT FALSE
);
CREATE INDEX subscriptions_user_idx ON subscriptions (user_id);


CREATE SEQUENCE reminder_seq;
CREATE TABLE reminders (
    id              integer PRIMARY KEY,
    subscription_id text    references subscriptions(id),
    zone_id         integer references zones(id),
    created_at      timestamptz DEFAULT LOCALTIMESTAMP,
    last_notified   timestamptz DEFAULT '-infinity'::timestamptz,
    delivery_offset interval DAY TO MINUTE DEFAULT '-6hours'::interval,
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


COMMIT;

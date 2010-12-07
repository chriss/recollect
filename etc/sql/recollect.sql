BEGIN;

CREATE SEQUENCE zone_seq;
CREATE TABLE zones (
    id     integer PRIMARY KEY DEFAULT nextval('zone_seq'),
    name   text NOT NULL,
    title  text NOT NULL,
    colour text NOT NULL
);
CREATE INDEX zones_name_idx ON zones (name);


CREATE SEQUENCE pickup_seq;
CREATE TABLE pickups (
    id      integer PRIMARY KEY DEFAULT nextval('pickup_seq'),
    zone_id integer references zones(id),
    day     date NOT NULL,
    flags   text DEFAULT ''
);
CREATE INDEX pickups_zone_idx ON pickups (zone_id);
CREATE INDEX pickups_day_idx  ON pickups (day);


CREATE SEQUENCE user_seq;
CREATE TABLE users (
    id    integer PRIMARY KEY DEFAULT nextval('user_seq'),
    email text NOT NULL
);
CREATE INDEX users_email_idx ON users (email);


CREATE SEQUENCE reminder_seq;
CREATE TABLE reminders (
    id      integer PRIMARY KEY DEFAULT nextval('reminder_seq'),
    user_id integer references users(id),
    zone_id integer references zones(id),
    created_at      timestamptz DEFAULT LOCALTIMESTAMP,
    last_notified   timestamptz DEFAULT '-infinity'::timestamptz,
    delivery_offset interval DAY TO MINUTE DEFAULT '-6hours'::interval,
    target      text NOT NULL,
    active      BOOLEAN NOT NULL DEFAULT TRUE,
    confirmed   BOOLEAN NOT NULL,
    confirm_hash text DEFAULT ''
);
CREATE INDEX reminders_user_idx ON reminders (user_id);
CREATE INDEX reminders_zone_idx ON reminders (zone_id) WHERE active IS TRUE;
CREATE INDEX reminders_last_notified_idx ON reminders (last_notified);
CREATE INDEX reminders_confirm_hash_idx ON reminders (confirm_hash);


CREATE SEQUENCE subscriptions_seq;
CREATE TABLE subscriptions (
    id         integer PRIMARY KEY DEFAULT nextval('subscriptions_seq'),
    user_id    integer references users(id),
    period     text NOT NULL,
    profile_id text NOT NULL,
    expiry     timestamptz DEFAULT 'infinity'::timestamptz,
    coupon     text DEFAULT ''
);
CREATE INDEX subscriptions_user_idx ON subscriptions (user_id);
CREATE INDEX subscriptions_profile_id_idx ON subscriptions (profile_id);
CREATE INDEX subscriptions_expiry_idx ON subscriptions (expiry);


COMMIT;

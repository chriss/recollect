BEGIN;

ALTER TABLE subscriptions ADD COLUMN welcomed BOOLEAN default false;
UPDATE subscriptions SET welcomed = true;

DELETE FROM recollect_schema;
INSERT INTO recollect_schema (current_version) VALUES (12);

COMMIT;

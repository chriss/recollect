BEGIN;

ALTER TABLE ical_users ADD COLUMN created_at timestamptz;
UPDATE ical_users SET created_at = last_get;
ALTER TABLE ical_users ADD CONSTRAINT created_at SET NOT NULL;

DELETE FROM recollect_schema;
INSERT INTO recollect_schema (current_version) VALUES (8);

COMMIT;

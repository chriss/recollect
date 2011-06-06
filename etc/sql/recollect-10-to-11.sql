BEGIN;

ALTER TABLE reminders ALTER COLUMN last_notified SET DEFAULT LOCALTIMESTAMP;

DELETE FROM recollect_schema;
INSERT INTO recollect_schema (current_version) VALUES (11);

COMMIT;

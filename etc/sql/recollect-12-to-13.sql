BEGIN;

ALTER TABLE users ADD COLUMN passhash TEXT;

DELETE FROM recollect_schema;
INSERT INTO recollect_schema (current_version) VALUES (13);

COMMIT;

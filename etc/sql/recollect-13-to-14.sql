BEGIN;

ALTER TABLE users ADD COLUMN reset_passhash TEXT;

DELETE FROM recollect_schema;
INSERT INTO recollect_schema (current_version) VALUES (14);

COMMIT;

BEGIN;

-- Make this index a UNIQUE index
CREATE UNIQUE INDEX zones_name_idx ON zones (name);

DELETE FROM recollect_schema;
INSERT INTO recollect_schema (current_version) VALUES (1);

COMMIT;

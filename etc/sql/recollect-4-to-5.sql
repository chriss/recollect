BEGIN;

-- Add location to subscription table
SELECT AddGeometryColumn('', 'subscriptions','location',-1,'POINT',2);

DELETE FROM recollect_schema;
INSERT INTO recollect_schema (current_version) VALUES (5);

COMMIT;

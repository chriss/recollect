BEGIN;

UPDATE pickups SET flags = 'GRYC'
    WHERE zone_id IN (SELECT id FROM zones WHERE city_id = (SELECT id from cities WHERE name = 'Vancouver'))
      AND flags = 'GRY';

DELETE FROM recollect_schema;
INSERT INTO recollect_schema (current_version) VALUES (3);

COMMIT;

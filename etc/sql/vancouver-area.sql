BEGIN;

INSERT INTO areas (id, name, centre) VALUES (nextval('area_seq'), 'Vancouver', '');

COMMIT;

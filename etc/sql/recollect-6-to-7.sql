BEGIN;

CREATE TABLE area_admins (
    area_id integer NOT NULL,
    user_id integer NOT NULL
);
CREATE UNIQUE INDEX area_admins_user ON area_admins (user_id);
CREATE UNIQUE INDEX area_admins_area ON area_admins (area_id);
ALTER TABLE area_admins OWNER TO recollect;

DELETE FROM recollect_schema;
INSERT INTO recollect_schema (current_version) VALUES (7);

COMMIT;

BEGIN;

ALTER TABLE areas ADD COLUMN licence_name           text DEFAULT '' SET NOT NULL;
ALTER TABLE areas ADD COLUMN success_web_snippet    text DEFAULT '' SET NOT NULL;
ALTER TABLE areas ADD COLUMN success_email_snippet  text DEFAULT '' SET NOT NULL;
ALTER TABLE areas ADD COLUMN logo_img               text DEFAULT '' SET NOT NULL;
ALTER TABLE areas ADD COLUMN logo_url               text DEFAULT '' SET NOT NULL;
ALTER TABLE areas ADD COLUMN background_img         text DEFAULT '' SET NOT NULL;

DELETE FROM recollect_schema;
INSERT INTO recollect_schema (current_version) VALUES (9);

COMMIT;

BEGIN;

-- Merge the cities and areas tables, we really only need one
ALTER TABLE zones DROP COLUMN city_id;
ALTER TABLE areas DROP COLUMN centre;
ALTER TABLE areas ADD COLUMN ad_img TEXT;
ALTER TABLE areas ADD COLUMN ad_url TEXT;
ALTER TABLE areas ADD COLUMN licence_url TEXT;

-- Add some missing cities to the areas table
INSERT INTO areas (name) VALUES ('North Vancouver');
INSERT INTO areas (name) VALUES ('Esquimalt');
INSERT INTO areas (name) VALUES ('Oak Bay');
INSERT INTO areas (name) VALUES ('Burnaby');
INSERT INTO areas (name) VALUES ('New Westminister');
INSERT INTO areas (name) VALUES ('Coquitlam');
INSERT INTO areas (name) VALUES ('Port Moody');


-- Now populate these columns
UPDATE areas SET ad_img = 'recollect-ad-no-plastic-borderless.jpg'               WHERE name = 'Vancouver';
UPDATE areas SET ad_url = 'http://vancouver.ca/projects/foodWaste/noplastic.htm' WHERE name = 'Vancouver';
UPDATE areas SET licence_url = 'http://data.vancouver.ca/termsOfUse.htm'         WHERE name = 'Vancouver';
UPDATE areas SET licence_url = 'http://geoweb.dnv.org/ancillary/site-legal.html' WHERE name = 'North Vancouver';
UPDATE areas SET licence_url = 'http://www.edmonton.ca/city_government/open_data/open-data-terms-of-use.aspx'
                                                                                 WHERE name = 'Edmonton';

UPDATE zones SET area_id = (SELECT id FROM areas WHERE name = 'North Vancouver')
    WHERE name like 'north-vancouver-%';
UPDATE zones SET area_id = (SELECT id FROM areas WHERE name = 'Esquimalt')
    WHERE name like 'esquimalt-%';
UPDATE zones SET area_id = (SELECT id FROM areas WHERE name = 'Oak Bay')
    WHERE name like 'oakbay-%';
UPDATE zones SET area_id = (SELECT id FROM areas WHERE name = 'Burnaby')
    WHERE name like 'burnaby-%';
UPDATE zones SET area_id = (SELECT id FROM areas WHERE name = 'New Westminister')
    WHERE name like 'new-west-%';
UPDATE zones SET area_id = (SELECT id FROM areas WHERE name = 'Coquitlam')
    WHERE name like 'coquitlam-%';
UPDATE zones SET area_id = (SELECT id FROM areas WHERE name = 'Port Moody')
    WHERE name like 'port-moody-%';

DELETE FROM recollect_schema;
INSERT INTO recollect_schema (current_version) VALUES (4);

COMMIT;

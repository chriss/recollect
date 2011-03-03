BEGIN;

-- Make this index a UNIQUE index
CREATE SEQUENCE city_seq;
CREATE TABLE cities (
    id integer PRIMARY KEY DEFAULT nextval('city_seq'),
    name text NOT NULL,
    ad_img text,
    licence_url text
);
CREATE UNIQUE INDEX city_name_idx ON cities (name);
INSERT INTO cities (name, ad_img, licence_url) VALUES (
    'Vancouver', 'recollect-ad-no-plastic-borderless.jpg',
    'http://data.vancouver.ca/termsOfUse.htm'
);
INSERT INTO cities (name, licence_url) VALUES (
    'North Vancouver',
    'http://geoweb.dnv.org/ancillary/site-legal.html'
);
INSERT INTO cities (name, licence_url) VALUES (
    'Edmonton',
    'http://www.edmonton.ca/city_government/open_data/open-data-terms-of-use.aspx'
);
INSERT INTO cities (name) VALUES ('Victoria');
INSERT INTO cities (name) VALUES ('Esquimalt');
INSERT INTO cities (name) VALUES ('Oak Bay');
INSERT INTO cities (name) VALUES ('Burnaby');
INSERT INTO cities (name) VALUES ('New Westminister');
INSERT INTO cities (name) VALUES ('Coquitlam');
INSERT INTO cities (name) VALUES ('Port Moody');
INSERT INTO cities (name) VALUES ('Toronto');

ALTER TABLE zones ADD COLUMN city_id integer;
UPDATE zones SET city_id = (SELECT id FROM cities WHERE name = 'Vancouver')
    WHERE name like 'vancouver-%';
UPDATE zones SET city_id = (SELECT id FROM cities WHERE name = 'North Vancouver')
    WHERE name like 'north-vancouver-%';
UPDATE zones SET city_id = (SELECT id FROM cities WHERE name = 'Edmonton')
    WHERE name like 'edmonton-%';
UPDATE zones SET city_id = (SELECT id FROM cities WHERE name = 'Toronto')
    WHERE name like 'toronto-%';
UPDATE zones SET city_id = (SELECT id FROM cities WHERE name = 'Victoria')
    WHERE name like 'victoria-%';
UPDATE zones SET city_id = (SELECT id FROM cities WHERE name = 'Esquimalt')
    WHERE name like 'esquimalt-%';
UPDATE zones SET city_id = (SELECT id FROM cities WHERE name = 'Oak Bay')
    WHERE name like 'oak-bay-%';
UPDATE zones SET city_id = (SELECT id FROM cities WHERE name = 'Burnaby')
    WHERE name like 'burnaby-%';
UPDATE zones SET city_id = (SELECT id FROM cities WHERE name = 'New Westminister')
    WHERE name like 'new-west-%';
UPDATE zones SET city_id = (SELECT id FROM cities WHERE name = 'Coquitlam')
    WHERE name like 'coquitlam-%';
UPDATE zones SET city_id = (SELECT id FROM cities WHERE name = 'Port Moody')
    WHERE name like 'port-moody-%';

ALTER TABLE zones ALTER COLUMN city_id SET NOT NULL;

DELETE FROM recollect_schema;
INSERT INTO recollect_schema (current_version) VALUES (2);

COMMIT;

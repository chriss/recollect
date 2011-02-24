BEGIN;
-- This script ASSUMES that the area already exists

-- Delete any existing data for this area
DELETE FROM pickups
    WHERE zone_id IN (
        SELECT id FROM zones WHERE name like 'new-west-%'
    );
DELETE FROM zones WHERE name like 'new-west-%';

-- Insert the zones
INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Vancouver'),'new-west-b','New-west Zone B','new-west-b','FF22C4FE','9922C4FE');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((49.205795 -122.952011,49.200775 -122.945786,49.200115 -122.945145,49.199192 -122.943939,49.198910 -122.941948,49.200089 -122.938232,49.200592 -122.934204,49.200157 -122.930984,49.198784 -122.927422,49.198124 -122.924248,49.197647 -122.917313,49.197746 -122.913773,49.200775 -122.906715,49.204250 -122.901886,49.208038 -122.898003,49.210224 -122.896332,49.211231 -122.897919,49.213448 -122.900620,49.211514 -122.904526,49.205151 -122.916473,49.214008 -122.927589,49.208836 -122.937248,49.211796 -122.940941,49.205795 -122.952011)))') WHERE name = 'new-west-b';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Vancouver'),'new-west-c','New-west Zone C','new-west-c','FFD79606','99D79606');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((49.214008 -122.927567,49.216057 -122.923943,49.222488 -122.911949,49.227436 -122.902573,49.223804 -122.902634,49.221436 -122.904846,49.220612 -122.902336,49.220570 -122.898773,49.216267 -122.898903,49.215088 -122.897079,49.213715 -122.896759,49.211964 -122.898773,49.213474 -122.900620,49.211540 -122.904526,49.205177 -122.916496,49.214008 -122.927567)))') WHERE name = 'new-west-c';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Vancouver'),'new-west-a','New-west Zone A','new-west-a','FF67C171','9967C171');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((49.202290 -122.958641,49.200581 -122.958595,49.194157 -122.951134,49.190678 -122.956581,49.187256 -122.957138,49.175587 -122.957352,49.185883 -122.931046,49.194351 -122.920616,49.196514 -122.920189,49.197384 -122.925125,49.197945 -122.943192,49.199261 -122.944008,49.200264 -122.945282,49.200874 -122.945908,49.201721 -122.946960,49.205799 -122.952065,49.203712 -122.956688,49.202290 -122.958641)))') WHERE name = 'new-west-a';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Vancouver'),'new-west-d','New-west Zone D','new-west-d','FFB27DE4','99B27DE4');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((49.211807 -122.940895,49.234722 -122.898430,49.229523 -122.898582,49.216026 -122.923965,49.208893 -122.937225,49.211807 -122.940895)))') WHERE name = 'new-west-d';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Vancouver'),'new-west-e','New-west Zone E','new-west-e','FFC594B1','99C594B1');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((49.211922 -122.898750,49.211147 -122.897789,49.210209 -122.896332,49.214642 -122.893021,49.219376 -122.891800,49.222572 -122.885109,49.223759 -122.882271,49.224689 -122.878349,49.231506 -122.878624,49.239288 -122.891991,49.239388 -122.895943,49.237602 -122.896111,49.236031 -122.896240,49.234722 -122.898422,49.229523 -122.898567,49.227413 -122.902573,49.223793 -122.902626,49.221451 -122.904854,49.220612 -122.902290,49.220573 -122.898788,49.216267 -122.898903,49.215088 -122.897079,49.213707 -122.896759,49.211922 -122.898750)))') WHERE name = 'new-west-e';



-- Now the schedule data
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-1-10 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-1-17 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-1-24 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-1-31 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-2-7 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-2-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-2-21 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-2-28 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-3-7 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-3-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-3-21 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-3-28 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-4-4 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-4-11 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-4-18 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-4-27 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-5-4 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-5-11 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-5-18 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-5-26 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-6-2 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-6-9 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-6-16 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-6-23 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-6-30 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-7-8 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-7-15 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-7-22 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-7-29 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-8-8 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-8-15 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-8-22 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-8-29 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-9-6 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-9-13 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-9-20 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-9-27 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-10-4 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-10-12 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-10-19 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-10-26 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-11-2 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-11-9 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-11-17 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-11-24 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-12-1 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-12-8 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-12-15 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-a'),
           '2011-12-22 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-1-4 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-1-11 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-1-18 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-1-25 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-2-1 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-2-8 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-2-15 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-2-22 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-3-1 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-3-8 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-3-15 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-3-22 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-3-29 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-4-5 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-4-12 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-4-19 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-4-28 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-5-5 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-5-12 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-5-19 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-5-27 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-6-3 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-6-10 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-6-17 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-6-24 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-7-4 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-7-11 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-7-18 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-7-25 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-8-2 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-8-9 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-8-16 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-8-23 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-8-30 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-9-7 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-9-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-9-12 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-9-28 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-10-5 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-10-13 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-10-20 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-10-27 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-11-3 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-11-10 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-11-18 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-11-25 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-12-2 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-12-9 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-12-16 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-b'),
           '2011-12-23 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-1-5 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-1-12 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-1-19 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-1-26 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-2-2 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-2-9 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-2-16 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-2-23 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-3-2 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-3-9 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-3-16 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-3-23 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-3-30 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-4-6 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-4-13 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-4-20 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-4-29 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-5-6 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-5-13 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-5-20 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-5-30 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-6-6 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-6-13 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-6-20 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-6-27 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-7-5 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-7-12 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-7-19 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-7-26 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-8-3 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-8-10 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-8-17 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-8-24 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-8-31 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-9-8 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-9-15 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-9-22 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-9-29 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-10-6 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-10-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-10-21 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-10-28 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-11-4 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-11-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-11-21 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-11-28 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-12-5 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-12-12 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-12-19 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-c'),
           '2011-12-28 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-1-6 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-1-13 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-1-20 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-1-27 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-2-3 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-2-10 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-2-17 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-2-24 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-3-3 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-3-10 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-3-17 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-3-24 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-3-31 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-4-7 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-4-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-4-21 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-5-2 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-5-9 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-5-16 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-5-24 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-5-31 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-6-7 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-6-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-6-21 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-6-28 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-7-6 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-7-13 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-7-20 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-7-27 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-8-4 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-8-11 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-8-18 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-8-25 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-9-1 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-9-9 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-9-16 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-9-23 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-9-30 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-10-7 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-10-17 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-10-24 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-10-31 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-11-7 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-11-15 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-11-22 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-11-29 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-12-6 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-12-13 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-12-20 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-d'),
           '2011-12-29 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-01-07 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-1-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-1-21 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-1-28 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-2-4 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-2-11 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-2-18 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-2-25 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-3-4 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-3-11 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-3-18 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-3-25 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-4-1 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-4-8 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-4-15 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-4-26 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-5-3 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-5-10 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-5-17 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-5-25 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-6-1 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-6-8 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-6-15 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-6-22 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-6-29 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-7-7 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-7-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-7-21 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-7-28 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-8-5 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-8-12 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-8-19 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-8-26 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-9-2 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-9-12 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-9-19 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-9-26 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-10-3 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-10-11 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-10-18 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-10-25 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-11-1 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-11-8 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-11-16 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-11-23 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-11-30 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-12-7 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-12-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-12-21 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'new-west-e'),
           '2011-12-30 07:00:00-08', 'GRY');

COMMIT;

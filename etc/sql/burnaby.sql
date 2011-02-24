BEGIN;
-- This script ASSUMES that the area already exists

-- Delete any existing data for this area
DELETE FROM pickups
    WHERE zone_id IN (
        SELECT id FROM zones WHERE name like 'burnaby-%'
    );
DELETE FROM zones WHERE name like 'burnaby-%';

-- Insert the zones
INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Vancouver'),'burnaby-d','Burnaby Zone D','burnaby-d','FF31CCFF','9931CCFF');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((49.214836 -123.023636,49.214851 -123.012367,49.214836 -122.996986,49.214878 -122.982590,49.214737 -122.972008,49.214710 -122.961624,49.215046 -122.960358,49.211922 -122.956367,49.213688 -122.952759,49.216450 -122.947784,49.220539 -122.940041,49.223888 -122.933708,49.224899 -122.931732,49.225010 -122.930771,49.225136 -122.930534,49.227856 -122.934006,49.228222 -122.934479,49.228474 -122.934441,49.229145 -122.934052,49.230183 -122.935341,49.231457 -122.936905,49.232368 -122.937569,49.232677 -122.938774,49.233433 -122.939331,49.234455 -122.940765,49.234917 -122.941048,49.236416 -122.940529,49.236961 -122.940445,49.237301 -122.945015,49.238377 -122.949669,49.236069 -122.953964,49.235546 -122.954475,49.229691 -122.964905,49.229313 -122.966064,49.229313 -122.969734,49.229496 -122.979408,49.231007 -122.979393,49.231121 -122.985611,49.229649 -122.985764,49.229958 -122.988937,49.229942 -122.997391,49.230042 -122.997932,49.232887 -123.008766,49.232914 -123.013962,49.232353 -123.023399,49.228416 -123.023483,49.221970 -123.023590,49.221649 -123.023743,49.214836 -123.023636)))') WHERE name = 'burnaby-d';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Vancouver'),'burnaby-a','Burnaby Zone A','burnaby-a','FFC7C9EE','99C7C9EE');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((49.276318 -123.023529,49.293167 -123.023354,49.293591 -122.994301,49.288803 -122.983788,49.287598 -122.981514,49.287395 -122.981323,49.286785 -122.980743,49.284359 -122.980820,49.280319 -122.980957,49.275497 -122.981003,49.275227 -122.975571,49.269821 -122.975670,49.266762 -122.975647,49.266258 -122.975998,49.265747 -122.976555,49.265297 -122.976677,49.264774 -122.976677,49.263889 -122.977135,49.264717 -122.979904,49.265060 -122.982445,49.265087 -122.991043,49.265430 -122.993347,49.266220 -122.996979,49.266354 -123.000084,49.266621 -123.008743,49.267242 -123.008797,49.267994 -123.010323,49.268707 -123.012276,49.270290 -123.014282,49.272732 -123.017166,49.273510 -123.017860,49.273952 -123.018532,49.274700 -123.020264,49.275345 -123.021362,49.275875 -123.022125,49.276169 -123.022659,49.276302 -123.023071,49.276318 -123.023529)))') WHERE name = 'burnaby-a';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Vancouver'),'burnaby-b','Burnaby Zone B','burnaby-b','FF70AA8B','9970AA8B');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((49.286770 -122.980667,49.287590 -122.981483,49.288799 -122.983772,49.293560 -122.994171,49.295151 -122.987732,49.289890 -122.963531,49.292549 -122.931129,49.289429 -122.894257,49.279549 -122.893753,49.271591 -122.893532,49.267208 -122.893318,49.263401 -122.901733,49.258781 -122.911339,49.257332 -122.912201,49.252419 -122.912422,49.250832 -122.902458,49.248066 -122.902527,49.248093 -122.904503,49.248081 -122.906822,49.250290 -122.910980,49.250801 -122.913681,49.250729 -122.915680,49.250252 -122.917953,49.244080 -122.933319,49.244221 -122.944427,49.248280 -122.956833,49.257610 -122.964638,49.261551 -122.970650,49.263821 -122.977127,49.264778 -122.976646,49.265339 -122.976677,49.265759 -122.976562,49.266270 -122.975998,49.266781 -122.975639,49.275230 -122.975594,49.275509 -122.980972,49.280319 -122.980927,49.284569 -122.980820,49.286770 -122.980667)))') WHERE name = 'burnaby-b';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Vancouver'),'burnaby-c','Burnaby Zone C','burnaby-c','FFCCAE7E','99CCAE7E');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((49.232342 -123.023354,49.232914 -123.013939,49.232887 -123.008812,49.230042 -122.997841,49.229984 -122.997330,49.229942 -122.988792,49.229622 -122.985741,49.231121 -122.985634,49.231022 -122.979324,49.229507 -122.979370,49.229313 -122.967827,49.229328 -122.965897,49.229691 -122.964752,49.235535 -122.954521,49.236069 -122.953918,49.238377 -122.949631,49.244247 -122.944519,49.248253 -122.956879,49.257584 -122.964737,49.261559 -122.970657,49.264641 -122.979797,49.265045 -122.982330,49.265087 -122.991104,49.265411 -122.993378,49.266193 -122.996902,49.266613 -123.008766,49.267216 -123.008789,49.268070 -123.010506,49.268715 -123.012352,49.272888 -123.017372,49.273544 -123.017906,49.274036 -123.018784,49.274719 -123.020332,49.275982 -123.022346,49.276176 -123.022713,49.276318 -123.023079,49.276333 -123.023529,49.254810 -123.023705,49.232342 -123.023354)))') WHERE name = 'burnaby-c';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Vancouver'),'burnaby-e','Burnaby Zone E','burnaby-e','FFB4769E','99B4769E');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((49.214851 -123.023613,49.211796 -123.023827,49.210476 -123.024086,49.208038 -123.023575,49.205460 -123.023445,49.199596 -123.024429,49.194073 -123.004257,49.185432 -122.992676,49.180664 -122.981598,49.180664 -122.972549,49.189163 -122.962204,49.196373 -122.947144,49.199203 -122.956024,49.200665 -122.959114,49.204334 -122.958984,49.204197 -122.955681,49.209061 -122.945984,49.213505 -122.937782,49.218987 -122.927635,49.224548 -122.917252,49.227337 -122.912079,49.233150 -122.901367,49.235367 -122.897141,49.235744 -122.895470,49.235729 -122.892593,49.241909 -122.892616,49.249149 -122.892899,49.256741 -122.893021,49.262917 -122.893112,49.267189 -122.893303,49.258785 -122.911346,49.257317 -122.912209,49.252441 -122.912445,49.250847 -122.902443,49.248058 -122.902573,49.248116 -122.906883,49.250256 -122.910835,49.250832 -122.913712,49.250763 -122.915642,49.250271 -122.917915,49.244080 -122.933342,49.244247 -122.944504,49.238407 -122.949608,49.237328 -122.945038,49.237019 -122.940384,49.236584 -122.940491,49.234932 -122.941071,49.234440 -122.940788,49.233433 -122.939308,49.232689 -122.938774,49.232395 -122.937569,49.231525 -122.937012,49.229160 -122.934029,49.228443 -122.934479,49.228249 -122.934479,49.225151 -122.930550,49.224998 -122.930748,49.224899 -122.931732,49.216408 -122.947845,49.213490 -122.953148,49.211933 -122.956390,49.215046 -122.960403,49.214737 -122.961601,49.214821 -122.978424,49.214851 -122.993958,49.214851 -123.009499,49.214851 -123.023613)))') WHERE name = 'burnaby-e';



-- Now the schedule data
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-01-07 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-1-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-1-21 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-1-28 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-2-4 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-2-11 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-2-18 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-2-25 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-3-4 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-3-11 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-3-18 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-3-25 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-4-1 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-4-8 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-4-15 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-4-26 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-5-3 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-5-10 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-5-17 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-5-25 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-6-1 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-6-8 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-6-15 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-6-22 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-6-29 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-7-7 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-7-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-7-21 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-7-28 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-8-5 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-8-12 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-8-19 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-8-26 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-9-2 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-9-12 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-9-19 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-9-26 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-10-3 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-10-11 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-10-18 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-10-25 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-11-1 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-11-8 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-11-16 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-11-23 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-11-30 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-12-7 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-12-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-12-21 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-a'),
           '2011-12-30 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-1-10 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-1-17 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-1-24 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-1-31 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-2-7 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-2-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-2-21 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-2-28 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-3-7 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-3-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-3-21 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-3-28 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-4-4 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-4-11 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-4-18 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-4-27 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-5-4 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-5-11 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-5-18 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-5-26 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-6-2 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-6-9 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-6-16 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-6-23 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-6-30 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-7-8 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-7-15 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-7-22 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-7-29 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-8-8 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-8-15 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-8-22 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-8-29 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-9-6 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-9-13 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-9-20 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-9-27 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-10-4 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-10-12 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-10-19 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-10-26 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-11-2 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-11-9 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-11-17 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-11-24 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-12-1 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-12-8 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-12-15 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-b'),
           '2011-12-22 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-1-4 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-1-11 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-1-18 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-1-25 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-2-1 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-2-8 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-2-15 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-2-22 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-3-1 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-3-8 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-3-15 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-3-22 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-3-29 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-4-5 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-4-12 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-4-19 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-4-28 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-5-5 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-5-12 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-5-19 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-5-27 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-6-3 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-6-10 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-6-17 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-6-24 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-7-4 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-7-11 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-7-18 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-7-25 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-8-2 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-8-9 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-8-16 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-8-23 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-8-30 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-9-7 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-9-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-9-12 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-9-28 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-10-5 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-10-13 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-10-20 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-10-27 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-11-3 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-11-10 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-11-18 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-11-25 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-12-2 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-12-9 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-12-16 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-c'),
           '2011-12-23 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-1-5 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-1-12 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-1-19 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-1-26 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-2-2 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-2-9 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-2-16 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-2-23 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-3-2 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-3-9 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-3-16 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-3-23 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-3-30 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-4-6 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-4-13 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-4-20 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-4-29 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-5-6 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-5-13 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-5-20 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-5-30 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-6-6 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-6-13 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-6-20 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-6-27 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-7-5 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-7-12 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-7-19 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-7-26 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-8-3 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-8-10 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-8-17 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-8-24 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-8-31 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-9-8 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-9-15 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-9-22 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-9-29 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-10-6 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-10-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-10-21 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-10-28 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-11-4 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-11-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-11-21 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-11-28 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-12-5 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-12-12 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-12-19 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-d'),
           '2011-12-29 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-1-6 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-1-13 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-1-20 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-1-27 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-2-3 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-2-10 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-2-17 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-2-24 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-3-3 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-3-10 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-3-17 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-3-24 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-3-31 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-4-7 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-4-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-4-21 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-5-2 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-5-9 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-5-16 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-5-24 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-5-31 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-6-7 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-6-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-6-21 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-6-28 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-7-6 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-7-13 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-7-20 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-7-27 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-8-4 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-8-11 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-8-18 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-8-25 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-9-1 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-9-9 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-9-16 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-9-23 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-9-30 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-10-7 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-10-17 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-10-24 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-10-31 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-11-7 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-11-15 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-11-22 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-11-29 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-12-6 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-12-13 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-12-20 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'burnaby-e'),
           '2011-12-29 07:00:00-08', 'GRY');

COMMIT;

BEGIN;
-- This script ASSUMES that the area already exists

-- Delete any existing data for this area
DELETE FROM pickups
    WHERE zone_id IN (
        SELECT id FROM zones WHERE name like 'oakbay-%'
    );
DELETE FROM zones WHERE name like 'oakbay-%';

-- Insert the zones
INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Victoria'),'oakbay-3-south','Oakbay 3-south','oakbay-3-south','40000000','996666FF');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((48.426498 -123.314819,48.426510 -123.315887,48.420238 -123.315964,48.420212 -123.317848,48.415779 -123.318039,48.413891 -123.318192,48.413479 -123.318329,48.413090 -123.318787,48.411671 -123.316437,48.412090 -123.315987,48.412621 -123.315109,48.412910 -123.314232,48.413059 -123.313477,48.413219 -123.311981,48.419994 -123.311653,48.426430 -123.311661,48.426498 -123.314819)))') WHERE name = 'oakbay-3-south';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Victoria'),'oakbay-5-north','Oakbay 5-north','oakbay-5-north','40000000','99990000');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((48.432919 -123.318130,48.432629 -123.316566,48.431919 -123.314301,48.431679 -123.313461,48.431587 -123.313133,48.431431 -123.312546,48.431274 -123.311943,48.433182 -123.310638,48.431221 -123.304268,48.431759 -123.304443,48.433319 -123.303841,48.434502 -123.303040,48.435661 -123.302139,48.438049 -123.309563,48.438187 -123.314453,48.438099 -123.315041,48.437916 -123.315559,48.437695 -123.315933,48.437656 -123.316170,48.436966 -123.316574,48.436817 -123.316666,48.436626 -123.316719,48.436264 -123.316826,48.434925 -123.316521,48.434250 -123.316383,48.433567 -123.316284,48.433586 -123.316673,48.433514 -123.317017,48.433300 -123.317413,48.432919 -123.318130)))') WHERE name = 'oakbay-5-north';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Victoria'),'oakbay-2-south','Oakbay 2-south','oakbay-2-south','40000000','99FFFF33');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((48.420300 -123.323387,48.419632 -123.323509,48.415730 -123.324776,48.411201 -123.326294,48.410019 -123.324127,48.409279 -123.324409,48.409264 -123.325050,48.408794 -123.325356,48.407925 -123.325417,48.407398 -123.324562,48.406502 -123.323746,48.405861 -123.322716,48.405544 -123.321663,48.405643 -123.321274,48.406300 -123.320824,48.407398 -123.320244,48.406982 -123.318871,48.407883 -123.317802,48.408195 -123.317802,48.408321 -123.316322,48.408524 -123.315994,48.409222 -123.315697,48.410061 -123.317566,48.410374 -123.317459,48.410686 -123.317673,48.410988 -123.316986,48.411652 -123.316513,48.413090 -123.318810,48.413479 -123.318336,48.413792 -123.318222,48.415890 -123.318031,48.420219 -123.317848,48.420300 -123.323387)))') WHERE name = 'oakbay-2-south';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Victoria'),'oakbay-4-north','Oakbay 4-north','oakbay-4-north','40000000','99CCFFFF');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((48.445709 -123.312683,48.445309 -123.312737,48.445030 -123.312874,48.444420 -123.313171,48.443531 -123.313629,48.443069 -123.313698,48.442951 -123.313652,48.442581 -123.314278,48.441700 -123.314583,48.441010 -123.315208,48.439159 -123.315239,48.437660 -123.316154,48.437695 -123.315941,48.437901 -123.315628,48.438103 -123.315041,48.438210 -123.314438,48.438171 -123.312576,48.438190 -123.309662,48.437550 -123.307693,48.436859 -123.305779,48.435669 -123.302139,48.437462 -123.300079,48.438980 -123.297073,48.440331 -123.302238,48.441021 -123.304153,48.441521 -123.303650,48.442101 -123.303413,48.442371 -123.303543,48.442440 -123.303307,48.442619 -123.303108,48.444489 -123.302353,48.445332 -123.306770,48.445492 -123.307739,48.445648 -123.310173,48.445709 -123.312683)))') WHERE name = 'oakbay-4-north';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Victoria'),'oakbay-1-north','Oakbay 1-north','oakbay-1-north','40000000','9999CCFF');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((48.460373 -123.320953,48.452381 -123.321350,48.448391 -123.321556,48.445984 -123.321724,48.444389 -123.321716,48.444347 -123.320114,48.444126 -123.318817,48.444939 -123.318260,48.445267 -123.317894,48.445606 -123.317589,48.445992 -123.317368,48.445942 -123.315300,48.447983 -123.314774,48.449913 -123.313744,48.451466 -123.312874,48.451813 -123.312798,48.452274 -123.312668,48.453129 -123.312424,48.453571 -123.314278,48.455109 -123.313461,48.455959 -123.313507,48.456902 -123.313919,48.457897 -123.313034,48.460373 -123.320953)))') WHERE name = 'oakbay-1-north';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Victoria'),'oakbay-5-south','Oakbay 5-south','oakbay-5-south','40000000','990000FF');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((48.420216 -123.311623,48.413200 -123.311996,48.413090 -123.309471,48.412811 -123.308784,48.412449 -123.308479,48.411572 -123.307709,48.410931 -123.306808,48.410160 -123.304604,48.410542 -123.301170,48.411671 -123.298286,48.410912 -123.295631,48.411652 -123.292801,48.413261 -123.294037,48.414661 -123.295738,48.419559 -123.296829,48.420238 -123.298721,48.420582 -123.300194,48.420586 -123.303131,48.420601 -123.303398,48.420609 -123.305641,48.420181 -123.305656,48.420166 -123.307106,48.420158 -123.308746,48.420216 -123.311623)))') WHERE name = 'oakbay-5-south';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Victoria'),'oakbay-4-south','Oakbay 4-south','oakbay-4-south','40000000','9966FFFF');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((48.433170 -123.310654,48.431278 -123.311928,48.430332 -123.312653,48.429565 -123.313194,48.429386 -123.313408,48.429276 -123.313637,48.429150 -123.313866,48.429077 -123.313934,48.428928 -123.313995,48.426498 -123.314072,48.426491 -123.313042,48.426441 -123.312820,48.426441 -123.311661,48.420231 -123.311623,48.420151 -123.308479,48.420181 -123.305672,48.420609 -123.305641,48.420589 -123.300194,48.420238 -123.298721,48.423439 -123.300293,48.425350 -123.299988,48.424809 -123.302322,48.425041 -123.304382,48.424938 -123.306938,48.427589 -123.307564,48.429241 -123.306572,48.429508 -123.304878,48.430882 -123.304283,48.431202 -123.304291,48.431400 -123.304878,48.431210 -123.304298,48.433170 -123.310654)))') WHERE name = 'oakbay-4-south';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Victoria'),'oakbay-1-south','Oakbay 1-south','oakbay-1-south','40000000','99FF6633');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((48.432919 -123.318138,48.432529 -123.319618,48.432388 -123.320961,48.432121 -123.322388,48.426689 -123.322708,48.425758 -123.322639,48.425018 -123.321938,48.424171 -123.321678,48.421730 -123.322601,48.421249 -123.323196,48.420300 -123.323387,48.420212 -123.317833,48.420238 -123.315964,48.426521 -123.315887,48.426491 -123.314079,48.427753 -123.314041,48.428391 -123.314018,48.428974 -123.313995,48.429020 -123.313957,48.429073 -123.313942,48.429150 -123.313873,48.429264 -123.313667,48.429390 -123.313400,48.429577 -123.313202,48.429832 -123.313019,48.430332 -123.312660,48.431274 -123.311943,48.431675 -123.313469,48.432636 -123.316589,48.432774 -123.317329,48.432919 -123.318138)))') WHERE name = 'oakbay-1-south';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Victoria'),'oakbay-2-north','Oakbay 2-north2','oakbay-2-north','40000000','9999FF66');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((48.457027 -123.310333,48.456230 -123.311043,48.456402 -123.311493,48.455124 -123.312416,48.455166 -123.311493,48.455235 -123.310608,48.455334 -123.308960,48.455479 -123.307053,48.455677 -123.305977,48.457027 -123.310333)),((48.455849 -123.305573,48.455051 -123.303978,48.454197 -123.302605,48.453629 -123.303207,48.452633 -123.304771,48.451336 -123.306747,48.450142 -123.308510,48.445843 -123.310913,48.445686 -123.307976,48.445217 -123.305161,48.444691 -123.302414,48.444221 -123.299820,48.444248 -123.298508,48.444477 -123.297501,48.444592 -123.296623,48.445004 -123.295891,48.440418 -123.294930,48.440247 -123.286858,48.450012 -123.291817,48.451107 -123.292519,48.450966 -123.293060,48.450043 -123.292671,48.449715 -123.294518,48.450153 -123.295868,48.450611 -123.296104,48.450993 -123.295464,48.451393 -123.295357,48.452106 -123.295486,48.452587 -123.296875,48.452049 -123.297394,48.453087 -123.299347,48.454269 -123.299644,48.454739 -123.299583,48.455379 -123.299088,48.455479 -123.299431,48.455807 -123.299217,48.456928 -123.297691,48.457825 -123.296303,48.458111 -123.295723,48.458466 -123.295265,48.459106 -123.296425,48.459805 -123.295609,48.461853 -123.299301,48.455849 -123.305573)))') WHERE name = 'oakbay-2-north';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Victoria'),'oakbay-3-north','Oakbay 3-north','oakbay-3-north','40000000','99FF99FF');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((48.445938 -123.317329,48.445560 -123.317612,48.444950 -123.318253,48.444111 -123.318802,48.444340 -123.320168,48.444359 -123.321732,48.432129 -123.322403,48.432400 -123.320976,48.432529 -123.319649,48.432899 -123.318169,48.433369 -123.317291,48.433510 -123.317009,48.433571 -123.316788,48.433586 -123.316666,48.433582 -123.316536,48.433578 -123.316406,48.433563 -123.316292,48.434238 -123.316383,48.434917 -123.316528,48.436272 -123.316833,48.436832 -123.316658,48.437035 -123.316528,48.437664 -123.316162,48.438313 -123.315765,48.438957 -123.315369,48.439049 -123.318779,48.440498 -123.318611,48.440498 -123.315132,48.441071 -123.315048,48.441719 -123.314362,48.442612 -123.314232,48.442928 -123.313698,48.443291 -123.313698,48.443779 -123.313553,48.445179 -123.312820,48.445770 -123.312721,48.445938 -123.317329)))') WHERE name = 'oakbay-3-north';



-- Now the schedule data
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-1-13 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-1-27 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-2-10 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-2-24 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-3-10 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-3-23 07:00:00-08', 'Y');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-3-24 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-4-7 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-4-21 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-5-9 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-5-24 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-6-7 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-6-21 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-7-6 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-7-20 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-8-4 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-8-18 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-9-1 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-9-16 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-9-30 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-10-17 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-10-31 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-11-15 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-11-29 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-12-13 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-north'),
           '2011-12-29 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-1-14 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-1-28 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-2-11 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-2-25 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-3-11 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-3-24 07:00:00-08', 'Y');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-3-25 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-4-8 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-4-26 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-5-10 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-5-25 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-6-8 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-6-22 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-7-7 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-7-21 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-8-5 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-8-19 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-9-2 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-9-19 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-10-3 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-10-18 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-11-1 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-11-16 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-11-30 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-12-14 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-north'),
           '2011-12-30 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-1-17 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-1-31 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-2-14 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-2-28 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-3-14 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-3-24 07:00:00-08', 'Y');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-3-28 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-4-11 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-4-27 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-5-11 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-5-26 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-6-9 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-6-23 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-7-8 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-7-22 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-8-8 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-8-22 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-9-6 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-9-20 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-10-4 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-10-19 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-11-2 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-11-17 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-12-1 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-north'),
           '2011-12-15 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-1-4 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-1-18 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-2-1 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-2-15 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-3-1 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-3-15 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-3-25 07:00:00-08', 'Y');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-3-29 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-4-12 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-4-28 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-5-12 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-5-27 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-6-10 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-6-24 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-7-11 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-7-25 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-8-9 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-8-23 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-9-7 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-9-21 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-10-5 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-10-20 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-11-3 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-11-18 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-12-2 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-north'),
           '2011-12-16 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-1-5 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-1-19 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-2-2 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-2-16 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-3-2 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-3-16 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-3-25 07:00:00-08', 'Y');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-3-30 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-4-13 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-4-29 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-5-13 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-5-27 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-6-13 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-6-27 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-7-12 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-7-26 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-8-10 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-8-24 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-9-8 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-9-22 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-10-6 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-10-21 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-11-4 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-11-21 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-12-5 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-north'),
           '2011-12-19 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-1-6 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-1-20 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-2-3 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-2-17 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-3-3 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-3-17 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-3-21 07:00:00-08', 'Y');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-3-31 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-4-14 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-5-2 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-5-16 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-5-31 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-6-14 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-6-28 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-7-13 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-7-27 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-8-11 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-8-25 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-9-9 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-9-23 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-10-7 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-10-24 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-11-7 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-11-22 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-12-6 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-1-south'),
           '2011-12-20 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-1-7 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-1-21 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-2-4 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-2-18 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-3-4 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-3-18 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-3-21 07:00:00-08', 'Y');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-4-1 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-4-15 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-5-3 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-5-17 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-6-15 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-6-29 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-7-14 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-7-28 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-8-12 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-8-26 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-9-12 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-9-26 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-10-11 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-10-25 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-11-8 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-11-23 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-12-7 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-2-south'),
           '2011-12-21 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-1-10 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-1-24 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-2-7 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-2-21 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-3-7 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-3-21 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-3-22 07:00:00-08', 'Y');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-4-4 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-4-18 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-5-4 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-5-18 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-6-16 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-6-30 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-7-15 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-7-29 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-8-15 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-8-29 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-9-13 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-9-27 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-10-12 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-10-26 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-11-9 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-11-24 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-12-8 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-3-south'),
           '2011-12-22 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-1-11 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-1-25 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-2-8 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-2-22 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-3-8 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-3-22 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-4-5 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-4-19 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-5-5 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-5-19 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-6-3 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-6-17 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-7-4 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-7-18 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-8-2 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-8-16 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-8-30 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-9-14 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-9-28 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-10-13 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-10-27 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-11-10 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-11-25 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-12-9 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-4-south'),
           '2011-12-23 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-1-12 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-1-26 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-2-9 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-2-23 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-3-9 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-3-23 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-4-6 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-4-20 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-5-6 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-5-20 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-6-6 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-6-20 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-7-5 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-7-19 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-8-3 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-8-17 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-8-31 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-9-15 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-9-29 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-10-14 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-10-28 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-11-14 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-11-28 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-12-12 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'oakbay-5-south'),
           '2011-12-28 07:00:00-08', 'G');

COMMIT;

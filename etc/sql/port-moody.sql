BEGIN;
-- This script ASSUMES that the area already exists

-- Delete any existing data for this area
DELETE FROM pickups
    WHERE zone_id IN (
        SELECT id FROM zones WHERE name like 'port-moody-%'
    );
DELETE FROM zones WHERE name like 'port-moody-%';

-- Insert the zones
INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Vancouver'),'port-moody-tuesday','Port Moody Tuesday','port-moody-tuesday','FF702480','99702480');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((49.270969 -122.872940,49.270775 -122.856544,49.270737 -122.845261,49.272453 -122.845245,49.273140 -122.836952,49.273140 -122.834244,49.273148 -122.832169,49.273209 -122.830971,49.273285 -122.829865,49.273361 -122.825821,49.273369 -122.823723,49.274876 -122.823814,49.275497 -122.823799,49.276470 -122.823746,49.278866 -122.823868,49.280327 -122.823853,49.280521 -122.823761,49.280476 -122.821098,49.282715 -122.821129,49.285149 -122.821136,49.287762 -122.821030,49.290462 -122.820969,49.294296 -122.820961,49.294853 -122.820976,49.294861 -122.823486,49.294464 -122.824158,49.292084 -122.826012,49.290497 -122.826439,49.289837 -122.829597,49.289333 -122.830315,49.286171 -122.830444,49.285561 -122.829376,49.285145 -122.828896,49.284550 -122.828476,49.284241 -122.828239,49.284451 -122.826775,49.284451 -122.825882,49.284309 -122.825111,49.283772 -122.823845,49.283562 -122.823326,49.281944 -122.825485,49.280987 -122.826988,49.280796 -122.827484,49.284191 -122.828461,49.284050 -122.829491,49.284081 -122.830193,49.283279 -122.834221,49.283009 -122.836388,49.282349 -122.835228,49.281029 -122.835602,49.281452 -122.837509,49.282330 -122.837440,49.282516 -122.838272,49.281223 -122.841286,49.281250 -122.842461,49.279942 -122.845154,49.280327 -122.848167,49.281284 -122.848854,49.281826 -122.850555,49.280277 -122.851082,49.280853 -122.852654,49.281826 -122.853340,49.281811 -122.853683,49.280476 -122.853615,49.280479 -122.854141,49.281174 -122.854279,49.281250 -122.858276,49.279175 -122.857887,49.279594 -122.860794,49.280964 -122.861267,49.281860 -122.860497,49.282505 -122.858864,49.282642 -122.867058,49.276737 -122.866844,49.272930 -122.870796,49.270969 -122.872940)))') WHERE name = 'port-moody-tuesday';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Vancouver'),'port-moody-wednesday','Port Moody Wednesday','port-moody-wednesday','FF44BE74','9944BE74');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((49.286179 -122.830444,49.289364 -122.830338,49.289867 -122.829628,49.290516 -122.826439,49.292084 -122.826019,49.294483 -122.824158,49.294891 -122.823486,49.296764 -122.822823,49.298935 -122.822639,49.302944 -122.822639,49.306736 -122.822632,49.310127 -122.822571,49.310127 -122.833664,49.305931 -122.833679,49.305916 -122.835518,49.301819 -122.835625,49.300800 -122.835327,49.300243 -122.835274,49.299698 -122.835228,49.299664 -122.836044,49.299656 -122.837364,49.299774 -122.842812,49.298515 -122.843239,49.298138 -122.842224,49.297031 -122.839661,49.296745 -122.838684,49.296627 -122.837662,49.296680 -122.836151,49.296787 -122.835312,49.296017 -122.835251,49.295219 -122.835518,49.294727 -122.835899,49.294312 -122.836555,49.294128 -122.836334,49.293987 -122.836212,49.293594 -122.835831,49.293247 -122.835327,49.293190 -122.835045,49.293133 -122.834618,49.292225 -122.834473,49.291763 -122.834564,49.291512 -122.834091,49.291195 -122.833725,49.290791 -122.833481,49.290257 -122.833382,49.288486 -122.833382,49.287956 -122.833252,49.287563 -122.833061,49.287235 -122.832642,49.286793 -122.831818,49.286221 -122.830589,49.286179 -122.830444)))') WHERE name = 'port-moody-wednesday';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Vancouver'),'port-moody-monday','Port Moody Monday','port-moody-monday','FF1F82F5','991F82F5');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((49.270493 -122.880371,49.270317 -122.893234,49.275738 -122.893471,49.275764 -122.881233,49.280228 -122.881439,49.284184 -122.879539,49.286491 -122.877808,49.290977 -122.876938,49.290894 -122.875137,49.290363 -122.873253,49.289661 -122.871437,49.288719 -122.869720,49.287579 -122.868561,49.286491 -122.867897,49.286194 -122.867790,49.284752 -122.867378,49.283295 -122.867149,49.281242 -122.866943,49.279327 -122.866890,49.278137 -122.867058,49.276711 -122.866890,49.270954 -122.872963,49.271046 -122.880287,49.270668 -122.880280,49.270668 -122.880264,49.270676 -122.880287,49.270645 -122.880280,49.270485 -122.880371,49.270473 -122.880363,49.270485 -122.880386,49.270493 -122.880371)))') WHERE name = 'port-moody-monday';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Vancouver'),'port-moody-thursday','Port Moody Thursday','port-moody-thursday','FFB16709','99B16709');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((49.298458 -122.843285,49.299801 -122.842857,49.305874 -122.842728,49.306015 -122.849808,49.305984 -122.852127,49.306183 -122.873238,49.308449 -122.873238,49.308475 -122.879074,49.301819 -122.879593,49.300724 -122.879723,49.300724 -122.878471,49.301731 -122.876930,49.301342 -122.874054,49.301731 -122.872169,49.300362 -122.869980,49.298710 -122.867577,49.298458 -122.865990,49.294682 -122.860664,49.293812 -122.857315,49.291855 -122.853584,49.289333 -122.846718,49.285862 -122.836975,49.284660 -122.835091,49.283119 -122.836334,49.284073 -122.830406,49.284241 -122.828438,49.280796 -122.827446,49.283596 -122.823372,49.284351 -122.825478,49.284409 -122.826805,49.284241 -122.828438,49.285526 -122.829292,49.286312 -122.830879,49.287262 -122.832726,49.288017 -122.833282,49.290817 -122.833504,49.291771 -122.834656,49.292191 -122.834488,49.293125 -122.834595,49.293255 -122.835281,49.293392 -122.835579,49.294331 -122.836548,49.294724 -122.835899,49.295280 -122.835495,49.296040 -122.835281,49.296795 -122.835281,49.296669 -122.836914,49.296638 -122.837685,49.296806 -122.838989,49.298054 -122.842125,49.298458 -122.843285)))') WHERE name = 'port-moody-thursday';



-- Now the schedule data
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-01-04 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-01-10 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-01-17 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-01-24 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-01-31 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-02-07 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-02-14 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-02-21 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-02-28 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-03-07 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-03-14 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-03-21 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-03-28 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-04-04 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-04-11 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-04-18 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-04-26 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-05-02 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-05-09 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-05-16 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-05-24 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-05-30 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-06-06 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-06-13 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-06-20 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-06-27 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-07-04 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-07-11 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-07-18 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-07-25 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-08-02 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-08-08 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-08-15 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-08-22 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-08-29 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-09-06 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-09-12 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-09-19 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-09-26 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-10-03 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-10-11 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-10-17 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-10-24 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-10-31 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-11-07 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-11-14 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-11-21 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-11-28 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-12-05 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-12-12 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-12-19 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-monday'),
           '2011-12-27 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-01-05 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-01-11 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-01-18 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-01-25 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-02-01 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-02-08 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-02-15 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-02-22 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-03-01 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-03-08 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-03-15 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-03-22 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-03-29 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-04-05 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-04-12 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-04-19 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-04-27 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-05-03 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-05-10 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-05-17 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-05-25 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-05-31 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-06-07 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-06-14 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-06-21 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-06-28 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-07-05 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-07-12 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-07-19 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-07-26 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-08-03 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-08-09 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-08-16 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-08-23 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-08-30 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-09-07 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-09-13 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-09-20 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-09-27 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-10-04 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-10-12 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-10-18 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-10-25 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-11-01 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-11-08 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-11-15 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-11-22 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-11-29 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-12-06 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-12-13 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-12-20 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-tuesday'),
           '2011-12-28 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-01-06 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-01-12 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-01-19 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-01-26 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-02-02 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-02-09 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-02-16 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-02-23 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-03-02 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-03-09 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-03-16 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-03-23 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-03-30 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-04-06 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-04-13 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-04-20 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-04-28 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-05-04 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-05-11 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-05-18 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-05-26 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-06-01 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-06-08 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-06-15 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-06-22 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-06-29 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-07-06 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-07-13 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-07-20 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-07-27 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-08-04 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-08-10 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-08-17 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-08-24 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-08-31 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-09-08 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-09-14 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-09-21 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-09-28 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-10-05 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-10-13 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-10-19 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-10-26 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-11-02 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-11-09 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-11-16 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-11-23 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-11-30 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-12-07 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-12-14 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-12-21 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-wednesday'),
           '2011-12-29 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-01-07 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-01-13 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-01-20 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-01-27 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-02-03 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-02-10 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-02-17 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-02-24 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-03-03 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-03-10 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-03-17 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-03-24 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-03-31 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-04-07 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-04-14 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-04-21 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-04-29 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-05-05 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-05-12 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-05-19 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-05-27 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-06-02 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-06-09 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-06-16 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-06-23 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-06-30 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-07-07 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-07-14 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-07-21 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-07-28 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-08-05 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-08-11 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-08-18 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-08-25 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-09-01 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-09-09 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-09-15 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-09-22 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-09-29 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-10-06 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-10-14 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-10-20 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-10-27 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-11-03 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-11-10 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-11-17 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-11-24 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-12-01 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-12-08 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-12-15 07:00:00-08', 'GY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-12-22 07:00:00-08', 'RY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'port-moody-thursday'),
           '2011-12-30 07:00:00-08', 'GY');

COMMIT;

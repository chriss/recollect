BEGIN;
-- This script ASSUMES that the area already exists

-- Delete any existing data for this area
DELETE FROM pickups
    WHERE zone_id IN (
        SELECT id FROM zones WHERE name like 'coquitlam-%'
    );
DELETE FROM zones WHERE name like 'coquitlam-%';

-- Insert the zones
INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Vancouver'),'coquitlam-monday','Coquitlam Monday','coquitlam-monday','FF0EC8FE','990EC8FE');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((49.284752 -122.821030,49.284882 -122.820259,49.284752 -122.819054,49.283371 -122.815002,49.283401 -122.813004,49.284519 -122.809120,49.285019 -122.805794,49.285351 -122.798500,49.284698 -122.789383,49.285469 -122.786118,49.285728 -122.785408,49.285751 -122.784698,49.292770 -122.781273,49.293152 -122.779739,49.294491 -122.776932,49.295029 -122.775040,49.291698 -122.772324,49.285702 -122.771980,49.285549 -122.769493,49.287128 -122.768028,49.286869 -122.767227,49.289330 -122.767128,49.289322 -122.761574,49.285702 -122.761627,49.285801 -122.729683,49.283031 -122.729553,49.283760 -122.691528,49.293282 -122.679169,49.312752 -122.681747,49.313931 -122.716850,49.319130 -122.746979,49.340050 -122.760628,49.336700 -122.789886,49.325169 -122.810410,49.310349 -122.822418,49.307690 -122.822594,49.297100 -122.822746,49.295380 -122.823624,49.294903 -122.823547,49.294876 -122.822426,49.294899 -122.823517,49.294868 -122.821114,49.284752 -122.821030)))') WHERE name = 'coquitlam-monday';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Vancouver'),'coquitlam-wednesday','Coquitlam Wednesday','coquitlam-wednesday','FF9394F5','999394F5');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((49.262890 -122.893112,49.259094 -122.893021,49.256771 -122.893005,49.249165 -122.892876,49.249107 -122.892487,49.249088 -122.888870,49.249023 -122.877159,49.249012 -122.869194,49.248962 -122.857445,49.249012 -122.852425,49.248989 -122.846611,49.248997 -122.844925,49.248962 -122.843979,49.249023 -122.841072,49.249062 -122.836754,49.249088 -122.824394,49.249115 -122.815636,49.243954 -122.815628,49.243927 -122.806290,49.245880 -122.803505,49.247406 -122.802238,49.251022 -122.800629,49.258499 -122.797523,49.259933 -122.797783,49.260944 -122.797783,49.266041 -122.798676,49.268524 -122.798653,49.268814 -122.799126,49.269302 -122.799477,49.272133 -122.803055,49.272011 -122.803146,49.268280 -122.803246,49.267448 -122.802666,49.265633 -122.802696,49.265331 -122.802780,49.263512 -122.803886,49.262077 -122.805222,49.261383 -122.806335,49.261341 -122.806915,49.262028 -122.809212,49.262150 -122.809540,49.263058 -122.810768,49.263603 -122.811195,49.263737 -122.811455,49.264164 -122.813354,49.263981 -122.814255,49.263226 -122.815849,49.263184 -122.816170,49.263191 -122.825066,49.263283 -122.832161,49.263351 -122.837029,49.263374 -122.840851,49.263451 -122.847038,49.263458 -122.852104,49.263493 -122.857597,49.263550 -122.868736,49.263626 -122.879997,49.263378 -122.885216,49.262890 -122.893112)))') WHERE name = 'coquitlam-wednesday';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Vancouver'),'coquitlam-tuesday','Coquitlam Tuesday','coquitlam-tuesday','FF9E7C84','999E7C84');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((49.284729 -122.821068,49.283401 -122.821007,49.280548 -122.821091,49.280499 -122.823738,49.280369 -122.823830,49.277779 -122.823868,49.276138 -122.823708,49.275742 -122.823792,49.274879 -122.823822,49.273861 -122.823578,49.273460 -122.823608,49.273338 -122.829269,49.273232 -122.829742,49.273190 -122.831528,49.273129 -122.832230,49.273109 -122.845428,49.271194 -122.845474,49.271271 -122.853409,49.270821 -122.855507,49.270870 -122.872673,49.270969 -122.874619,49.270969 -122.880386,49.270309 -122.880531,49.270149 -122.889580,49.270390 -122.890388,49.270401 -122.893410,49.262901 -122.893127,49.263618 -122.879997,49.263420 -122.846008,49.263290 -122.830132,49.263191 -122.824677,49.263168 -122.816101,49.263260 -122.815781,49.263988 -122.814301,49.264149 -122.813637,49.264172 -122.813362,49.264061 -122.812767,49.263710 -122.811378,49.263538 -122.811096,49.263100 -122.810783,49.262150 -122.809540,49.261410 -122.807251,49.261341 -122.806831,49.261391 -122.806343,49.261669 -122.805817,49.262081 -122.805237,49.263458 -122.803940,49.265270 -122.802811,49.265621 -122.802689,49.267429 -122.802658,49.268261 -122.803230,49.272011 -122.803146,49.272148 -122.803070,49.269299 -122.799477,49.268799 -122.799110,49.268539 -122.798660,49.266941 -122.798737,49.265999 -122.798683,49.260948 -122.797783,49.259941 -122.797783,49.259941 -122.796783,49.260670 -122.795410,49.260792 -122.792526,49.261810 -122.790756,49.265362 -122.790771,49.273548 -122.790497,49.278461 -122.790497,49.278500 -122.773071,49.278431 -122.767258,49.286819 -122.767212,49.287159 -122.768051,49.286598 -122.768478,49.285542 -122.769402,49.285660 -122.771927,49.288448 -122.772018,49.291672 -122.772324,49.294029 -122.774231,49.295101 -122.774979,49.294418 -122.777283,49.293560 -122.778778,49.292736 -122.781227,49.289223 -122.782906,49.285721 -122.784698,49.285751 -122.785431,49.285400 -122.786293,49.285145 -122.787384,49.284660 -122.789360,49.285309 -122.798576,49.285011 -122.805687,49.284519 -122.809212,49.283409 -122.812958,49.283401 -122.815018,49.284752 -122.819183,49.284870 -122.820282,49.284729 -122.821068)))') WHERE name = 'coquitlam-tuesday';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Vancouver'),'coquitlam-thursday','Coquitlam Thursday','coquitlam-thursday','FF85CD9D','9985CD9D');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((49.249149 -122.892876,49.244881 -122.892639,49.242310 -122.892624,49.235962 -122.882111,49.233818 -122.874428,49.229439 -122.836159,49.230106 -122.834076,49.231659 -122.830612,49.236801 -122.820518,49.243912 -122.806290,49.243954 -122.815666,49.249107 -122.815659,49.249062 -122.834534,49.249023 -122.841095,49.248962 -122.844017,49.248997 -122.844978,49.249012 -122.850098,49.249031 -122.852455,49.248955 -122.858017,49.249012 -122.869263,49.249054 -122.885414,49.249149 -122.892876)))') WHERE name = 'coquitlam-thursday';



-- Now the schedule data
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-monday'),
           '2011-02-7 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-monday'),
           '2011-02-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-monday'),
           '2011-02-21 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-monday'),
           '2011-02-28 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-tuesday'),
           '2011-02-1 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-tuesday'),
           '2011-02-8 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-tuesday'),
           '2011-02-15 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-tuesday'),
           '2011-02-22 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-wednesday'),
           '2011-02-2 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-wednesday'),
           '2011-02-9 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-wednesday'),
           '2011-02-16 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-wednesday'),
           '2011-02-23 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-thursday'),
           '2011-02-3 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-thursday'),
           '2011-02-10 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-thursday'),
           '2011-02-17 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-thursday'),
           '2011-02-24 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-monday'),
           '2011-03-7 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-monday'),
           '2011-03-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-monday'),
           '2011-03-21 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-monday'),
           '2011-03-28 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-tuesday'),
           '2011-03-1 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-tuesday'),
           '2011-03-8 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-tuesday'),
           '2011-03-15 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-tuesday'),
           '2011-03-22 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-tuesday'),
           '2011-03-29 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-wednesday'),
           '2011-03-2 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-wednesday'),
           '2011-03-9 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-wednesday'),
           '2011-03-16 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-wednesday'),
           '2011-03-23 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-wednesday'),
           '2011-03-30 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-thursday'),
           '2011-03-3 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-thursday'),
           '2011-03-10 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-thursday'),
           '2011-03-17 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-thursday'),
           '2011-03-24 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-thursday'),
           '2011-03-31 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-monday'),
           '2011-04-4 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-monday'),
           '2011-04-11 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-monday'),
           '2011-04-18 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-monday'),
           '2011-04-26 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-tuesday'),
           '2011-04-5 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-tuesday'),
           '2011-04-12 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-tuesday'),
           '2011-04-19 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-tuesday'),
           '2011-04-27 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-wednesday'),
           '2011-04-6 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-wednesday'),
           '2011-04-13 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-wednesday'),
           '2011-04-20 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-wednesday'),
           '2011-04-28 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-thursday'),
           '2011-04-7 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-thursday'),
           '2011-04-14 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-thursday'),
           '2011-04-21 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-thursday'),
           '2011-04-29 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-monday'),
           '2011-05-2 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-monday'),
           '2011-05-9 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-monday'),
           '2011-05-16 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-monday'),
           '2011-05-24 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-monday'),
           '2011-05-30 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-tuesday'),
           '2011-05-3 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-tuesday'),
           '2011-05-10 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-tuesday'),
           '2011-05-17 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-tuesday'),
           '2011-05-25 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-tuesday'),
           '2011-05-31 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-wednesday'),
           '2011-05-4 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-wednesday'),
           '2011-05-11 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-wednesday'),
           '2011-05-18 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-wednesday'),
           '2011-05-26 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-thursday'),
           '2011-05-5 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-thursday'),
           '2011-05-12 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-thursday'),
           '2011-05-19 07:00:00-08', 'GRY');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'coquitlam-thursday'),
           '2011-05-27 07:00:00-08', 'GRY');

COMMIT;

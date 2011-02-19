BEGIN;
-- This script ASSUMES that the area already exists

-- Delete any existing data for this area
DELETE FROM pickups
    WHERE zone_id IN (
        SELECT id FROM zones WHERE name like 'esquimalt-%'
    );
DELETE FROM zones WHERE name like 'esquimalt-%';

-- Insert the zones
INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Victoria'),'esquimalt-south-orange','Esquimalt South-orange','esquimalt-south-orange','40000000','990099FF');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((48.427170 -123.406998,48.426254 -123.407204,48.426128 -123.406288,48.425255 -123.406624,48.424980 -123.405388,48.423214 -123.406013,48.423168 -123.406677,48.422928 -123.406723,48.422928 -123.408302,48.421619 -123.409271,48.418259 -123.410858,48.416691 -123.409889,48.416740 -123.408218,48.417850 -123.407982,48.418072 -123.405319,48.417992 -123.403839,48.420399 -123.399483,48.419140 -123.397942,48.420052 -123.397507,48.421410 -123.398109,48.421490 -123.397423,48.423531 -123.392548,48.427071 -123.392250,48.428596 -123.398964,48.429493 -123.399712,48.427940 -123.402748,48.428001 -123.403542,48.427559 -123.403687,48.427639 -123.404358,48.428089 -123.404083,48.428398 -123.406929,48.427792 -123.407097,48.427521 -123.407532,48.427254 -123.407608,48.427170 -123.406998)))') WHERE name = 'esquimalt-south-orange';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Victoria'),'esquimalt-south-pink','Esquimalt South-pink','esquimalt-south-pink','40000000','99CC33CC');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((48.430241 -123.424461,48.428211 -123.424469,48.428371 -123.423180,48.428379 -123.422523,48.428280 -123.415260,48.427860 -123.412216,48.429066 -123.411819,48.428867 -123.409981,48.427620 -123.410362,48.427540 -123.409660,48.428200 -123.409462,48.428139 -123.408836,48.428520 -123.408722,48.428749 -123.408859,48.429249 -123.408669,48.429119 -123.407997,48.429577 -123.407944,48.429554 -123.407654,48.430092 -123.407639,48.430279 -123.408943,48.429958 -123.409111,48.430008 -123.409492,48.430496 -123.409309,48.430313 -123.407440,48.429680 -123.407501,48.429577 -123.406906,48.430084 -123.406563,48.430309 -123.406441,48.430984 -123.405647,48.431583 -123.404892,48.431747 -123.404732,48.432968 -123.403976,48.432964 -123.404572,48.432770 -123.404633,48.432186 -123.405083,48.432323 -123.405518,48.432095 -123.405739,48.432266 -123.406204,48.431599 -123.408112,48.431198 -123.407753,48.430878 -123.408417,48.431046 -123.409386,48.431480 -123.409248,48.431221 -123.410378,48.431213 -123.411636,48.430637 -123.411858,48.430679 -123.413078,48.430202 -123.413139,48.430199 -123.413696,48.430161 -123.414742,48.429920 -123.416962,48.432709 -123.416893,48.433071 -123.417183,48.433121 -123.417839,48.432259 -123.418289,48.432320 -123.420319,48.429821 -123.420418,48.429649 -123.421852,48.430359 -123.422081,48.430241 -123.424461)))') WHERE name = 'esquimalt-south-pink';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Victoria'),'esquimalt-north-blue','Esquimalt North-blue','esquimalt-north-blue','40000000','99FFFF33');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((48.433857 -123.417091,48.433849 -123.417740,48.433025 -123.417137,48.432720 -123.416893,48.430431 -123.416931,48.430481 -123.416443,48.432877 -123.416191,48.433285 -123.417137,48.433506 -123.416840,48.433857 -123.417091)),((48.434536 -123.417862,48.434723 -123.417160,48.434525 -123.416878,48.434624 -123.416367,48.434982 -123.416206,48.435108 -123.416786,48.435474 -123.416710,48.435394 -123.414864,48.436714 -123.415703,48.436844 -123.414856,48.436455 -123.414764,48.436569 -123.413696,48.435852 -123.413513,48.436111 -123.410683,48.436848 -123.411575,48.437000 -123.410355,48.437809 -123.410538,48.437527 -123.413673,48.437973 -123.413788,48.437420 -123.418976,48.437431 -123.419167,48.437534 -123.419296,48.438225 -123.419212,48.438675 -123.420776,48.439011 -123.420174,48.440300 -123.420883,48.442421 -123.417595,48.444157 -123.420685,48.441715 -123.427704,48.441013 -123.426765,48.440308 -123.425858,48.439159 -123.428596,48.438747 -123.428291,48.438408 -123.427956,48.438133 -123.427551,48.438042 -123.427299,48.437843 -123.426544,48.437725 -123.424904,48.437527 -123.422379,48.437038 -123.417442,48.436737 -123.417366,48.436356 -123.417076,48.436180 -123.417068,48.436008 -123.417099,48.435455 -123.417404,48.434536 -123.417862)))') WHERE name = 'esquimalt-north-blue';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Victoria'),'esquimalt-south-yellow','Esquimalt South-yellow','esquimalt-south-yellow','40000000','9900FFFF');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((48.427238 -123.407608,48.428360 -123.407249,48.429569 -123.406914,48.429668 -123.407501,48.430305 -123.407440,48.430492 -123.409302,48.430012 -123.409492,48.429962 -123.409119,48.430283 -123.408943,48.430096 -123.407639,48.429550 -123.407661,48.429581 -123.407944,48.429119 -123.407997,48.429249 -123.408669,48.428749 -123.408859,48.428532 -123.408730,48.428139 -123.408836,48.428200 -123.409447,48.427528 -123.409653,48.428051 -123.413551,48.424351 -123.415710,48.423870 -123.415222,48.423908 -123.414909,48.423870 -123.414467,48.423340 -123.414642,48.422298 -123.413673,48.422329 -123.415024,48.421139 -123.416008,48.419510 -123.414574,48.418152 -123.411781,48.418259 -123.410858,48.421581 -123.409302,48.422932 -123.408302,48.422932 -123.406723,48.423168 -123.406670,48.423222 -123.406013,48.424980 -123.405388,48.425251 -123.406631,48.426128 -123.406288,48.426250 -123.407211,48.427158 -123.406990,48.427238 -123.407608)))') WHERE name = 'esquimalt-south-yellow';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Victoria'),'esquimalt-south-green','Esquimalt South-green','esquimalt-south-green','40000000','9933FF33');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((48.428055 -123.413559,48.428169 -123.414436,48.428261 -123.415291,48.428284 -123.416084,48.428318 -123.418640,48.428383 -123.421837,48.428383 -123.422760,48.428303 -123.423615,48.427925 -123.423584,48.427921 -123.424622,48.425369 -123.424522,48.425278 -123.423080,48.426140 -123.422890,48.425697 -123.421890,48.425655 -123.418961,48.424603 -123.419693,48.423717 -123.418480,48.424671 -123.417664,48.424088 -123.415932,48.423527 -123.416306,48.423096 -123.415855,48.422722 -123.415733,48.422340 -123.415642,48.422310 -123.413681,48.422863 -123.414207,48.423145 -123.414459,48.423420 -123.414742,48.423958 -123.415314,48.424358 -123.415726,48.424572 -123.415619,48.426334 -123.414604,48.426765 -123.414345,48.427197 -123.414101,48.428055 -123.413559)))') WHERE name = 'esquimalt-south-green';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Victoria'),'esquimalt-south-blue','Esquimalt South-blue2','esquimalt-south-blue','40000000','99FFFF33');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((48.430790 -123.413834,48.430988 -123.413116,48.431141 -123.412392,48.431000 -123.412361,48.430870 -123.413033,48.430691 -123.413063,48.430649 -123.411827,48.431221 -123.411629,48.431221 -123.410400,48.431480 -123.409241,48.431042 -123.409378,48.430882 -123.408409,48.431198 -123.407753,48.431610 -123.408127,48.432259 -123.406181,48.432091 -123.405731,48.432323 -123.405518,48.432720 -123.406174,48.432922 -123.405251,48.432968 -123.404823,48.432968 -123.404305,48.433670 -123.404282,48.433701 -123.404030,48.433998 -123.404022,48.434059 -123.404823,48.433590 -123.404823,48.432758 -123.407532,48.433472 -123.407860,48.432880 -123.408897,48.432652 -123.411636,48.431278 -123.412529,48.430920 -123.414749,48.430099 -123.415482,48.430210 -123.413834,48.430790 -123.413834)),((48.430019 -123.406281,48.429508 -123.406487,48.429550 -123.406693,48.430073 -123.406425,48.430073 -123.406548,48.429565 -123.406876,48.429558 -123.406906,48.429470 -123.406929,48.427528 -123.407516,48.427792 -123.407097,48.428398 -123.406937,48.428089 -123.404083,48.427639 -123.404373,48.427559 -123.403702,48.427990 -123.403542,48.427952 -123.402763,48.429508 -123.399712,48.428589 -123.398956,48.428108 -123.396820,48.428501 -123.396210,48.428490 -123.394501,48.430729 -123.394157,48.432961 -123.394218,48.433270 -123.395111,48.433731 -123.402367,48.434132 -123.402206,48.434189 -123.403107,48.433922 -123.403412,48.433971 -123.403580,48.433270 -123.403809,48.432720 -123.403168,48.432430 -123.404083,48.431381 -123.404297,48.430630 -123.403381,48.429569 -123.404221,48.429951 -123.405693,48.429958 -123.405861,48.429508 -123.406029,48.429562 -123.406281,48.430000 -123.406090,48.430019 -123.406281)))') WHERE name = 'esquimalt-south-blue';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Victoria'),'esquimalt-north-orange','Esquimalt North-orange2','esquimalt-north-orange','40000000','990099FF');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((48.441872 -123.402191,48.442848 -123.401848,48.444618 -123.405678,48.444580 -123.406082,48.445450 -123.407951,48.445648 -123.407982,48.445869 -123.408531,48.446732 -123.407913,48.447128 -123.407867,48.447491 -123.407944,48.448021 -123.408478,48.448410 -123.409111,48.448792 -123.409592,48.448891 -123.409653,48.449032 -123.409973,48.449089 -123.410179,48.449020 -123.410942,48.449261 -123.411583,48.449280 -123.411812,48.449150 -123.412804,48.449261 -123.413239,48.449509 -123.413910,48.450180 -123.414688,48.450500 -123.415298,48.450630 -123.415840,48.450851 -123.417267,48.451172 -123.418343,48.451382 -123.418533,48.451519 -123.418747,48.451591 -123.419197,48.451141 -123.420174,48.450981 -123.420860,48.450859 -123.422173,48.451149 -123.422981,48.451691 -123.423477,48.451778 -123.423607,48.451450 -123.424202,48.451050 -123.424728,48.450619 -123.423950,48.450298 -123.423218,48.450089 -123.422470,48.449780 -123.420868,48.449661 -123.420609,48.448841 -123.419403,48.448589 -123.418930,48.447990 -123.415993,48.446880 -123.413071,48.444233 -123.407661,48.442909 -123.404984,48.442184 -123.403397,48.441872 -123.402191)),((48.441715 -123.427711,48.440788 -123.429489,48.440060 -123.429237,48.439163 -123.428604,48.440308 -123.425873,48.441715 -123.427711)))') WHERE name = 'esquimalt-north-orange';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Victoria'),'esquimalt-north-pink','Esquimalt North-pink','esquimalt-north-pink','40000000','99CC33CC');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((48.433990 -123.403648,48.433922 -123.403412,48.434189 -123.403107,48.434139 -123.402206,48.433720 -123.402359,48.433311 -123.395882,48.433239 -123.394310,48.435379 -123.394073,48.437519 -123.393631,48.438774 -123.393288,48.438728 -123.394958,48.438221 -123.394920,48.438171 -123.395882,48.437462 -123.395866,48.437389 -123.399010,48.437389 -123.400749,48.437859 -123.400688,48.437920 -123.401993,48.438782 -123.401581,48.438862 -123.402023,48.439259 -123.401970,48.439289 -123.400963,48.439529 -123.400993,48.439529 -123.401627,48.440239 -123.401398,48.440239 -123.400749,48.441181 -123.400620,48.441101 -123.401161,48.441540 -123.401421,48.441860 -123.402153,48.439529 -123.402969,48.439522 -123.406990,48.439560 -123.411018,48.439968 -123.411911,48.438251 -123.411407,48.437969 -123.413757,48.437531 -123.413673,48.438049 -123.407532,48.437870 -123.406128,48.437752 -123.405479,48.436829 -123.402611,48.433990 -123.403648)))') WHERE name = 'esquimalt-north-pink';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Victoria'),'esquimalt-north-green','Esquimalt North-green','esquimalt-north-green','40000000','9933FF33');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((48.432972 -123.404289,48.432972 -123.403992,48.436821 -123.402634,48.437740 -123.405510,48.437870 -123.406113,48.438042 -123.407532,48.437569 -123.407677,48.437481 -123.409233,48.437889 -123.409523,48.437820 -123.410522,48.436989 -123.410339,48.436840 -123.411568,48.436131 -123.410690,48.435520 -123.410110,48.434181 -123.411507,48.435329 -123.413391,48.436562 -123.413673,48.436451 -123.414757,48.436840 -123.414871,48.436710 -123.415680,48.435379 -123.414848,48.435471 -123.416710,48.435120 -123.416779,48.434978 -123.416199,48.434620 -123.416367,48.434521 -123.416893,48.434719 -123.417137,48.434521 -123.417862,48.434361 -123.417900,48.434181 -123.417900,48.433861 -123.417770,48.433849 -123.417084,48.433498 -123.416832,48.433281 -123.417137,48.432869 -123.416183,48.430481 -123.416443,48.430420 -123.416924,48.429932 -123.416946,48.430099 -123.415497,48.430931 -123.414757,48.431290 -123.412529,48.432659 -123.411652,48.432880 -123.408897,48.433479 -123.407867,48.433781 -123.408051,48.433720 -123.408592,48.434391 -123.408379,48.436089 -123.406960,48.436359 -123.407181,48.436722 -123.406311,48.434750 -123.404877,48.434059 -123.404823,48.433990 -123.404053,48.433701 -123.404083,48.433651 -123.404282,48.432972 -123.404289)))') WHERE name = 'esquimalt-north-green';

INSERT INTO zones (id, area_id, name, title, colour_name, line_colour, poly_colour)
    VALUES (nextval('zone_seq'),(SELECT id FROM areas WHERE name = 'Victoria'),'esquimalt-north-yellow','Esquimalt North-yellow','esquimalt-north-yellow','40000000','9900FFFF');
UPDATE zones SET geom = ST_GeomFromText('MULTIPOLYGON(((48.442848 -123.401840,48.441872 -123.402153,48.441540 -123.401413,48.441101 -123.401161,48.441181 -123.400620,48.440239 -123.400749,48.440239 -123.399986,48.438881 -123.399971,48.438961 -123.400932,48.439289 -123.400963,48.439259 -123.401970,48.438869 -123.402008,48.438782 -123.401573,48.437931 -123.401978,48.437870 -123.400940,48.438347 -123.400887,48.438454 -123.400757,48.438766 -123.400734,48.438839 -123.395805,48.438847 -123.394974,48.438732 -123.394958,48.438778 -123.393288,48.439495 -123.393074,48.439827 -123.393967,48.442333 -123.392708,48.442596 -123.393517,48.442852 -123.394104,48.442875 -123.394722,48.443329 -123.395378,48.443321 -123.396637,48.443394 -123.398148,48.443523 -123.398537,48.443951 -123.398964,48.444874 -123.398537,48.445587 -123.398788,48.446140 -123.400436,48.445301 -123.400917,48.445492 -123.401604,48.445469 -123.402382,48.445679 -123.402603,48.445740 -123.402817,48.445820 -123.403419,48.445808 -123.403770,48.445702 -123.404091,48.445438 -123.404549,48.445332 -123.404640,48.444790 -123.404701,48.444630 -123.405693,48.442848 -123.401840)))') WHERE name = 'esquimalt-north-yellow';



-- Now the schedule data
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-01-13 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-01-27 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-02-10 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-02-24 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-03-10 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-03-24 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-04-07 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-04-21 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-05-05 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-05-19 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-06-02 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-06-16 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-06-30 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-07-14 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-7-28 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-8-11 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-8-25 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-9-8 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-9-22 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-10-6 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-10-20 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-11-3 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-11-17 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-12-1 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-12-15 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-blue'),
           '2011-12-29 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-1-10 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-1-24 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-2-7 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-2-21 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-3-7 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-3-21 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-4-4 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-4-18 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-5-2 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-5-16 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-5-30 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-6-13 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-6-27 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-7-11 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-7-25 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-8-8 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-8-22 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-9-19 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-10-3 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-10-17 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-10-31 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-11-14 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-11-28 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-green'),
           '2011-12-12 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-1-12 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-1-26 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-2-9 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-2-23 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-3-9 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-3-23 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-4-6 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-4-20 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-5-4 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-5-18 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-6-1 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-6-15 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-6-29 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-7-13 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-7-27 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-8-10 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-8-24 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-9-7 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-9-21 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-10-5 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-10-19 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-11-2 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-11-16 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-11-30 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-12-14 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-orange'),
           '2011-12-28 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-1-14 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-1-28 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-2-11 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-2-25 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-3-11 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-3-25 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-4-8 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-4-22 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-5-6 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-5-20 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-6-3 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-6-17 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-7-15 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-7-29 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-8-12 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-8-26 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-9-9 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-9-23 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-10-7 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-10-21 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-11-4 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-11-18 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-12-2 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-12-16 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-pink'),
           '2011-12-30 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-1-11 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-1-25 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-2-8 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-2-22 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-3-8 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-3-22 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-4-5 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-4-19 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-5-3 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-5-17 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-5-31 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-6-14 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-6-28 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-7-12 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-7-26 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-8-9 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-8-23 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-9-6 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-9-20 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-10-4 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-10-18 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-11-1 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-11-15 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-11-29 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-north-yellow'),
           '2011-12-13 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-1-6 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-1-20 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-2-3 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-2-17 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-3-3 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-3-17 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-3-31 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-4-14 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-4-28 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-5-12 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-5-26 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-6-9 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-6-23 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-7-7 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-7-21 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-8-4 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-8-18 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-9-1 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-9-15 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-9-29 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-10-13 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-10-27 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-11-10 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-11-24 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-12-8 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-blue'),
           '2011-12-22 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-1-17 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-1-31 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-2-14 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-2-28 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-3-14 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-3-28 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-4-11 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-5-9 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-5-23 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-6-6 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-6-20 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-7-4 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-7-18 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-8-15 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-8-29 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-9-12 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-9-26 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-10-10 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-10-24 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-11-7 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-11-21 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-12-5 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-green'),
           '2011-12-19 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-1-5 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-1-19 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-2-2 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-2-16 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-3-2 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-3-16 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-3-30 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-4-13 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-4-27 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-5-11 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-5-25 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-6-8 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-6-22 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-7-6 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-7-20 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-8-3 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-8-17 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-8-31 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-9-14 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-9-28 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-10-12 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-10-26 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-11-9 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-11-23 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-12-7 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-orange'),
           '2011-12-21 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-1-7 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-1-21 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-2-4 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-2-18 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-3-4 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-3-18 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-4-1 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-4-15 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-4-29 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-5-13 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-5-27 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-6-10 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-6-24 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-7-8 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-7-22 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-8-5 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-8-19 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-9-2 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-9-16 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-9-30 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-10-14 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-10-28 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-11-25 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-12-9 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-pink'),
           '2011-12-23 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-1-4 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-1-18 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-2-1 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-2-15 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-3-1 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-3-15 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-3-29 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-4-12 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-4-26 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-5-10 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-5-24 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-6-7 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-6-21 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-7-5 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-7-19 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-8-2 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-8-16 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-8-30 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-9-13 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-9-27 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-10-11 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-10-25 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-11-8 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-11-22 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-12-6 07:00:00-08', 'G');
INSERT INTO pickups (id, zone_id, day, flags)
    VALUES (nextval('pickup_seq'),
           (SELECT id FROM zones WHERE name = 'esquimalt-south-yellow'),
           '2011-12-20 07:00:00-08', 'G');

COMMIT;

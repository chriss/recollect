BEGIN;

CREATE TABLE ad_clicks (
    at timestamptz DEFAULT 'now'::timestamptz NOT NULL,
    area_id integer references areas(id) NOT NULL
);
CREATE INDEX ad_clicks_area_idx ON ad_clicks (area_id);
CREATE INDEX ad_clicks_at_idx ON ad_clicks (at);
CREATE INDEX ad_clicks_at_area_idx ON ad_clicks (area_id, at);
ALTER TABLE ad_clicks OWNER TO recollect;

CREATE TABLE zone_views (
    at timestamptz DEFAULT 'now'::timestamptz NOT NULL,
    zone_id integer references zones(id) NOT NULL
);
CREATE INDEX zone_views_zone_idx ON zone_views (zone_id);
CREATE INDEX zone_views_at_idx ON zone_views (at);
CREATE INDEX zone_views_at_zone_idx ON zone_views (zone_id, at);
ALTER TABLE zone_views OWNER TO recollect;

DELETE FROM recollect_schema;
INSERT INTO recollect_schema (current_version) VALUES (10);

COMMIT;

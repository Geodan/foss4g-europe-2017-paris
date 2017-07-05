select plv8_startup();
do language plv8 'load_module("d3")';
do language plv8 'load_module("topojson")';
drop table if exists gadm.test2;
create table gadm.test2 as
with boxes as (select a.objectid inid, -999 id, ST_ExteriorRing(ST_MakeEnvelope(-180, -90, 180, 90, 4326)) wkb_geometry from gadm.adm1 a
),
entities as (select a.objectid inid, b.objectid id, b.wkb_geometry
    from gadm.adm1 a, gadm.adm1 b
      where st_intersects(a.wkb_geometry,b.wkb_geometry) -- a.unregion1='Western Europe'),
--     and a.objectid > 80 and a.objectid < 160
)
,combined as (select * from boxes
  -- where inid >= 2017 and inid <= 2024
  union all select * from entities
)
,properties as (select inid, id from combined)
-- select * from properties;
,geometry as (select inid,id, st_asgeojson(wkb_geometry) geom from combined)
,features AS (
    select '{"type": "Feature"}'::JSONB ||
       jsonb_set('{}'::JSONB,'{properties}',row_to_json(p)::JSONB) ||
           jsonb_set('{}'::JSONB,'{geometry}',geom::JSONB)
        as feat
         from  properties p  INNER JOIN geometry g USING(inid, id)
)
--select feat->'properties'->>'inid', feat->'properties'->>'id', feat->'geometry' from features;
,topojson AS (
    select plv8.d3_totopojson('{"type": "FeatureCollection"}'::JSONB ||
        jsonb_set('{}'::JSONB, '{features}',jsonb_agg(feat))
        ,1e7) AS topojson
      FROM features
        GROUP BY feat->'properties'->>'inid'
)
-- select * from topojson;
,simplified AS (
    SELECT plv8.d3_SimplifyTopology(topojson,0.0001) as topojson
            FROM topojson
)
-- select * from simplified;
,restoredfeatures AS (
    SELECT  plv8.d3_topologytofeatures(topojson) AS feat
        FROM simplified
)
SELECT
    feat->'properties'->>'id' as id_0,
    feat->'properties'->>'inid' as objectid,
    ST_SETSRID(ST_GeomFromGeoJSON((feat->'geometry')::text), 4326) geom
        FROM restoredfeatures
        WHERE feat->'properties'->>'id' = feat->'properties'->>'inid'
        ;

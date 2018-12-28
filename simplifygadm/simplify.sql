select plv8_startup();
do language plv8 'load_module("d3")';
do language plv8 'load_module("topojson")';
drop table if exists gadm.gadm_simplified;
create table gadm.gadm_simplified as
with entities as (select a.objectid inid, b.objectid id, b.wkb_geometry
    from gadm.gadm a, gadm.gadm b
      where st_intersects(a.wkb_geometry,b.wkb_geometry)) -- a.unregion1='Western Europe'),
,properties as (select inid, id from entities)
-- select * from properties;
,geometry as (select inid,id, st_asgeojson(wkb_geometry) geom from entities)
,features AS (
    select '{"type": "Feature"}'::JSONB ||
       jsonb_set('{}'::JSONB,'{properties}',row_to_json(p)::JSONB) ||
	   jsonb_set('{}'::JSONB,'{geometry}',geom::JSONB)
	as feat
	 from  properties p  INNER JOIN geometry g USING(inid, id)    
)
--select feat->'properties'->>'inid', feat->'properties'->'namein', feat->'properties'->>'id', feat->'properties'->'nameout' from features;
,topojson AS (
    select plv8.d3_totopojson('{"type": "FeatureCollection"}'::JSONB ||
			    jsonb_set('{}'::JSONB, '{features}',jsonb_agg(feat))
		        ,1e8) AS topojson
      FROM features
        GROUP BY feat->'properties'->>'inid'
)
-- select * from topojson;
,simplified AS (
    SELECT plv8.d3_SimplifyTopology(topojson,0.0001) as topojson
	    FROM topojson
)
--select * from simplified;
,restoredfeatures AS (
    SELECT
          plv8.d3_topologytofeatures(topojson) AS feat
 	    FROM simplified
)
SELECT
    feat->'properties'->>'id' as id_0,
    feat->'properties'->>'inid' as objectid,
    ST_SETSRID(ST_GeomFromGeoJSON((feat->'geometry')::text), 4326) geom
	FROM restoredfeatures
	WHERE feat->'properties'->>'id' = feat->'properties'->>'inid';

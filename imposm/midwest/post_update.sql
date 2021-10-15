-- Recreate generalized and merged layers

-- Routes, merged by ref/network

DROP TABLE IF EXISTS midwest_mergedroutes;

CREATE TABLE midwest_mergedroutes (
	id SERIAL PRIMARY KEY,
	ref VARCHAR,
	network VARCHAR,
	route_type VARCHAR
);

SELECT AddGeometryColumn('public'::varchar,
						 'midwest_mergedroutes'::varchar,
						 'geometry'::varchar,
						 3857,
						 'GEOMETRY'::varchar,
						 2);

BEGIN;

WITH a AS(
	SELECT   ref,
			 network,
			 type,
			 st_collect(geometry) AS geometry
	FROM     midwest_routes
	WHERE    ref <> '' and network <> ''
	GROUP BY network, ref, type
)

INSERT INTO midwest_mergedroutes (ref, network, route_type, geometry)
SELECT ref, network, type, geometry FROM a;

COMMIT;

CREATE INDEX sidx_midwest_mergedroutes
  ON midwest_mergedroutes
  USING GIST (geometry);


-- Routes, generalized by 50m

DROP TABLE IF EXISTS midwest_mergedroutes_gen50;

CREATE TABLE midwest_mergedroutes_gen50 (
	id SERIAL PRIMARY KEY,
	ref VARCHAR,
	network VARCHAR,
	route_type VARCHAR
);

SELECT AddGeometryColumn('public'::varchar,
						 'midwest_mergedroutes_gen50'::varchar,
						 'geometry'::varchar,
						 3857,
						 'GEOMETRY'::varchar,
						 2);

BEGIN;

WITH a AS(
	SELECT   ref,
			 network,
			 type,
			 st_simplifypreservetopology(st_collect(geometry), 50) AS geometry
	FROM     midwest_routes
	WHERE    ref <> '' and network <> ''
	GROUP BY network, ref, type
)

INSERT INTO midwest_mergedroutes_gen50 (ref, network, route_type, geometry)
SELECT ref, network, type, geometry FROM a;

COMMIT;

CREATE INDEX sidx_midwest_mergedroutes_gen50
  ON midwest_mergedroutes_gen50
  USING GIST (geometry);

-- Routes, generalized by 200 m

DROP TABLE IF EXISTS midwest_mergedroutes_gen200;

CREATE TABLE midwest_mergedroutes_gen200 (
	id SERIAL PRIMARY KEY,
	ref VARCHAR,
	network VARCHAR,
	route_type VARCHAR
);

SELECT AddGeometryColumn('public'::varchar,
						 'midwest_mergedroutes_gen200'::varchar,
						 'geometry'::varchar,
						 3857,
						 'GEOMETRY'::varchar,
						 2);


BEGIN;

WITH a AS(
	SELECT   ref,
			 network,
			 type,
			 st_simplifypreservetopology(st_collect(geometry), 200) AS geometry
	FROM     midwest_routes
	WHERE    ref <> '' and network <> ''
	GROUP BY network, ref, type
)

INSERT INTO midwest_mergedroutes_gen200 (ref, network, route_type, geometry)
SELECT ref, network, type, geometry FROM a;

COMMIT;

CREATE INDEX sidx_midwest_mergedroutes_gen200
  ON midwest_mergedroutes_gen200
  USING GIST (geometry);
  
-- Water areas, generalized by 200m, excluding waterways for small scale

DROP TABLE IF EXISTS midwest_water_gen200;

CREATE TABLE midwest_water_gen200 (
	id SERIAL PRIMARY KEY,
	name VARCHAR,
	type VARCHAR
);

SELECT AddGeometryColumn('public'::varchar,
						 'midwest_water_gen200'::varchar,
						 'geometry'::varchar,
						 3857,
						 'GEOMETRY'::varchar,
						 2);

BEGIN;

WITH a AS(
	SELECT   osm_id,
	         name,
			 type,
	         st_simplifypreservetopology(geometry, 200) AS geometry
	FROM     midwest_water
	WHERE    intermittent = 0 and st_area(geometry) > 1000000 and type not in ('river', 'stream', 'swimming_pool', 'oxbow', 'lock')
)

INSERT INTO midwest_water_gen200 (name, type, geometry)
SELECT name, type, geometry FROM a;

COMMIT;

CREATE INDEX sidx_midwest_water_gen200
  ON midwest_water_gen200
  USING GIST (geometry);
  
-- Water areas, generalized by 50m

DROP TABLE IF EXISTS midwest_water_gen50;

CREATE TABLE midwest_water_gen50 (
	id SERIAL PRIMARY KEY,
	name VARCHAR,
	type VARCHAR
);

SELECT AddGeometryColumn('public'::varchar,
						 'midwest_water_gen50'::varchar,
						 'geometry'::varchar,
						 3857,
						 'GEOMETRY'::varchar,
						 2);

BEGIN;

WITH a AS(
	SELECT   osm_id,
	         name,
			 type,
	         st_simplifypreservetopology(geometry, 50) AS geometry
	FROM     midwest_water
	WHERE    intermittent = 0 and st_area(geometry) > 100000
	)

INSERT INTO midwest_water_gen50 (name, type, geometry)
SELECT name, type, geometry FROM a;

COMMIT;

CREATE INDEX sidx_midwest_water_gen50
  ON midwest_water_gen50
  USING GIST (geometry);
  
-- Waterways, generalized by 200 m

DROP TABLE IF EXISTS midwest_waterways_gen200;

CREATE TABLE midwest_waterways_gen200 (
	id SERIAL PRIMARY KEY,
	name VARCHAR,
	type VARCHAR
);

SELECT AddGeometryColumn('public'::varchar,
						 'midwest_waterways_gen200'::varchar,
						 'geometry'::varchar,
						 3857,
						 'GEOMETRY'::varchar,
						 2);


BEGIN;

WITH a AS(
	SELECT   name,
		     type,
	         st_simplifypreservetopology(st_collect(geometry), 200) AS geometry
	FROM     midwest_waterways
	WHERE    intermittent = 0
	GROUP BY name, type
)

INSERT INTO midwest_waterways_gen200 (name, type, geometry)
SELECT ref, network, geometry FROM a;

COMMIT;

CREATE INDEX sidx_midwest_waterways_gen200
  ON midwest_waterways_gen200
  USING GIST (geometry);
  
-- Generalized waterways 50m, all types

DROP TABLE IF EXISTS midwest_waterways_gen50;

CREATE TABLE midwest_waterways_gen50 (
	id SERIAL PRIMARY KEY,
	name VARCHAR,
	type VARCHAR
);

SELECT AddGeometryColumn('public'::varchar,
						 'midwest_waterways_gen50'::varchar,
						 'geometry'::varchar,
						 3857,
						 'GEOMETRY'::varchar,
						 2);


BEGIN;

WITH a AS(
	SELECT   name,
			 type,
	         st_simplifypreservetopology(st_collect(geometry), 50) AS geometry
	FROM     midwest_waterways
	WHERE    intermittent = 0
	GROUP BY name, type
)

INSERT INTO midwest_waterways_gen50 (name, type, geometry)
SELECT name, type, geometry FROM a;

COMMIT;

CREATE INDEX sidx_midwest_waterways_gen50
  ON midwest_waterways_gen50
  USING GIST (geometry);
  
-- Points of interest and centroids of points

DROP TABLE IF EXISTS midwest_poi;

CREATE TABLE midwest_poi (
	id SERIAL PRIMARY KEY,
	osm_id BIGINT,
	name VARCHAR,
	type VARCHAR,
	class VARCHAR,
	hstore hstore

);

SELECT AddGeometryColumn('public'::varchar,
						 'midwest_poi'::varchar,
						 'geometry'::varchar,
						 3857,
						 'POINT'::varchar,
						 2);


BEGIN;

WITH a AS(
	SELECT   osm_id,
			 name,
			 type,
			 class,
			 hstore,
	         geometry
	FROM     midwest_points_of_interest
	UNION
	SELECT   osm_id,
			 name,
			 type,
			 class,
			 hstore,
	         st_pointonsurface(geometry) geometry
	FROM     midwest_areas_of_interest
)

INSERT INTO midwest_poi (osm_id, name, type, class, hstore, geometry)
SELECT osm_id, name, type, class, hstore, geometry FROM a;

COMMIT;

CREATE INDEX sidx_midwest_pois
  ON midwest_poi
  USING GIST (geometry);


-- Add array column for indoor levels
ALTER TABLE midwest_indoor_areas 
ADD COLUMN level_arr INTEGER[];

ALTER TABLE midwest_indoor_lines 
ADD COLUMN level_arr INTEGER[];

ALTER TABLE midwest_indoor_points
ADD COLUMN level_arr INTEGER[];

-- Populate level arrays
UPDATE midwest_indoor_areas
SET level_arr = STRING_TO_ARRAY(level, ';');

UPDATE midwest_indoor_lines
SET level_arr = STRING_TO_ARRAY(level, ';');

UPDATE midwest_indoor_points
SET level_arr = STRING_TO_ARRAY(level, ';');


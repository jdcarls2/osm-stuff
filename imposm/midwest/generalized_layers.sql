-- Recreate generalized layers

-- Road routes, generalized 50 m

DROP TABLE IF EXISTS midwest_roadroutes_gen50;

CREATE TABLE midwest_roadroutes_gen50 (
	id SERIAL PRIMARY KEY,
	ref VARCHAR,
	network VARCHAR
);

SELECT AddGeometryColumn('public'::varchar,
						 'midwest_roadroutes_gen50'::varchar,
						 'geometry'::varchar,
						 3857,
						 'GEOMETRY'::varchar,
						 2);

BEGIN;

WITH a AS(
	SELECT   osm_id,
	         ref,
		     network,
	         st_simplifypreservetopology(st_collect(geometry), 50) AS geometry
	FROM     midwest_routes
	WHERE    type = 'road'
	GROUP BY osm_id, network, ref
)

INSERT INTO midwest_roadroutes_gen50 (ref, network, geometry)
SELECT ref, network, geometry FROM a;

COMMIT;

CREATE INDEX sidx_midwest_roadroutes_gen50
  ON midwest_roadroutes_gen50
  USING GIST (geometry);

-- Road routes, generalized by 200 m

DROP TABLE IF EXISTS midwest_roadroutes_gen200;

CREATE TABLE midwest_roadroutes_gen200 (
	id SERIAL PRIMARY KEY,
	ref VARCHAR,
	network VARCHAR
);

SELECT AddGeometryColumn('public'::varchar,
						 'midwest_roadroutes_gen200'::varchar,
						 'geometry'::varchar,
						 3857,
						 'GEOMETRY'::varchar,
						 2);


BEGIN;

WITH a AS(
	SELECT   osm_id,
	         ref,
		     network,
	         st_simplifypreservetopology(st_collect(geometry), 200) AS geometry
	FROM     midwest_routes
	WHERE    type = 'road'
	GROUP BY osm_id, network, ref
)

INSERT INTO midwest_roadroutes_gen200 (ref, network, geometry)
SELECT ref, network, geometry FROM a;

COMMIT;

CREATE INDEX sidx_midwest_roadroutes_gen200
  ON midwest_roadroutes_gen200
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
  
  
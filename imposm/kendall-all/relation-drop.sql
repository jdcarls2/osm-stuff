WITH a AS (
    SELECT the_geom
    FROM kendall_areas
    WHERE tags->'name' = 'Kendall County'
),
b AS(
    SELECT *
    FROM kendall_relation_members b
        JOIN a ON ST_INTERSECTS(a.the_geom, b.the_geom)
)
DELETE
FROM kendall_relation_members c
WHERE NOT EXISTS (
        SELECT *
        FROM b
        WHERE b.osm_id = c.osm_id
    )
    AND geom_type = 1
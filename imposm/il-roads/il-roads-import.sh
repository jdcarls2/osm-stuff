#!/bin/bash
# remove prior import dirs
rm -r ./imposm_diff
rm -r ./imposm_cache
# get new pbf file
cd ./data
wget -N https://download.geofabrik.de/north-america/us/illinois-latest.osm.pbf
# import new data
cd ../../imposm
./imposm import -config ../il-roads/config.json -read ../il-roads/data/illinois-latest.osm.pbf -write -diff -diffdir ../il-roads/imposm_diff -optimize -deployproduction
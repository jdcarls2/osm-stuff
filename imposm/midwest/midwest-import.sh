#!/bin/bash
# remove prior import dirs
rm -r ./imposm_diff
rm -r ./imposm_cache
# get new pbf file
cd ./data
wget -N https://download.geofabrik.de/north-america/us-midwest-latest.osm.pbf
wget -N https://download.geofabrik.de/north-america/us-midwest-updates/state.txt
# import new data
cd ../../imposm
./imposm import -config ../midwest/config.json -read ../midwest/data/us-midwest-latest.osm.pbf -write -diff -diffdir ../midwest/imposm_diff -optimize -deployproduction
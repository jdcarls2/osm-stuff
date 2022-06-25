#!/bin/bash
# remove prior import dirs
cd /home/joshua/osm-stuff/imposm/midwest
rm -r ./imposm_diff
rm -r ./imposm_cache
# get new pbf file
cd /home/joshua/osm-stuff/imposm/midwest/data
wget -N https://download.geofabrik.de/north-america/us-midwest-latest.osm.pbf
# import new data
cd ../imposm
./imposm import -config ../midwest/config.json -read ../midwest/us-midwest-latest.osm.pbf -write -diff -diffdir ../midwest/imposm_diff -optimize -deployproduction
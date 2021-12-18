#!/bin/bash
# remove prior import dirs
cd /home/joshua/osm-stuff/imposm/il-roads
rm -r ./imposm_diff
rm -r ./imposm_cache
# get new pbf file
cd /home/joshua/osm-stuff/imposm/il-roads/data
wget -N https://download.geofabrik.de/north-america/us/illinois-latest.osm.pbf
# import new data
cd /home/joshua/osm-stuff/imposm/imposm-0.11.1-linux-x86-64
./imposm import -config ../il-roads/config.json -read ../il-roads/data/us-illinois-latest.osm.pbf -write -diff -diffdir ../il-roads/imposm_diff -optimize -deployproduction
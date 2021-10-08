#!/bin/bash
# remove prior import dirs
cd /home/joshua/osm-stuff/imposm/midwest
rm -r ./imposm_diff
rm -r ./imposm_cache
# import new data
cd /home/joshua/osm-stuff/imposm/imposm-0.11.1-linux-x86-64
./imposm import -config ../midwest/config.json -read ../midwest/data/us-midwest-latest.osm.pbf -write -diff -diffdir ../midwest/imposm_diff -optimize -deployproduction
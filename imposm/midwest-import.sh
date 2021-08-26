#!/bin/bash
cd /home/joshua/osm-stuff/imposm/imposm-0.11.1-linux-x86-64
./imposm import -config ../midwest/config.json -read ../midwest/data/us-midwest-latest.osm.pbf -write -diff -diffdir ../midwest/imposm_diff -optimize -deployproduction
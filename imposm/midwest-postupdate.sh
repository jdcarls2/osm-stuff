#!/bin/bash
psql -h localhost -d osm -U osm -p 5432 -a -q -f /home/joshua/osm-stuff/imposm/midwest/generalized_layers.sql
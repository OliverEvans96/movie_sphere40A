#!/bin/bash
for partnum in {2..2}
do
    vmd -dispdev text -eofexit -e render_droplet.tcl -args $partnum
done

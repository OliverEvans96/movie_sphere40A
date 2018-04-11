#!/bin/bash

# Give a name to this render
rendername=double

mkdir -p render/img/$rendername render/scene/$rendername

for partnum in {4..4}
do
    vmd -dispdev text -eofexit -e render_droplet.tcl -args $rendername $partnum
done

ffmpeg -framerate 30 -i render/img/$rendername/%05d.tga -r 30 -c:v libx264 -crf 17 -pix_fmt yuv420p -y render/movie/$rendername.mp4


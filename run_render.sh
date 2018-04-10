#!/bin/bash
for partnum in {1..1}
do
    vmd -dispdev text -eofexit -e render_droplet.tcl -args $partnum
done

ffmpeg -framerate 30 -i render/img/%03d.tga -r 30 -c:v libx264 -pix_fmt yuv420p -y render/movie/test.mp4


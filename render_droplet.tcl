package require topotools
set home $::env(HOME)
#set base /home/oliver/academic/research/droplet/movie_sphere40A
set base $::env(PWD)
set tachyon $home/local/lib/vmd/tachyon_LINUXAMD64
# Just part number, e.g. 3 (for atom3)
set partnum [lindex $argv 0]

# Load molecule
topo readlammpsdata $base/data/lammps_noZperiod_3A.dat

# Background
color Display Background white

# No axes
axes location off

# Delete defaul representation
mol delrep top 0

# Substrate (Selection #0)
#mol color Name
#mol representation VDW 1 12
#mol selection type < 4
#mol material AOChalky
#mol addrep top

# Water (Selection #1)
mol color Name
mol representation VDW 1 12
mol selection type >= 4
mol material AOChalky
mol addrep top

# Al
color Name 1 gray
# O
color Name 2 blue3
# Substrate H
color Name 3 blue2
# O
color Name 4 red
# H
color Name 5 white

# Camera position
scale by 4
set elevation 30
set framesperrotation 100

# Polar angle
set polar [expr 90 - $elevation]
# Azimuthal degrees per MD frame
set azim_fstep [expr 360.0 / $framesperrotation]

# Multiple renders per MD frame for cool effect
# (camera motion is smoother than molecular motion)
set rendersperframe 5
set azim_rstep [expr $azim_fstep / $rendersperframe]

# Set to initial position
rotate x by -$polar

# Render settings
#display resize 1920 1080
display resize 800 450
display ambientocclusion on
display shadows on
display dof on
display dof_fnumber 56.906
display dof_focaldist 1.465

# Load frames
# Wait until last frame (-1) is loaded before proceeding.
mol addfile data/atom$partnum type {lammpstrj} first 0 last -1 waitfor -1
set numframes [molinfo top get numframes]
puts "atom$partnum: $numframes frames."

# Loop through frames
# Last one is a repeat, so skip
for {set i 0} {$i < $numframes-1} {incr i} {
    # Move to next frame (first one is unnecessary)
    #animate goto [expr $i + 1]
    molinfo top set frame [expr $i + 1]
    puts "Current frame: [molinfo top get frame]"
    # Assuming all previous parts have 500 frames
    set framenum [expr 500*($partnum-1) + $i]

    # Multiple renders per frame from different angles
    for {set j 0} {$j < $rendersperframe} {incr j} {
       # Rotate camera
       rotate x by $polar
       rotate z by [expr -$azim_rstep]
       rotate x by [expr -$polar]

       # Formatted render number
       set fmt_rn [format %05d [expr $rendersperframe * $framenum + $j]]
       puts "atom$partnum/$i-$j ($fmt_rn)"

       # Render
       render Tachyon render/scene/$fmt_rn.dat $tachyon -aasamples 12 %s -format TARGA -o render/img/$fmt_rn.tga
    }
}
exit

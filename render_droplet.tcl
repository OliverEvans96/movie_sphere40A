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

# Substrate (Selection #0)
mol modselect 0 top type < 4
mol modstyle 0 top VDW 1 12
mol modmaterial 0 top AOChalky

# Water (Selection #1)
mol addrep top
mol modselect 1 top type >= 4
mol modstyle 1 top VDW 1 12
mol modmaterial 1 top AOChalky

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
rotate x to 0
rotate y to 0
rotate z to 0
rotate z by 25
rotate x by -65
scale by 4

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
    animate goto [expr $i + 1]
    puts "Current frame: [molinfo top get frame]"
    # Assuming all previous parts have 500 frames
    set framenum [expr 500*($partnum-1) + $i]
    # Formatted frame number
    set fmt_fn [format %03d $framenum]
    puts "atom$partnum/$i ($fmt_fn)"
    # Render
    render Tachyon render/scene/$fmt_fn.dat $tachyon -aasamples 12 %s -format TARGA -o render/img/$fmt_fn.tga
}
exit

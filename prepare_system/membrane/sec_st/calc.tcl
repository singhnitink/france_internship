

set folders {1 2 3}
foreach x $folders {
mol delete all

mol new ../solv_ions.gro
mol addfile ../run${x}/viz.xtc waitfor all

set molid [molinfo top get id]

set outfile [open "sec_st_${x}.dat" w]

set nframes [molinfo top get numframes]
#puts $nframes

puts "Total number of frames: $nframes"

set sel [atomselect top "protein and name CA"]

for {set i 0} {$i < $nframes} {incr i} {

    animate goto $i
	vmd_calculate_structure $molid
	set structure [$sel get structure]
	puts $outfile [format "%d %s" $i $structure]

	#puts $i
}
close $outfile
}
exit

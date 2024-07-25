

set folders {1 2}
foreach x $folders {
mol delete all

mol new ../run${x}/cleaner.gro
mol addfile ../run${x}/cleaner.xtc step 1 waitfor all

set molid [molinfo top get id]

set outfile [open "sec_st_${x}.dat" w]

set nframes [molinfo top get numframes]
#puts $nframes

puts "Total number of frames: $nframes"

set sel [atomselect top "name CA"]

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

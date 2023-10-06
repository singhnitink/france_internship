#######********README******************##########
##1. go to the folder and load psf and dcd files
##2. source ss_traj.tcl
##3. start_sscache
##4. play the trajectory by clicking the arrow button on the main window
##5. Final file will be --- ss_traj.dat

##REF.. http://nefeli.mbg.duth.gr/cgi-bin/wiki.pl/Secondary_structure_analysis_of_protein_trajectories
#######********************************##########
# Cache secondary structure information for a given molecule

#VMD  --- start of VMD description block
#Name:
# SSCache
#Synopsis:
# Automatically stores secondary structure information for animations
#Version:
# 1.0
#Uses VMD version:
# 1.1
#Ease of use:
# 2
#Procedures:
# <li>start_sscache molid - start caching the given molecule
# <li>stop_sscache molid - stop caching
# <li>reset_sscache - reset the cache
# <li>sscache - internal function used by trace
#Description:
# Calculates and stores the secondary structure assignment for
# each timestep.  This lets you see how the secondary structure
# changes over a trajectory.
# <p>
# It is turned on with the command "start_sscache> followed by the
# molecule number of the molecule whose secondary structure should be
# saved (the default is "top", which gets converted to the correct
# molecule index).  Whenever the frame for that molecule changes, the
# procedure "sscache" is called.
# <p>
#   "sscache" is the heart of the script.  It checks if a secondary
# structure definition for the given molecule number and frame already
# exists in the Tcl array sscache_data(molecule,frame).  If so, it uses
# the data to redefine the "structure" keyword values (but only for
# the protein residues).  If not, it calls the secondary structure
# routine to evaluate the secondary structure based on the new
# coordinates.  The results are saved in the sscache_data array.
# <p>
# Once the secondary structure values are saved, the molecule can be
# animated rather quickly and the updates can be controlled by the
# animate form.
# <p>
#  To turn off the trace, use the command "stop_sscache", which
# also takes the molecule number.  There must be one "stop_sscache"
# for each "start_sscache".  The command "clear_sscache" resets
# the saved secondary structure data for all the molecules and all the
# frames.
#Files:
# <a href="sscache.vmd">sscache.vmd</a>
#See also:
# the VMD user's guide
#Author:
# Andrew Dalke <dalke@ks.uiuc.edu>
#Url:
# http://www.ks.uiuc.edu/Research/vmd/script_library/sscache/
#\VMD  --- end of block


# start the cache for a given molecule
proc start_sscache {{molid top}} {
    global sscache_data
    if {! [string compare $molid top]} {
        set molid [molinfo top]
    }
    global vmd_frame
    # set a trace to detect when an animation frame changes
    trace variable vmd_frame($molid) w sscache

    return
}

# remove the trace (need one stop for every start)
proc stop_sscache {{molid top}} {
    if {! [string compare $molid top]} {
        set molid [molinfo top]
    }
    global vmd_frame
    trace vdelete vmd_frame($molid) w sscache
    return
}


# reset the whole secondary structure data cache
proc reset_sscache {} {
    if [info exists sscache_data] {
        unset sscache_data
    }
    return
}

# when the frame changes, trace calls this function
proc sscache {name index op} {
    # name == vmd_frame
    # index == molecule id of the newly changed frame
    # op == w

    global sscache_data

    # get the protein CA atoms
    set sel [atomselect $index "name CA"]

    ## get the new frame number
    # Tcl doesn't yet have it, but VMD does ...
    set frame [molinfo $index get frame]

    # see if the ss data exists in the cache
    if [info exists sscache_data($index,$frame)] {
        $sel set structure $sscache_data($index,$frame)
        return
    }


    # doesn't exist, so (re)calculate it
    vmd_calculate_structure $index
    # save the data for next time
    set sscache_data($index,$frame) [$sel get structure]

    set listfile [open sec_st_3.dat a+]

    set sel [atomselect 0 "name CA"]
    set structList [$sel get structure]
    puts $listfile "[format "%10d" $frame] $structList"
    puts "$frame"
    close $listfile

    return
}

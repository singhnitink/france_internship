mol delete all
source ss_traj.tcl
mol new ../solv_ions.gro
animate read xtc ../run3/viz.xtc
start_sscache
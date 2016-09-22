#!/bin/sh
# tricking... the line after a these comments are interpreted as standard shell script \
    exec $ESPRESSO_SOURCE/Espresso $0 $*
#


#================================================================================
#
# name:   initSaw.tcl
# author: ftessier
# date:   09/16/2016
#
# TCL script to create random walks using ESPResSo
#
#================================================================================

#this procedure updates the trajectory
#================================================================================
proc update_trajectory {} {
  global n_mono
  global vis

  puts $vis "\ntimestep indexed"
  for {set p 0} {$p<[expr $n_mono]} {incr p} {
   puts $vis "$p [part $p print pos]"
  }
}
#================================================================================


proc warm_up { }  {
  global kBT
  global gamma
  global time_step
  
  puts "** Warming up Polymer..."
  # reduce temperature, increase friction
  thermostat langevin 0.2 5
  setmd time_step [expr 0.5*$time_step]

  # ramp up the cap on the force
  inter ljforcecap 10.0
  integrate 1001
  inter ljforcecap 25.0
  integrate 2002
  inter ljforcecap 100.0
  integrate 2003  
  inter ljforcecap 150.0
  integrate 2004
  inter ljforcecap 200.0
  integrate 2005
  inter ljforcecap 250.0
  integrate 4006
  inter ljforcecap 300.0
  integrate 10001

  setmd time_step $time_step
  integrate 5002

  inter ljforcecap 0
  integrate 1005

  # restore temperature, reduce friction
  thermostat langevin $kBT 0.01
  integrate 100000

  # restore temperature, restore friction  
  thermostat langevin $kBT $gamma
  integrate 1000
  puts "** Done warmup!"
}




  


#################=-  Global counters  -=##################
##########################################################

# for keeping track of the next particle ID
	set part_ID 0

# for keeping track of the next particle number
	set part_num 0

# for keeping track of the next interaction ID
	set inter_ID 0
	
# random seed
	set seed [pid]
	t_random seed $seed
		
		
		


#################=-  Physical params  -=##################
##########################################################
puts "[code_info]"

# Number of monomers
	set num_arm 5
	set num_per_arm 20
	set n_mono [expr $num_arm*$num_per_arm+1]


# Distance (used in FENE, and lennard jones) 
	set sigma 1.0

# Energy (used in lennard-jones and FENE )
	set epsilon 1.0

# Temperature (used in Langevin)
	set kBT 1.0

# Gamma (used in Langevin)
	set gamma 1.0

# init Langevin thermostat
	setmd skin 0.4
	integrate set nvt

# init integration timestep
	set time_step 0.01
	setmd time_step $time_step

# Set Langevin thermostat, params: Temperature , Gamma
	thermostat langevin $kBT $gamma
		

# Set simulation box in x,y,z
	set lx 100
	set ly 100
	set lz 100
	setmd box_l $lx $ly $lz



set base_name [format "%dN" $n_mono ] 

# save sim to file?(yes/no)
set vis_file "yes"
set vis_file_name "$base_name.vtf"

# same observables to file? (yes/no)
set obs_file "yes"
set obs_file_name "$base_name.dat"

################=- Print some variables -=####################
##############################################################
puts "Master seed:	$seed"
puts "sim box:\t	[setmd box_l]"
puts "timestep:\t	[setmd time_step]"
puts "MDSkin:\t		[setmd skin]"
puts "Integ:\t		[integrate]"
puts "Thermos:\t	[thermostat]"


###################=- Particle types -=#######################
##############################################################
set type_mono $part_ID
incr part_ID

set type_wall $part_ID
incr part_ID




######################=- Len-Jones -=########################
#############################################################
# LJ hard-core potential, repulsive only 
# Params: epsilon, sigma, cutoff, shift, offset

	#note cutoff = 2 ^(1/6) sigma
	#inter type1 type2 lennard-jones ε σ rcut [( cshift|auto ) [roff [rcap [ rmin]]]]
	set r_cut [expr pow(2.0,(1.0/6.0))]
	inter $type_mono $type_mono lennard-jones [expr $epsilon] $sigma $r_cut 0.25 0.0


#####################=- FENE bonds -=########################
#############################################################
#see PRL-A, Volume 33, number 5, May 1986, Gary S. Grest and Kurt Kremer
	set bondID_fene $inter_ID
	incr inter_ID

		# stiffness k, traditional value is 7
		set k_fene [expr (30*$epsilon)/($sigma*$sigma)]
		# delta r_max, traditional value is 1.5
		set r_fene [expr 1.5*$sigma]  
			
		inter $bondID_fene fene $k_fene $r_fene


##################=- Tabulated bonds -=######################
#############################################################
# This is pre-calcualted FENE+LJ
# See PRL-A, Volume 33, number 5, May 1986, Gary S. Grest and Kurt Kremer
# To simulate an ideal polymer, use this bond instead of FENE and turn off long-ranged LJ 
#
	#set bondID_KG $inter_ID
	#incr inter_ID
	#inter $bondID_KG tabulated bond "tabulated_KG.txt"



	

#######################=- init VTF -=########################
#############################################################
#bottom wall
#constraint wall normal 0 0 1 dist [expr 0.0001] type $type_wall
# Write VTF file
if {$vis_file=="yes"}	{
  set vis [open $vis_file_name "w"]
  # Box
  puts $vis "unitcell [setmd box_l]"
  # Particles
  puts $vis "atom [expr 0]:[expr $n_mono-1] radius [expr $sigma] name mono type $type_mono"
  # Bonds
  #puts $vis "bond 0::[expr $n_mono-1]"
}






######################=- INITIALIZE -=#######################
#############################################################
	set b 0.97
	set try_max 30000000

	# init the polymer
	# place the monomers in a lines! (like spokes on a wheel)
	# choose n_mono such that n_mono=num_arm*num_per_arm+1
	# From the way I programmed the Initial positions,
	# You don't really want to go over 11 arms

	# place center monomer, and fix it in space
	set p 0
	part $p pos [expr 0.5*$lx] [expr 0.5*$ly] [expr 0.5*$lz] type $type_mono
	part $p fix 1 1 1
	
	incr p
	
	
	for {set phi 0} {$phi<[expr 2.*3.141592653]} {set phi [expr $phi+2.*3.141592653/$num_arm]} {
	  # init as straight line (or spokes)	
	  for {set a 0} {$a<$num_per_arm} {incr a} {
	   set rad [expr (1.+$a)*$b]
	   part [expr $p+$a] pos [expr $rad*sin($phi)+0.5*$lx] [expr $rad*cos($phi)+0.5*$ly] [expr 0.5*$lz] type $type_mono 
	  }

	  # define FENE bonds between neighbors
	  for {set a 1} {$a<$num_per_arm} {incr a} {
	   part [expr $p+$a] bond $bondID_fene [expr $p+$a-1]
	  }
	  # Connect with central monomer
	  part [expr $p] bond $bondID_fene 0
	  
	  # increase particle counter
	  set p [expr $p+$num_per_arm]
	}
	
	# print the first frame
	update_trajectory
	
	# warm-up		
	warm_up
	
	#Extra warmup, because star
	thermostat langevin $kBT 0.01
	integrate 100000
	thermostat langevin $kBT $gamma



#######################=- RUN LOOP -=########################
#############################################################

# Ready for the main simulation loop,
	set num_frame 1000
	set steps_per_frame 100

	puts "*** Starting Simulation, outputing every $steps_per_frame steps"
	for {set t 0} {$t<$num_frame} { incr t} {
	  integrate $steps_per_frame
	  update_trajectory
	}
	puts "*** Simulation finished"



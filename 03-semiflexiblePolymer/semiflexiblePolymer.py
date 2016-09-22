
#
# Copyright (C) 2013,2014,2015,2016 The ESPResSo project
#
# This file is part of ESPResSo.
#
# ESPResSo is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ESPResSo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
from __future__ import print_function
import espressomd
from espressomd import thermostat
from espressomd import interactions
import numpy as np

#############################################################
# This updates the trajectory file with a new frame
#############################################################
def update_trajectory(trajectory):
  trajectory.write("\ntimestep indexed\n")
  for p in system.part:
    trajectory.write("%d %f %f %f\n"%(p.id, p.pos[0], p.pos[1], p.pos[2]))
#############################################################

def warmup_up():
  system.non_bonded_inter.set_force_cap(10)
  system.integrator.run(1001)
  system.non_bonded_inter.set_force_cap(25)
  system.integrator.run(1002)
  system.non_bonded_inter.set_force_cap(100)
  system.integrator.run(2003)

  inter ljforcecap 150.0
  integrate 2004
  inter ljforcecap 200.0
  integrate 2005
  inter ljforcecap 250.0
  integrate 4006
  inter ljforcecap 300.0
  integrate 10001


  system.non_bonded_inter.set_force_cap(0)


#############################################################
# System parameters
#############################################################

system = espressomd.System()

#if no seed is provided espresso generates a seed

system.time_step = 0.01
system.cell_system.skin = 0.4
system.box_l = [100, 100, 100]
system.thermostat.set_langevin(kT=1.0, gamma=1.0)
system.cell_system.set_n_square(use_verlet_lists=True)

type_mono=0

system.non_bonded_inter[type_mono, type_mono].lennard_jones.set_params(
    epsilon=1, sigma=1,
    cutoff=2**(1. / 6), shift="auto")

fene = interactions.FeneBond(k=30, d_r_max=1.5)
system.bonded_inter.add(fene)
bend=interactions.Angle_Harmonic(bend=10, phi0=np.pi)
system.bonded_inter.add(bend)

n_mono=100

poly = system.polymer
poly(N_P = 1, bond_length = 0.97, MPC=n_mono, bond_id=0,start_pos=system.box_l*0.5)
system.part[1:-1].add_bond((bend, np.arange(n_mono)[:-2], np.arange(n_mono)[2:]))


#############################################################
# Write Trajectory file header
#############################################################
trajectory=open("%dN.vtf"%(n_mono), "w")
trajectory.write("unitcell %f %f %f\n" %(system.box_l[0],system.box_l[1],system.box_l[2]))
#	# Particles
trajectory.write("atom 0:%d radius 2 name mono type %d\n" %(n_mono-1,type_mono))
	# Bonds
trajectory.write("bond 0::%d" %(n_mono-1))





#############################################################
#      Integration 
#############################################################

num_frame=1000
steps_per_frame=100
for i in range(num_frame):
  system.integrator.run(steps_per_frame)
  update_trajectory(trajectory)





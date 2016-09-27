import numpy as np
import matplotlib.pyplot as plt


fname="100N.vtf"
num_mono=100
num_frame=1000

# we ignore the "timestep" entry since it starts with a "t"
# must make sure no timesteps appear bevore the line 4
data=np.loadtxt(fname,skiprows=4,comments="t")
data=np.reshape(data,(num_frame,num_mono,4))





print data[2,0,1]

exit()

dist=np.zeros(num_frame)
for f in range(num_frame):
  dx=data[f,0,1]-data[f,num_mono-1,1]
  dy=data[f,0,2]-data[f,num_mono-1,2]
  dz=data[f,0,3]-data[f,num_mono-1,3]
  dr=np.sqrt(dx*dx+dy*dy+dz*dz)
  dist[f]=dr

fig = plt.figure()
ax = fig.add_subplot(111)

ax.plot(np.arange(num_frame),dist)

ax.set_xlabel(r'Time frame (unknown units)')
ax.set_ylabel(r'End-to-end: $(R_e)$')
#ax.legend(loc='best')
#ax.set_xscale('log')
#ax.set_yscale('log')
#ax.axis(ymax=100)
fig.savefig('Re.png',)


exit()



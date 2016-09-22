


# make periodic and display box
#pbc wrap -all
#pbc box 
#pbc box -color 6

# When just bps wrap is used, you can join the broken molecules with:
#pbc join connected


# David's custom environment...
# I like a white BG
color Display Background 8
light 0 on
light 1 on
light 2 on
light 3 on
display depthcue off
display projection orthographic
color Axes X 8
color Axes Y 8
color Axes Z 8
color Axes Labels 16
axes location off



# delete existing representations
mol delrep 0 0

# create a representation for the polymer
mol addrep 0
mol modselect 0 0 type 0
# cpk {sphere scale, bond scale, detail, detail}
mol modstyle 0 0 cpk {2 0 5 0}
mol modcolor 0 0 ColorID {23}
mol modmaterial 0 0 Diffuse

# create a representation for the ds and ss strands
mol addrep 0
mol modselect 1 0 index 0
# cpk {sphere scale, bond scale, detail, detail}
mol modstyle 1 0 cpk {2 0 5 0}
mol modcolor 1 0 ColorID {2}
mol modmaterial 1 0 Diffuse


# for nice alpha blending
display rendermode GLSL

animate style once
animate goto start




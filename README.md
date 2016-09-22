# Macromolecules

A few polymer examples on ESPResSo for PHY-5320

Options: 
- Install ESPResSo (MacOSX, Linux, NOT windows)
 -ESPResSo 2- PROS: Fast, Has Constraints (wall+tube), good documentation, CON: uses TCL
 -ESPResSo 3 - PROS: Uses python, CONS: Slow, no constraints, little documentation
- Get an account on a server
- Install another package, [HOOMD,](http://glotzerlab.engin.umich.edu/hoomd-blue/) [LAMMPS](http://lammps.sandia.gov/)
 
----------
## Install ESPResSo
### Version 2.1.2j

This version is only supported with TCL
you can download it here: [ESPResSo 2](http://download.savannah.gnu.org/releases/espressomd/Espresso-2.1.2j.tar.gz)

or used the command
<code bash> wget http://download.savannah.gnu.org/releases/espressomd/Espresso-2.1.2j.tar.gz  </code>

Unzip the archive and go in the dircectory it created

<code>tar -zxf Espresso-2.1.2j.tar.gz 
cd espresso-2.1.2j</code>

Copy the configuration file over, 

<code> wget http://web5.uottawa.ca/www5/p2uo/website/Espresso/myconfig.h </code>

and run the configuration script with
<code>./configure</code>
If everything is fine (which should be if you have all dependencies), go ahead and compile with the "make" command
<code>make</code>

To test it, try to execute "Espresso"

<code>./Espresso</code>
which should print out something like this:

<code>
\*******************************************************
*                                                     *
*                    - Espresso -                     *
*                    ============                     *
*      A MPI Parallel Molecular Dynamics Program      *
*                                                     *
*                                                     *
* (c) 2002-2006                                       *
* Max-Planck-Institute for Polymer Research           *
* Mainz, Germany                                      *
*                                                     *
\*******************************************************
</code>


----------


### Version 3, with git
Get the source code:
<code bash>git clone https://github.com/espressomd/espresso.git </code>
go in the directory, and make a new directory called "build", go into "build" and run "cmake"
<code>cd espresso
mkdir build
cd build
cmake ../
</code>

You will see if you need dependencies, if everything seems fine, you can copy the config file here in the "build" directory and compile ESPResSo with "make"

<code>wget  http://web5.uottawa.ca/www5/p2uo/website/Espresso/myconfig.hpp
make
</code>
Which hopefully completes successfully.
Test by running "pypresso"

<code>
./pypresso
</code>

which should bring you to an interactive python shell

<code> 
[GCC 4.2.1 Compatible Apple LLVM 7.3.0 (clang-703.0.31)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
\>>>
</code>


----------


##Installing ESPResSo dependencies

### On MacOSX, using home brew
<code>/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update

brew install python
brew install cmake
brew install fftw
pip install scipy
pip install numpy
pip install matplotlib
</code>

For ESPResSo 3, you need openMPI, boost and cython
<code>
brew install open-mpi
brew install boost --with-mpi
brew install boost-python
pip install cython
</code>

### On Linux, using apt-get
<code> apt-get install cython</code>
etc etc

----------


  


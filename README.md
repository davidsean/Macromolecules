# Macromolecules

A few polymer examples on ESPResSo for PHY-5320

Options: 

1. Install ESPResSo (MacOSX, Linux, NOT windows)
   * ESPResSo 2- PROS: Fast, Has Constraints (wall+tube), good documentation, CON: uses TCL
   * ESPResSo 3 - PROS: Uses python, CONS: Slow, no constraints, little documentation
2. Get an account on a server with a pre-installed version
3. Install another package, [HOOMD,](http://glotzerlab.engin.umich.edu/hoomd-blue/) [LAMMPS](http://lammps.sandia.gov/) etc,
 
----------
## Install ESPResSo
### Version 2.1.2j

This version is only supported with TCL
you can download it here: [ESPResSo 2](http://download.savannah.gnu.org/releases/espressomd/Espresso-2.1.2j.tar.gz)

or used the ``wget`` command
```
wget http://download.savannah.gnu.org/releases/espressomd/Espresso-2.1.2j.tar.gz
```

Unzip the archive and go in the dircectory it created

```
tar -zxf Espresso-2.1.2j.tar.gz 
cd espresso-2.1.2j
```

Copy the configuration file over, 

```
wget http://web5.uottawa.ca/www5/p2uo/website/Espresso/myconfig.h
```

and run the configuration script with
```
./configure
```
If everything is fine (which should be if you have all dependencies), go ahead and compile with the ``make`` command
```
make
```

To test it, try to execute "Espresso"

```
./Espresso
```
which should print out something like this:

```
*******************************************************
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
*******************************************************
```


----------


### Version 3, with git
Get the source code:
``
git clone https://github.com/espressomd/espresso.git
``
go in the directory, and make a new directory called ``build``, go into ``build`` and run ``cmake``
```
cd espresso
mkdir build
cd build
cmake ../
```

You will see if you need dependencies, if everything seems fine, you can copy the config file here in the "build" directory and compile ESPResSo with "make"

```
wget  http://web5.uottawa.ca/www5/p2uo/website/Espresso/myconfig.hpp
make
```
Which hopefully completes successfully.
Test by running ``pypresso``

```
./pypresso
```

which should bring you to an interactive python shell

```
[GCC 4.2.1 Compatible Apple LLVM 7.3.0 (clang-703.0.31)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>>
```


----------


##Installing ESPResSo dependencies

### On MacOSX, using home brew
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew install python
brew install cmake
brew install fftw
pip install numpy
```

For ESPResSo 3, you need openMPI, boost and cython
```
brew install open-mpi
brew install boost --with-mpi
brew install boost-python
pip install cython
```

### On Linux, using apt-get
```
apt-get install cython
```
etc etc

----------


## Get an account

I made user accounts on 137.122.32.210, which is only accessible from a UOttawa computer.
The accounts name is taken the Univerity of Ottawa identifier are uo_name@uottawa.ca,
and the password is the same thing, but written in capital letters.
for example, my University email is ``dsean092@uottawa.ca``.

This means that for me,

username: ``dsean092``
password: ``DSEAN092``

I can access it via ``ssh``, from a command-line type:

```
ssh dsean092@137.122.32.210
```
and type in the password when prompted.
The first thing you should do is change the password using the command ``passwd``
ESPResSo is installed system-wide,

to use python (with espresso 3)  use ``pypresso`` or use ``Espresso`` in which case opens a TCL session.


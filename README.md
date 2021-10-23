# PlasimAUTO 0.1
## Scripts for automatic experiment preparation and execution for the PlaSim model on machines with a SLURM job management system

These scripts help to perform ensembles of experiments with the PlaSim model (https://github.com/jhardenberg/PLASIM).
PlaSim is automatically downloaded and configured, initial and boundary conditions are prepared and SLURM job scripts are prepared. Optionally the script also submits the jobs.
Postprocessing routines extracting zonal averages and global average timeseries are provided (this part will be expanded).

## Instructions

### Preparing the scripts

Place these scripts in a directory and edit `scripts/config.sh` accordingly. 
   You will need to set two variables: `$SCRIPTDIR` pointing to the directory where these scripts reside and `$BASEDIR` where the experiments will be performed (could be the same directory)

A sample script to prepare and run some exoplanetary experiments is provided in `examples/testexo.sh`. 
A sample script illustration how to prepare and run different experiments changing resolution is provided in `examples/testres.sh`. 

Please check also the files in the `template` directory. Check compiler options (in case you can create a new file with compiler options for you rmachine) and check the template.job script `template.job`.

### Initializing PlaSim

The command `setup` in the script will download and configure PlaSim automatically in the `$BASEDIR/src` directory. If you need to specify special compiler options for your machine (optional) you can provide them with the optional `comp` option as follows:
     setup comp=ifort.wilma
this will copy from the directory `$SCRIPTDIR/template` the file `most_compiler.ifort.wilma` into `$BASEDIR/src/most_compiler`, customizing the compiler options. If omitted (i.e. just `setup` is used), the default options chosen by PlaSim will be used (they may not be optimal for your machine - the configurations script of PlaSim needs to be updated).

Please notice that once PlaSim has been configured, the `setup` command can be commented/omitted in the script if this is to be run again.

### Common run parameters

These are a few common parameters which control the runs.
* `$YEARS` is the desired length for each experiment (if omitted 10 years are used)
* `$EMAIL` is an email to be include in the job scripts (if omitted no mail is sent)
* `$MEMORY` the memory footprint of PlaSim for the job scripts (30M is ok for T21) (if omitted not specified in run script)
* `$LAUNCH` boolean to decide if the script will also submit the jobs after preparing them. Set to 1 to actually perform an experiment
* `$EXO` boolean to decide if these are "exoplanetary" runs. With Plasimauto you can run either 'classical' PlaSim runs or exoplanetary cases. When `$EXO` is set, PlaSim is initialized with a uniform surface temperature over the globe and for SST (determined by the `tgr` option - default 288K). Further, according to the `sic` option the oceans may be covered with a sea-ice layer (1m high). If `$EXO` is not set a classic PlaSim run is performed, without further manipulation of the boundary conditions. By default `$EXO` is not set.

### Specifying an experiment 

Example: `makeexp ees100a45t1 s0=1367.0 obl=0.0 co2=360 tgr=320 aqua=1 eq=45 lsg=1`

Prepares an experiment with jobid "ees100a45t1", solar constant 1367 W/m2, obliquity 0, CO2 concentration 360 ppm, initial global temperature 320K, for an aquaplanet with an equatorial continent between -45° and 45° in latitude and using an LSG ocean (Assuming `$EXO` is set).

Example: `makeexp testres nlev=15 res=t31`

Prepares a standard experiment with 15 vertical levels at T31 resolution.

The syntax for `makeexp` is:

    makeexp jobid <OPTIONS>
    OPTIONS:
    obl=<obliquity> Sets obliquity
    co2=<co2>       Sets global GHG concentrations for CO2 in [ppm] (default: 360)
    s0=<s0>
    gsol0=<s0>      Set the solar constant in [W/m2] (default: 1367)
    ecc=<ecc>       Sets eccentricity (default: 1.6715e-02)
    tgr=<tgr>       Initial global temperature in [K] (used for air and mixed layer) (default: 288)
    diff=<diff>     Horizontal diffusion in the mixed layer (default 3e+4)
    sic=<conc>      Set to 1 to cover planet with 1m deep sea-ice layer (default: 0)
    aqua=<bool>     Set to 1 to make an Aquaplanet (water world) experiment. Can be combined with <eq>. If set also `$EXO` is assumed set automatically.
    eq=<lat>        If set and different than 0 will introduce an equatorial continent betwwn latitudes +/-<lat>. Has to be combined with <aqua>.
    nlev=<nlev>     Sets th number of vertical levels (default 10)
    res=<res>       Sets horizontal resolution Options: t21, t31, t42, t63 (default t21)
    ncores=<ncpu>
    ncpu=<ncpu>     Activates parallelism with <ncpu> cores
    years=<years>   Overrides `$YEARS` and sets length of run
    param=<file>    Read parameters from an external file in the format:
                    PARAM NAMELIST value
                    Example: 
                    TDISSQ plasim 0.015
                    ACLLWR radmod 0.1
    set=<par>/<nl>/<val> Sets parameter <par> to <val> in namelist <nl>. 
                         can be specified multiple times. Example:
                         makeexp t001 set=N_RUN_YEARS/plasim/0 set=N_RUN_MONTH/plasim/1 verbose=1
    copy=<dir>      Copy all files from directory <dir> into run directory (can be used to set *sra file, change run script etc)

### Running multiple experiments specified in a table

The example `examples/testtable.sh` shows how the `param` option can be used to read an external table specifying experiments names and parameters and to prepare the corresponding experiments.

### Postprocessing

The script `examples/testpost.sh` will perform postprocessing of selected experiments. The new command `post` has the following syntax: 

    post jobid var year1/year2

    Where:

    jobid    is the jobid of the experiment
    var      is the variable name (al and pr are derived automatically)
    year1 and year2 specify the period in which to perform the analysis  

### Plotting

Two sample gnuplot plotting scripts `plot.sh` and `plotpr.sh` to plot the output of the postprocessing routines.




        


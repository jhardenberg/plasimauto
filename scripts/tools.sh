#!/bin/bash
# set -ex

. scripts/config.sh

replmost () {
	sed -i "s%$1%$2%g" $SRCDIR/most.cfg
}
repl () {
        [ "$VERBOSE" = "1" ] && echo "Setting $1 to $2 in $3"
	sed -i "s%$1%$2%g" $3
}
del () {
	sed -i "/$1/d" $2
}
insert () {
	sed -i "/^ \/END.*/i $1" $2
}
insert2 () {
        sed -i "1a$1" $2
}
head () {
	sed -i "1c$1" $2
}

makejob () {

	EXP=$1
        mkdir -p $JOBDIR
        mkdir -p $LOGDIR

	cp $SCRIPTDIR/template/template.job $JOBDIR/$EXP.job
        repl "<exp>" $EXP $JOBDIR/$EXP.job
        repl "<res>" $RES $JOBDIR/$EXP.job
        repl "<nlev>" $NLEV $JOBDIR/$EXP.job
        repl "<expdir>" $EXPDIR $JOBDIR/$EXP.job
        repl "<logdir>" $LOGDIR $JOBDIR/$EXP.job
        repl "<obliq>" $OBL $JOBDIR/$EXP.job
        repl "<eccen>" $ECC $JOBDIR/$EXP.job
        repl "<gsol0>" $GSOL0 $JOBDIR/$EXP.job
        repl "<tgr>" $TGR $JOBDIR/$EXP.job
        repl "<co2>" $CO2 $JOBDIR/$EXP.job
        repl "<hdiff>" $DIFF $JOBDIR/$EXP.job
        repl "<eq>" $EQ $JOBDIR/$EXP.job
        repl "<aqua>" $AQUA $JOBDIR/$EXP.job
        repl "<sic>" $SIC $JOBDIR/$EXP.job
        repl "<lsg>" $LSG $JOBDIR/$EXP.job
        repl "<ncores>" $NCPU $JOBDIR/$EXP.job
        if [ "$EMAIL" != "" ]; then
           repl "<email>" $EMAIL $JOBDIR/$EXP.job
        else
           del "<email>" $JOBDIR/$EXP.job
        fi
        if [ "$MEMORY" != "" ]; then
           repl "<mem>" $MEMORY $JOBDIR/$EXP.job
        else
           del "<mem>" $JOBDIR/$EXP.job
        fi
  
        if [ "$LAUNCH" == "1" ]; then 
            sbatch $JOBDIR/$EXP.job
        fi
}

makeexp() {
   if [ $# -lt 1 ]; then
cat << EOT
Usage: makeexp jobid <OPTIONS>

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
ocean=<flag>    Activate (<flag=1> / defult) or deactivate (<flag>=0) slab ocean model
ice=<flag>      Activate (<flag=1> / defult) or deactivate (<flag>=0) sea ice model
press=<flag>    Derive surface pressure
uv=<flag>       Derive ua, va instead of divergence and vorticity
sp2gp=<flag>    convert spectral to gridpoint
EOT
    return
fi
cd $SRCDIR

local EXP=$1
local GSOL0=1367.0
local ECC=1.6715e-02
local OBL=23.44
local CO2=360
local TGR=288
local DIFF=3.0e+04
local EQ=0
local AQUA=0
local SIC=0.
local LSG=0
local RES=t21
local NLEV=10
local NCPU=1
local PARAM=""
local SET=""
local COPY=""
local VERBOSE=0
local OCEAN=1
local ICE=1
local PRESS=0
local UV=0
local SP2GP=0

for ARGUMENT in "$@"
do
    local KEY=$(echo $ARGUMENT | cut -f1 -d=)
    local VALUE=$(echo $ARGUMENT | cut -f2 -d=)

    case "$KEY" in
            obl)    OBL=${VALUE} ;;
            ecc)    ECC=${VALUE} ;;
            co2)    CO2=${VALUE} ;;
            s0)     GSOL0=${VALUE} ;;
            gsol0)  GSOL0=${VALUE} ;;
            tgr)    TGR=${VALUE} ;;
            diff)   DIFF=${VALUE} ;;
            eq)   EQ=${VALUE} ;;
            aqua) AQUA=${VALUE} ;;
            sic) SIC=${VALUE} ;;
            lsg) LSG=${VALUE} ;;
            nlev) NLEV=${VALUE} ;;
            res) RES=${VALUE} ;;
            years) YEARS=${VALUE} ;;
            ncores) NCPU=${VALUE} ;;
            ncpu) NCPU=${VALUE} ;;
            param) PARAM=${VALUE} ;;
            set) SET=$(echo $SET ${VALUE}) ;;
            copy) COPY=${VALUE} ;;
            verbose) VERBOSE=${VALUE} ;;
            ocean) OCEAN=${VALUE} ;;
            ice) ICE=${VALUE} ;;
            press) PRESS=${VALUE} ;;
            uv) UV=${VALUE} ;;
            sp2gp) SP2GP=${VALUE} ;;
            *)
    esac
done

cp $SCRIPTDIR/template/most.cfg $SRCDIR

replmost "<ice>" $ICE
replmost "<ocean>" $OCEAN
replmost "<obliq>" $OBL
replmost "<eccen>" $ECC
replmost "<gsol0>" $GSOL0
replmost "<co2>" $CO2
if [ "$LSG" != "0" ]; then
    replmost "<lsg>" 1
else
    replmost "<lsg>" 0
fi
local T21=0
local T31=0
local T42=0
case $RES in
  t21) T21=1;;
  t31) T31=1;;
  t42) T42=1;;
esac
replmost "<t21>" $T21
replmost "<t31>" $T31
replmost "<t42>" $T42
replmost "<nlev>" $NLEV
replmost "<ncores>" $NCPU

./most.x -c most.cfg

mkdir -p $EXPDIR/$EXP
cp -R $SRCDIR/plasim/run/* $EXPDIR/$EXP/
cd $EXPDIR/$EXP/

# Fix runscript 
if [ "$YEARS" != "" ]; then
   repl YEAR2=10 YEAR2=$YEARS most_plasim_run
fi
if [ "$PRESS" == "1" ]; then
   repl "\$average plasim_output" "-p \$average plasim_output" most_plasim_run
fi
if [ "$UV" == "1" ]; then
   repl "\$average plasim_output" "-u \$average plasim_output" most_plasim_run
fi
if [ "$SP2GP" == "1" ]; then
   repl "\$average plasim_output" "-s \$average plasim_output" most_plasim_run
fi

insert "TGR = $TGR" plasim_namelist
if [ "$EXO" != "" ] && [ "$EXO" != "0" ]; then
# Fix single diffusivity
  repl "NSHDIFF     =     1" "NSHDIFF     =     0" oceanmod_namelist
  repl "HDIFFK      = 1.0e+05" "HDIFFK      = $DIFF" oceanmod_namelist

  if [ "$AQUA" != "0" ]; then
     $SRCDIR/scripts/aqua.sh $TGR $SIC $EQ
     if [ "$LSG" != "0" ]; then
         $SRCDIR/scripts/maketopo $LSG > topogr  # Aquaplanet with fixed depth $LSG
         insert2 "naqua=1" input  # No friction corrections
         echo 84 1 > kleiswi  # Initalizes ocean with constant values (5°C, 34.5 psu)
     fi
  else
     $SRCDIR/scripts/earth.sh $TGR $SIC
  fi
fi

if [ "$SET" != "" ]; then
   s=( $SET )
   for (( i=0; i<${#s[@]}; i++)); do
    local par=$( echo ${s[$i]}|cut -d'/' -f 1 )
    local nl=$( echo ${s[$i]}|cut -d'/' -f 2 )
    local val=$( echo ${s[$i]}|cut -d'/' -f 3 )
    [ $VERBOSE = 1 ] && echo "Experiment $EXP Substituted parameter $par in namelist $nl with value $val"
    insert " $par = $val" ${nl}_namelist
   done
fi

if [ "$COPY" != "" ]; then
   cp $COPY/* .
fi

if [ "$PARAM" != "" ]; then
   cp $PARAM $EXPDIR/
# Special interpretation of TFRC1 and TFRC2
   TFRC1=1728000
   TFRC2=8640000
   while read line; do
# reading each line
     local a=( $line )
     local par="${a[0]}"
     local nl="${a[1]}"
     local val="${a[2]}"
     [ $VERBOSE = 1 ] && echo "Experiment $EXP Substituted parameter $par in namelist $nl with value $val"
     if [ $par != TFRC1 ] && [ $par != TFRC2 ]; then
        insert " $par = $val" ${nl}_namelist
     fi
     [ $par = TFRC1 ] && TFRC1=$val
     [ $par = TFRC2 ] && TFRC2=$val
   done < $PARAM
   insert " TFRC = $TFRC1, $TFRC2" plasim_namelist
   cp $PARAM parameters.txt
fi

makejob $EXP
}

setup () {

local COMP=""
local BRANCH="master"
for ARGUMENT in "$@"
do
    local KEY=$(echo $ARGUMENT | cut -f1 -d=)
    local VALUE=$(echo $ARGUMENT | cut -f2 -d=)

    case "$KEY" in
            comp)    COMP=${VALUE} ;;
            branch)  BRANCH=${VALUE} ;;
            *)
    esac
done

# Prepare code
mkdir -p $BASEDIR
cd $BASEDIR
git clone https://github.com/jhardenberg/PLASIM.git $SRCDIR
cd $SRCDIR
git checkout $BRANCH
./configure.sh
if [ -n "$COMP" ]; then
   cp $SCRIPTDIR/template/most_compiler.$COMP most_compiler  
   cp $SCRIPTDIR/template/most_compiler_mpi.$COMP most_compiler_mpi
fi
head "DIR=$SRCDIR/scripts" $SRCDIR/scripts/aqua.sh
head "DIR=$SRCDIR/scripts" $SRCDIR/scripts/earth.sh
}

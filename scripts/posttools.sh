#!/bin/bash

. scripts/config.sh

CDO="cdo -s"
post () {
        mkdir -p $BASEDIR/post
        cd $BASEDIR/post

 	EXP=$1
        VAR=$2
        RANGE=$3
        IDIR=$EXPDIR/$EXP/output
        ODIR=$POSTDIR/$EXP/$VAR
        mkdir -p $ODIR
        cd $ODIR
        rm -f ${EXP}_${VAR}_zon.nc ${EXP}_${VAR}_fld.nc
# rst=rsut+tisr    tisr=rst-rsut    
        if [ "$VAR" = "al" ]; then
            CALC=-expr,"al=-rsut/(rst-rsut)"
        elif [ "$VAR" = "pr" ]; then
            CALC=-expr,"pr=prc+prl"
        elif [ "$VAR" = "net" ]; then
            CALC=-expr,"net=rlut+rst"
        else
            CALC=""
        fi 
        for f in $IDIR/MOST_PLA.*.nc
        do
          $CDO cat -timmean -zonmean -selname,$VAR $CALC $f ${EXP}_${VAR}_zon.nc
          $CDO cat -timmean -fldmean -selname,$VAR $CALC $f ${EXP}_${VAR}_fld.nc
        done
        $CDO timmean -selyear,$RANGE ${EXP}_${VAR}_zon.nc ${EXP}_${VAR}_zon_clim.nc
        $CDO timmean -selyear,$RANGE ${EXP}_${VAR}_fld.nc ${EXP}_${VAR}_fld_clim.nc
        $CDO outputtab,date,lat,value ${EXP}_${VAR}_zon_clim.nc >  ${EXP}_${VAR}_zon_clim.txt
        $CDO outputtab,date,value ${EXP}_${VAR}_fld.nc >  ${EXP}_${VAR}_fld.txt
        $CDO outputf,"%f",1  ${EXP}_${VAR}_fld_clim.nc >  ${EXP}_${VAR}_fld_clim.txt
}



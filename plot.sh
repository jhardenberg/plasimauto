#!/bin/bash

. ./config.sh
cd $POSTDIR

LW=4
LIM="-100:80"
OFF=273.15
KEYPOS=bottom
YLABEL="T [°C]"
for VAR in tas sic al
do
for s in 085 090 095 100 105 110 115
do
cat > plot.gnu << EOF
#set term eps colour enhanced font "arial,14"
set term pdf colour enhanced font "arial,14"
set out "${VAR}_S$s.pdf"
set xlabel "lat"
set ylabel "$YLABEL"
set title "$VAR, S=${s}% S0"
set key $KEYPOS center
plot [-90:90][$LIM] \
        'ees${s}e00t0/$VAR/ees${s}e00t0_${VAR}_zon.txt'u 2:(\$3-$OFF) notitle  w l lc 2 lw $LW dt 2, \
        'ees${s}e00t1/$VAR/ees${s}e00t1_${VAR}_zon.txt'u 2:(\$3-$OFF) title 'earth' w l lw $LW dt 1 lc 2, \
        'ees${s}a00t0/$VAR/ees${s}a00t0_${VAR}_zon.txt'u 2:(\$3-$OFF) notitle  w l lc 3 lw $LW dt 2, \
        'ees${s}a00t1/$VAR/ees${s}a00t1_${VAR}_zon.txt'u 2:(\$3-$OFF) title 'aqua' w l lw $LW dt 1 lc 3, \
        'ees${s}a15t0/$VAR/ees${s}a15t0_${VAR}_zon.txt'u 2:(\$3-$OFF) notitle w l lc 1 lw $LW dt 2, \
        'ees${s}a15t1/$VAR/ees${s}a15t1_${VAR}_zon.txt'u 2:(\$3-$OFF) title 'eqcont 15' w l lw $LW dt 1 lc 1, \
        'ees${s}a45t0/$VAR/ees${s}a45t0_${VAR}_zon.txt'u 2:(\$3-$OFF) notitle w l lc 4 lw $LW dt 2, \
        'ees${s}a45t1/$VAR/ees${s}a45t1_${VAR}_zon.txt'u 2:(\$3-$OFF) title 'eqcont 45' w l lw $LW dt 1 lc 4, 0 notitle lc 0
EOF
gnuplot plot.gnu
done
LIM="-0.1:1.1"
OFF=0
KEYPOS=top
YLABEL="fraction"
done

montage tas_S085.pdf sic_S085.pdf al_S085.pdf tas_S090.pdf sic_S090.pdf al_S090.pdf tas_S095.pdf sic_S095.pdf al_S095.pdf tas_S100.pdf sic_S100.pdf al_S100.pdf  -geometry 1280x720+2+2 -tile 3x4 comp1.png
montage tas_S105.pdf sic_S105.pdf  al_S105.pdf tas_S110.pdf sic_S110.pdf al_S110.pdf tas_S115.pdf sic_S115.pdf al_S115.pdf -geometry 1280x720+4+2 -tile 3x3 comp2.png

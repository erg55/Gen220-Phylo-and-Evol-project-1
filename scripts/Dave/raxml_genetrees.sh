#!/bin/bash -l
#PBS -l nodes=1:ppn=8 -N raxml -j oe

# Write appropriate directory here
cd /bigdata/hayashilab/dhais001/420_Ortho

module load RAxML

CPU=2

if [ $PBS_NUM_PPN ]; then
 CPU=$PBS_NUM_PPN
fi

F=$PBS_ARRAYID
GENOMELIST=FILES

if [ ! $F ]; then
 F=$1
fi

if [ ! $F ]; then
 echo "no PBS_ARRAYID or input"
 exit
fi


# Change RAxML commands according to input data sets. See current RAxML manual.

echo $GENOMELIST
file=`sed -n ${F}p $GENOMELIST`
base=`basename $file .phy`
if [ ! -f "RAxML_info.$base" ]; then
 echo "$base $file"
 raxmlHPC-PTHREADS-SSE3 -T $CPU -# 1000 -x 97531 -f a -p 13579  -m PROTGAMMAAUTO -s $file -n $base
fi





#qsub -I -t 1-22 arrayjob_orthomcl_adjust_fasta.sh

module load orthomcl

# 22 files to be parallelized

# remove later
# let PBS_ARRAYID=1 

# folders must be a three or four letter unique abbreviation for the taxon, fasta file is in folder

for folder in */
do
 echo $folder
 for fastafile in "$folder"*.fasta*
  do
    echo $fastafile
    orthomclAdjustFasta $folder $fastafile 1 
  done
  let PBS_ARRAYID=$(($PBS_ARRAYID + 1))
done

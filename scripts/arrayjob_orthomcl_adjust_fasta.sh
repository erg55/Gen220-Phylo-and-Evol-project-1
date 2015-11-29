
#qsub -t 1-37 arrayjob_orthomcl_adjust_fasta.sh

module load orthomcl

# 37 files to be parallelized

# remove later
# let PBS_ARRAYID=19

unset folder
folder=$(sed -n -e "PBS_ARRAYID p" arraylist.txt)

# folders must be a three or four letter unique abbreviation for the taxon, fasta file is in folder
for fastafile in ./"$folder"/*.fasta*
do
<<<<<<< HEAD
	orthomclAdjustFasta $folder " $fastafile" 2 
=======
 echo $folder
 for fastafile in "$folder"*.fasta*
  do
    echo $fastafile
    orthomclAdjustFasta $folder $fastafile 2 
  done
>>>>>>> origin/master
done


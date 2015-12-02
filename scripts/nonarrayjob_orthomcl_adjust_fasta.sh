#version if can't get array job to work


module load orthomcl

# 38 files to be parallelized
unset folder

for i in {1..37}
do
folder=$(sed -n -e "$i p" arraylist.txt)

# folders must be a three or four letter unique abbreviation for the taxon, fasta file is in folder
for fastafile in ./"$folder"/*.fasta*
do
	orthomclAdjustFasta $folder " $fastafile" 2 
done
done

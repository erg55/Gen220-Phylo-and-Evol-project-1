#version if can't get array job to work


module load orthomcl

# $u files to be parallelized (as many as in arraylist.txt)
unset folder

u="$(wc -l arraylist.txt |cut -f1 -d " ")"
echo ${u}
for i in $(eval echo "{1..$u}")
do
echo ${i}
folder=$(sed -n -e "$i p" arraylist.txt)
# folders must be a three or four letter unique abbreviation for the taxon, fasta file is in folder
for fastafile in ./"$folder"/*.fasta*
do
	orthomclAdjustFasta $folder " $fastafile" 2 
done
done


#This shell, executed from the directory containing .fa OrthoMCL files will convert a number 
#of OrthoMCL .fa files into individual .phy alignments, .fas alignments 
#as well as write a .phy supermatrix with associated partition files: RAxML format, PartitionFinder config datablock format. 


#Must have the following installed: trimAl 2, MAFFT v7.266, FASconCAT-G_v1.02, seqmagick (requires biopython)
#Install GNU SED via homebrew (Mac OS X), biopython
#Must move FASconCAT-G.pl into the same directory as OrthoMCL .fa files

# Start

# MAFFT default fast alignment

for f in $(ls *.fa); do mafft --retree 1 $f > $f.out; done;

rm *.fa

# Trim alignments

for f in $(ls *.out); do trimal -in $f -out $f.trim -automated1; done;

rm *.out

# Change Ortho MCL format headers to >Gspe, 4 letters. If more letters desired, change "4" to desired number of spaces
# NOTE: gsed is specific to MAC OS X. Change gsed to sed if GNU SED is installed by default (Linux)

for f in *.trim; do gsed -i 's/>lcl|\(.\{4\}\).\+/>\1/g' $f; done;

# Change file extension to .fas for FASconCAT-G

for f in *.trim; do mv "$f" "$(basename "$f" .fa.out.trim).fas"; done;

# Eliminate duplicate taxa and associated sequences

for x in $(ls *.fas); do seqmagick mogrify --deduplicate-taxa $x; done;  

# If want interleaved relaxed phy gene tree files only, use the following: 

# for x in $(ls *.fas); do seqmagick convert $x $x.phyx; done; 

#Concatenate .fas gene files and output as .phy supermatrix. Convert individual .fas gene files to .phy. Output partition file
#in RAxML format. Note: default AA model is LG for all partitions. If partitions are not to be merged, then install prottest
#consult FASconCAT-G manual for prottest commands and list of options.

perl FASconCAT-G_v1.02.pl -s -i -o -o -a -p -p -l

# Edit partition file for use with PartitionFinder. Default is in RAxML format for above FASconCAT commands. 
# See PartitionFinder manual for config data blocks format. 

sort -n -k4  *_supermatrix_partition.txt > YourFile_part.txt
cut -c5- YourFile_part.txt > Your_partFile.txt 
awk '{print $0";"}' Your_partFile.txt > AA_part.txt
rm Your*


# Will have the following in one directory: aligned and trimmed .fas, .phy files; .phy supermatrix, RAxML format partition file,
# PartitionFinder data block Config format, xls of FASconCAT-G optional statistics (see FASconCAT-G manual for details).





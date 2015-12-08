#Uncomment out below when need to retreive GI
#FASTA=*.fasta.new
#for file in $FASTA
#do grep -o "[0-9]* " $file | awk 'NF' > $file".txt"
#done
pept="OG1.5_1697.fasta.new.txt"
#variable can be multiple arguments
for file in $pept;
do python getgenpept.py $file;
done

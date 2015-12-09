#Uncomment out below when need to retreive GI
#FASTA=*_15??.fa
#for file in $FASTA
#do grep -o "[0-9]* " $file | awk 'NF' > $file".txt"
#done
#current listing is for completion by parts: OGs starting with _15
#pept=*_15*.fa.txt
#variable can be multiple arguments
#for file in $pept;
#do python getgenpept.py $file;
#done
#genpept=*_15*.fa.txt.gp
#for file in $genpept;
#do python CDSparser.py $file;
#done
prot=*_15??.fa
nuc=*_15*.fa*.fa
for p in $prot;
do python align_back_trans.py fasta "$p" "$p".txt.gp.fa" "$p".fasta"
done

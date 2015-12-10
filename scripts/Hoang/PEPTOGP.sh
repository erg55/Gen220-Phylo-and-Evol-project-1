##Uncomment out below when needed
##alignproteins using maaft
module load muscle
align=*_1521.fa
for file in $align
do muscle -in $file -out $file"s" -seqtype protein -maxiters 1 -diags1 -sv
done
##output: .fas
##To match up information for both input in align_back_trans.py headers in alignment must be parsed out
parsealign=*_1521.fas
for file in $parsealign
do sed 's/lcl|//' $file | sed 's/unnamed protein product//' | sed 's/.*|//' | sed 's/\(^[0-9]\)/>\1/g' > $file.txt
done
##output: .fas.txt
##To retreive GI
FASTA=*_1521.fa
for file in $FASTA
do grep -o "[0-9]* " $file | awk 'NF' > $file".txt"
done
##output: .fa.txt
##current listing is for completion by parts: OGs starting with _15
##use GI to extract gen pept
pept=*_1521.fa.txt
##variable can be multiple arguments
for file in $pept;
do python getgenpept.py $file;
done
##output: .fa.txt.gp
##Convert Genpept and pull nucleotide sequences
genpept=*_1521.fa.txt.gp
for file in $genpept;
do python CDSparser.py $file;
done
##codon-aware nucleotide alignment see report on issues here see sample run below
#prot=*_1521.fa
#for p in $prot;
#do python align_back_trans.py fasta "$p"s.txt "$p".txt.gp.fa "$p".fasta
#done
##output: .fa.fasta
##sample run .fas file is nucleotide, .fasta is resulting nucleotide alignment based off of protein alignment
prot=sample.fa
for p in $prot
do python align_back_trans.py fasta "$p" "$p"s "$p"sta
done
##output: .fasta

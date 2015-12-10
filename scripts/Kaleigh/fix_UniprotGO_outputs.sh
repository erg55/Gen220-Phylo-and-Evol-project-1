for x in *.txt
do
cat $x | gsed 's/^.*\t//g' | gsed 's/\[.*\]//g' | gsed 's/Gene ontology (GO)//g' 
done
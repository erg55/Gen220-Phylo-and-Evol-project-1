#qsub -l mem=16gb -q highmem -I all-v-all2.sh 
module load ncbi-blast
blastp -db goodProteins.fasta -query goodProteins.fasta -outfmt 6 -out blastresults.tsv -num_threads 8 
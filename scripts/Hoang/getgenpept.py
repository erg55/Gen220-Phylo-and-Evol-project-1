import sys
import Bio
from Bio import Entrez
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
from Bio import SeqIO
Entrez.email = "hvuon007@ucr.edu"
i = sys.argv[1]
z = open('%s.gp' % i, "w")
with open(i) as f:
	pepid =[]
	for line in f:
		line = line.strip()
		pepid.append(line)


handle = Entrez.efetch(db="protein", id=pepid, rettype="gp", retmode="text")
z.write("%s" % handle.read())
handle.close()
z.close


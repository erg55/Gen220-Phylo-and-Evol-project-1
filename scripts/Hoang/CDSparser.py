import sys
import Bio
from Bio import Entrez
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
from Bio import SeqIO
Entrez.email = "hvuon007@ucr.edu"
def get_nuc_by_name(name, start=None, end=None) :
   record = SeqIO.read(Entrez.efetch("nucleotide",
                                     id=name.strip(),
                                     seq_start=start,
                                     seq_stop=end,
                                     retmode="text",
                                     rettype="fasta"), "fasta")
   return record.seq

def get_nuc_from_coded_by_string(source) : 
   if source.startswith("complement(") :
       assert source.endswith(")")
       return get_nuc_from_coded_by_string(source[11:-1]).reverse_complement()
   if source.startswith("join(") :
       assert source.endswith(")")
       return Seq("".join(str(get_nuc_from_coded_by_string(s)) \
                          for s in source[5:-1].split(",")))
   if "(" in source or ")" in source \
   or source.count(":") != 1 or source.count("..") != 1 :
       raise ValueError("Don't understand %s" % repr(source))
   name, loc = source.split(":")
   start, end = [int(x.lstrip("<>")) for x in loc.split("..")]
   return get_nuc_by_name(name,start,end)

def find_protein_within_nuc(protein_seq, nuc_seq, table) :
   for frame in [0,1,2] :
       start = nuc_seq[frame:].translate(table).find(protein_seq)
       if start != -1 :
          return nuc_seq[frame+3*start:frame+3*(start+len(protein_seq))]
   rev_seq = nuc_seq.reverse_complement()
   for frame in [0,1,2] :
       start = rev_seq[frame:].translate(table).find(protein_seq)
       if start != -1 :
          return rev_seq[frame+3*start:frame+3*(start+len(protein_seq))]
   raise ValueError("Could not find the protein sequence "
                    "in any of the six translation frames.")

def get_nuc_record(protein_record, table="Standard") :
   if not isinstance(protein_record, SeqRecord) :
       raise TypeError("Expect a SeqRecord as the protein_record.")
   feature = None
   for f in protein_record.features :
       if f.type == "CDS" and "coded_by" in f.qualifiers :
           feature = f
           break
   if feature :
       assert feature.location.start.position == 0
       assert feature.location.end.position == len(protein_record)
       source = feature.qualifiers["coded_by"][0]
       print "Using %s" % source
       #return SeqRecord(Seq(""))
       nuc = get_nuc_from_coded_by_string(source)
       #See if this included the stop codon - they don't always!
       if str(nuc[-3:].translate(table)) == "*" :
           nuc = nuc[:-3]
   elif "db_source" in protein_record.annotations :
       parts = protein_record.annotations["db_source"].split()
       source = parts[parts.index("xrefs:")+1].strip(",;")
       print "Using %s" % source
       nuc_all = get_nuc_by_name(source)
       nuc = find_protein_within_nuc(protein_record.seq, nuc_all, table)
   else :
       raise ValueError("Could not determine CDS source from record.")
   assert str(nuc.translate(table)) == str(protein_record.seq), \
          "Translation:\n%s\nExpected:\n%s" \
          % (translate(nuc,table), protein_record.seq)
   return SeqRecord(nuc, id=protein_record.annotations["gi"],
                    description="")

#Now use the above functions to fetch the CDS sequence for some proteins...
i = sys.argv[1] #any proteins in GenBank/GenPept format.
nucs = (get_nuc_record(p, table="Standard") for p \
         in SeqIO.parse(open(i),"genbank"))
handle = open('%s.fa' % i ,"w")
SeqIO.write(nucs, handle, "fasta")
handle.close()
print "Done"

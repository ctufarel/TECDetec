## Illumina Paired-end RNA-seq Datasets Simulation
## Simulated Illumina paired end RNA-Seq reads are using Illumina RNA ligation method for library preparation

outdir="./SimReads/Sample_with7lcts"
mkdir $outdir
# Fasta file of known mRNA transcripts for simulation
refseq_pool="./RefSeqTrans/rna.fa"

# Fasta file of 7 LCT sequences
lct_seq="./LCTseq/LCTseq.fa"

# Sample data from ref seq pool
Rscript sample_ref_seq.R 1000 $refseq_pool $outdir"/refseq_sample.fa"

# Assign expression level to each transcript in sample
./rlsim-1.4_amd64/bin/sel -d "0.5:g:(100,0.5) + 0.5:g:(1000,1000)" $outdir"/refseq_sample.fa" > $outdir"/refseq_sample_withExpLevel.fa"
mv sel_report.pdf $outdir"/sel_report_refseqsample.pdf"

# Assign expression level to each LCT
# -d weight:type(gamma distribution):parameters(mean,shape)
./rlsim-1.4_amd64/bin/sel -d "1.0:g:(100,100)" $lct_seq > $outdir"/LCTseq_withExpLevel.fa"
mv sel_report.pdf $outdir"/sel_report_LCTseq.pdf"

# merge sample transcripts and LCTs
cat $outdir"/refseq_sample_withExpLevel.fa" $outdir"/LCTseq_withExpLevel.fa" > $outdir"/my_transcripts.fa"

# -d weight:type(g):parameter(mean,shape,minimum,maximum)
./rlsim-1.4_amd64/bin/rlsim -n 2000000 -b 0.0 $outdir"/my_transcripts.fa" > $outdir"/trans_frags.fa"

# Generate Illumina paired end reads
cat $outdir"/trans_frags.fa" | ./simNGS/bin/simNGS -p paired -o fastq -O $outdir"/sim_reads" simNGS/data/s_3_4x.runfile

# mv temp files
mv rlsim_report.json $outdir
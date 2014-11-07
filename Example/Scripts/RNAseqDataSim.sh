## Illumina Paired-end RNA-seq Datasets Simulation
## Simulated Illumina paired end RNA-Seq reads are using Illumina RNA ligation method for library preparation

outdir="./SimReads/Sample_3"

# Fasta file of known mRNA transcripts for simulation
refseq_pool="./RefSeqTrans/rna.fa"

# Fasta file of 8 LCT sequences
lct_seq="./LCTseq/CT_novel_LCTseq.fasta"

# Sample data from ref seq pool
Rscript sample_ref_seq.R 1000 $refseq_pool $outdir"/refseq_sample.fna"

# Assign expression level to each transcript in sample
./rlsim-1.4_amd64/bin/sel -d "0.5:g:(100,0.5) + 0.5:g:(1000,1000)" $outdir"/refseq_sample.fna" > $outdir"/refseq_sample_withExpLevel.fna"
mv sel_report.pdf $outdir"/sel_report_refseqsample.pdf"

# Assign expression level to each LCT
# -d weight:type(gamma distribution):parameters(mean,shape)
./rlsim-1.4_amd64/bin/sel -d "1.0:g:(100,100)" $lct_seq > $outdir"/CT_novel_LCTseq_withExpLevel.fna"
mv sel_report.pdf $outdir"/sel_report_LCTseq.pdf"

# merge sample transcripts and LCTs
cat $outdir"/refseq_sample_withExpLevel.fna" $outdir"/CT_novel_LCTseq_withExpLevel.fna" > $outdir"/sample_transcripts.fasta"

# -d weight:type(g):parameter(mean,shape,minimum,maximum)
./rlsim-1.4_amd64/bin/rlsim -n 2000000 -b 0.0 $outdir"/sample_transcripts.fasta" > $outdir"/sample_trans_frags.fasta"

# Generate Illumina paired end reads
cat $outdir"/sample_trans_frags.fasta" | ./simNGS/bin/simNGS -p paired -o fastq -O $outdir"/sim_reads" simNGS/data/s_3_4x.runfile > $outdir"/simNGS_run.like" 2>&1

# mv temp files
mv rlsim_report.json $outdir
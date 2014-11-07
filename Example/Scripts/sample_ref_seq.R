#Select random fasta sequences from refseq pool

library(Biostrings)

#-------------Get command-line arguments and read files------------
args <- commandArgs(trailingOnly = TRUE)
num <- args[1]
filein <- args[2]
fileout <- args[3]

# Read known fasta file
file <- readDNAStringSet(filein)

# Sample num sequences
samp.file <- sample(file, num)

# Write subset of fasta sequences to file
writeXStringSet(samp.file, file=fileout)

library(Rsamtools)
library(ATACseqQC)
library(here)

# Import bam file into R using the function BamFile
bamPath <- file.path(here(), "SM4492_trim.bam")
bamFile <- BamFile(bamPath)
bamFile

bamFile.labels <- "TRAP Tn5 0.25ul"

# Chromosome info on the header of the bam file
seqinfo(bamFile)

# Fragment size distribution and save in png
png("fragSize_SM4494.png")

fragSizeDist(bamPath, bamFile.labels)

dev.off()

# Estimate the library complexity
estimateLibComplexity(readsDupFreq(bamFile))

# Remove all variables in environment
rm(list = ls())




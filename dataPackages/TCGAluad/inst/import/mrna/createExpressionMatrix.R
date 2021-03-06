# createMatrix.R
# the mrna comes from cBio 2013 TCGA luad expression data set
# the serialized result is written to extdata, as a numerical matrix  conforming to
# oncoscape protocols:
#
#   NA for missing values
#   sample names for rownames
#   gene symbols for colnames
#   policies yet to be worked out for gene isoforms and multiple measurements for each sample
#
#----------------------------------------------------------------------------------------------------
library(RUnit)
#--------------------mrna_seq------------------------
table.mrna <- read.table(file="../../../../RawData/TCGAluad/mysql_cbio_mrna2013_Seq.csv", header=F, skip=3, as.is=T)
## 490 samples(patients) x 20444 genes

sampleString <- readLines(con="../../../../RawData/TCGAluad/mysql_cbio_mrna2013_Seq.csv", n=2)[[2]]
samples <- strsplit(sampleString, "\t")[[1]][2]
samples <- strsplit(samples, ",")[[1]]
sample.tbl <- read.delim(file="../../../../RawData/TCGAluad/mysql_cbio_samples.txt", header=T, as.is=T, sep="\t")
BarcodeSample <- sample.tbl[match(samples, sample.tbl[,1]), 2]
BarcodeSample <- gsub("\\-", "\\.", BarcodeSample)


EntrezGenes <- table.mrna[,2]
genes.tbl <- read.delim(file="../../../../RawData/mysql_cbio_genes.txt", header=T, as.is=T, sep="\t")
HugoGenes <- genes.tbl[match(EntrezGenes, genes.tbl[,1]), 2]

table.mrna <- table.mrna[,-c(1,2)]
list.mrna <- strsplit(table.mrna, ",")
mtx.mrna <- matrix(as.double(unlist(list.mrna)), nrow = length(samples), byrow = F)
dimnames(mtx.mrna) <- list(BarcodeSample,HugoGenes)

checkEquals(dim(mtx.mrna), c(490, 20444))
  # all good values
checkEquals(length(which(is.na(mtx.mrna))), 758520)
checkEquals(fivenum(mtx.mrna), c(-4.8681,   -0.5498,   -0.2024,    0.2909, 38659.0448))
                                 
save(mtx.mrna, file="../../extdata/mtx.mrna_Seq.RData")
printf("saved mtx.mrna (%d, %d) to parent directory", nrow(mtx.mrna), ncol(mtx.mrna))## couldn't run

#--------------------mrna_Agilent------------------------
table.mrna <- read.table(file="../../../../RawData/TCGAluad/mysql_cbio_mrna2013_Agi.csv", header=F, skip=3, as.is=T)
## 490 samples(patients) x 20444 genes

sampleString <- readLines(con="../../../../RawData/TCGAluad/mysql_cbio_mrna2013_Agi.csv", n=2)[[2]]
samples <- strsplit(sampleString, "\t")[[1]][2]
samples <- strsplit(samples, ",")[[1]]
sample.tbl <- read.delim(file="../../../../RawData/TCGAluad/mysql_cbio_samples.txt", header=T, as.is=T, sep="\t")
BarcodeSample <- sample.tbl[match(samples, sample.tbl[,1]), 2]
BarcodeSample <- gsub("\\-", "\\.", BarcodeSample)


EntrezGenes <- table.mrna[,2]
genes.tbl <- read.delim(file="../../../../RawData/mysql_cbio_genes.txt", header=T, as.is=T, sep="\t")
HugoGenes <- genes.tbl[match(EntrezGenes, genes.tbl[,1]), 2]

table.mrna <- table.mrna[,-c(1,2)]
list.mrna <- strsplit(table.mrna, ",")
mtx.mrna <- matrix(as.double(unlist(list.mrna)), nrow = length(samples), byrow = F)
dimnames(mtx.mrna) <- list(BarcodeSample,HugoGenes)

checkEquals(dim(mtx.mrna), c(32, 17212))
# all good values
checkEquals(length(which(is.na(mtx.mrna))), 25035)
checkEquals(fivenum(mtx.mrna), c(-28.7792 , -0.7019 , -0.0091  , 0.7126,  22.6737))

save(mtx.mrna, file="../../extdata/mtx.mrna_Agi.RData")
printf("saved mtx.mrna (%d, %d) to parent directory", nrow(mtx.mrna), ncol(mtx.mrna))## couldn't run

# Usage Example
## In Treated VS Control context
### *Peak calling for methylation sites in case-control context*
```r
library(exomePeak)
library(GenomicFeatures)
f1 <- "./CTL_IP1.bam"
f2 <- "./CTL_IP2.bam"
f3 <- "./CTL_Input1.bam"
f4 <- "./CTL_Input2.bam"
f5 <- "./M3KD_IP1.bam"
f6 <- "./M3KD_IP2.bam"
f7 <- "./M3KD_Input1.bam"
f8 <- "./M3KD_Input2.bam"
IP_BAM <- c(f1,f2,f5,f6)
INPUT_BAM <- c(f3,f4,f7,f8)

GENE_ANNO_GTF = "./hg19_GTF/genes.gtf"
txdbfile <- GenomicFeatures::makeTxDbFromGFF(GENE_ANNO_GTF)
txdb <- txdbfile
result = exomepeak(TXDB=txdb, IP_BAM=IP_BAM, INPUT_BAM=INPUT_BAM, OUTPUT_DIR= "./exomePeak_calling/")
```
### *Identify reader binding sites from CLIP-seq data*
#### *For PAR-CLIP-seq data*
```r
library(stringr)
library(wavClusteR)
library(BSgenome.Hsapiens.UCSC.hg19)
library(GenomicFeatures)
reader_binding <- "./reader_binding.bam"
obtain_reader_bindingsites <- reader_bindingsites(par_bam=YTHDF2_binding,annotation_file=GENE_ANNO_GTF)
```
#### *For eCLIP-seq or ICLIP-seq data*
```bash
nohup pureclip -i /home/disk1/zhangteng/BAM_file/HepG2_BAMfile/IGF2BP1_eCLIP/IGF2BP1_rep1.bam -i /home/disk1/zhangteng/BAM_file/HepG2_BAMfile/IGF2BP1_eCLIP/IGF2BP1_rep2.bam -bai /home/disk1/zhangteng/BAM_file/HepG2_BAMfile/IGF2BP1_eCLIP/IGF2BP1_rep1.bam.bai -bai /home/disk1/zhangteng/BAM_file/HepG2_BAMfile/IGF2BP1_eCLIP/IGF2BP1_rep2.bam.bai  -g /home/disk1/zhangteng/iGenome/hg19/Homo_sapiens/UCSC/hg19/Sequence/WholeGenomeFasta/genome.fa -o /home/disk1/zhangteng/BAM_file/HepG2_BAMfile/IGF2BP1_eCLIP/IGF2BP1_eCLIP.bed -or /home/disk1/zhangteng/BAM_file/HepG2_BAMfile/IGF2BP1_eCLIP/IGF2BP1_eCLIPbindingregion.bed -nt 30 &
```

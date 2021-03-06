\name{m6Aexpress_Reader_model}
\alias{m6Aexpress_Reader_model}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
m6AexpressReader model
}
\description{
Predict m6A regulated expression gene under m6A reader binding context
}
\usage{
m6Aexpress_Reader_model(candidate_gene_infor,
                        bindgene_strength_infor,
                        CUTOFF_TYPE="pvalue",
                        pvalue, FDR,out_dir=NA)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{candidate_gene_infor}{
A list data format, the first is the path file of paired reads count and methylation level for each gene in each samples; the second is the path file of differential expression and differential methylation information for candidate gene; the third is a vector with libray sizes factor for INPUT samples used to normalized the gene expression for INPUT samples.
}
  \item{bindgene_strength_infor}{
A dataframe format file, including the m6A readering binding signal strength for each reader binding gene.
}
  \item{CUTOFF_TYPE}{
A string, such as "pvalue", which specifies the tpye of cut-off to identify significant m6A regulated express gene (m6-reg-exp gene) in m6A reader binding context, default: \code{CUTOFF_TYPE="pvalue"}.
}
  \item{pvalue}{
a decimal number, which specifies the p-value cut-off in the predicting m6A regulated expression gene of m6A-express model.
}
 \item{FDR}{ a decimal number, which specifies the FDR cut-off in the predicting m6A regulated expression gene of m6A-express model, default: 0.05.
}
 \item{out_dir}{
A string, which specify the output directory, default: out_dir=NA, the output result will save in the current directory. Otherwise, \code{m6AexpressReader} will output the significant m6A regulated expression gene under given cutoff, e.g. \code{pvalue<0.05} or \code{FDR<0.05}.
}
}
\details{
This function is used to predicate m6A regulated expression gene by m6AexpressReader model considering m6A reader binding information.
}
\value{
The predicting m6A methylation regulated expression (m6A-reg-exp) genes under given cut-off in .XLS (tab-delimited) format file. The .XLS file includes five columns: the name of m6A-reg-exp gene, Beta0, Beta1, pvalue and FDR.
 \item{gene_name}{The name of m6A methylation regulated expression gene in the given annotation file.}
 \item{Beta0}{Beta0 is a gene-specific intercept and models the baseline log gene expression.}
 \item{Beta1}{Beta1 captures the influence of m6A methylation on gene expression.}
 \item{pvalue}{pvalue of the predicted m6A-reg-exp genes.}
 \item{FDR}{FDR of the predicted m6A-reg-exp genes.}
 \item{DE_LFC}{The log2foldchange of differential expression for m6A-reg-exp genes.}
 \item{DM_LFC}{The log2foldchange of differential methylation for m6A-reg-exp genes.}
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Teng Zhang <tengzhang126@163.com>
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
\dontrun{
## Obtain the reader binding strength for reader binding gene
gene_bind_strength <- bindgene_SNR(bindgene_peak_SNR_infor=add_binding_strength_dist)
## Predicate the m6A-reg-exp gene by m6Aexpress-Reader model
m6Aregexpgene_m6AexpressReader <- m6Aexpress_Reader_model(candidate_gene_infor=candidate_gene_infor,
                                                          bindgene_strength_infor=gene_bind_strength,
                                                          CUTOFF_TYPE=pvalue,pvalue=0.05,
                                                          out_dir="./m6AexpressReader_result/")

}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line

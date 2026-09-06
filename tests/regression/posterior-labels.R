# Run from repository root: Rscript --vanilla tests/regression/posterior-labels.R .
# Native production object creation and post-processing; deterministic sampler.
args <- commandArgs(trailingOnly=TRUE)
root <- if (length(args)) args[1] else '.'
suppressPackageStartupMessages(library(dplyr))
prod <- new.env(parent=globalenv())
for (file in c('createSiberObject.R','ellipseBackTransform.R','siberMVN.R'))
  sys.source(file.path(root,'R',file),envir=prod)
prod$fitEllipse <- function(x,y,parms,priors,id=NULL) {
  # Identity covariance and zero means in standardized units, two draws.
  matrix(rep(c(1,0,0,1,0,0),2),nrow=2,byrow=TRUE)
}
variance <- c('1.1'=1,'1.2'=4,'2.1'=100,'2.2'=25)
make_input <- function(keys) {
  repeated <- rep(keys,each=5)
  scales <- sqrt(unname(variance[repeated]))
  data.frame(iso1=rep(sqrt(2)*c(-1,1,0,0,0),length(keys))*scales,
             iso2=rep(sqrt(2)*c(0,0,-1,1,0),length(keys))*scales,
             group=sub('.*[.]','',repeated),
             community=as.integer(sub('[.].*','',repeated)))
}
passed <- 0L; failed <- 0L
for (keys in list(c('1.1','2.1'),c('2.1','1.1'),
                  c('1.1','2.1','1.2','2.2'),
                  c('2.2','1.2','2.1','1.1'),
                  c('1.2','1.1','2.2','2.1'))) {
  tryCatch({
    s <- prod$createSiberObject(make_input(keys))
    out <- prod$siberMVN(s,list(),list())
    stopifnot(setequal(names(out),keys),!anyDuplicated(names(out)))
    for (key in keys) {
      area <- pi*sqrt(det(matrix(out[[key]][1,1:4],2,2)))
      stopifnot(isTRUE(all.equal(unname(area),unname(pi*variance[key]))))
    }
    passed <- passed+1L
    cat('PASS:',paste(keys,collapse=','),'\n')
  },error=function(e) {
    failed <<- failed+1L
    cat('FAIL:',paste(keys,collapse=','),conditionMessage(e),'\n')
  })
}
cat(sprintf('PACK_RESULT={"tests":%d,"failures":%d,"errors":0,"skipped":0}\n',passed+failed,failed))
quit(status=if (failed) 1L else 0L)

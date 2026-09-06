# Run: Rscript --vanilla tests/regression/posterior-means.R .
# No stochastic fitting: this tests the actual deterministic back-transform.
args <- commandArgs(trailingOnly=TRUE)
root <- if (length(args)) args[1] else '.'
prod <- new.env(parent=globalenv())
sys.source(file.path(root,'R','ellipseBackTransform.R'),envir=prod)
passed <- 0L; failed <- 0L
for (sd in list(c(1,1),c(10,2),c(.1,.2),c(2,10))) {
  tryCatch({
    s <- list(ML.cov=list(array(diag(sd^2),c(2,2,1))),
              ML.mu=list(array(c(100,200),c(1,2,1))))
    z <- matrix(c(1,.2,.2,1,1,-1,1,.2,.2,1,-1,1),nrow=2,byrow=TRUE)
    out <- prod$ellipseBackTransform(z,s,1,1)
    expected.mu <- sweep(sweep(z[,5:6,drop=FALSE],2,sd,'*'),2,c(100,200),'+')
    stopifnot(isTRUE(all.equal(unname(out[,5:6]),unname(expected.mu))))
    expected.cov <- diag(sd) %*% matrix(z[1,1:4],2,2) %*% diag(sd)
    for (i in 1:2)
      stopifnot(isTRUE(all.equal(matrix(out[i,1:4],2,2),expected.cov)))
    passed <- passed+1L
    cat('PASS: SD',paste(sd,collapse=','),'\n')
  },error=function(e) {
    failed <<- failed+1L
    cat('FAIL: SD',paste(sd,collapse=','),conditionMessage(e),'\n')
  })
}
cat(sprintf('PACK_RESULT={"tests":%d,"failures":%d,"errors":0,"skipped":0}\n',passed+failed,failed))
quit(status=if (failed) 1L else 0L)

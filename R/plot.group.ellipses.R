# function to add ellipses to each group

plot.group.ellipses <- function(siber, plot.args = NULL,...){
  for (i in 1:siber$n.communities){
    
    for (j in 1:siber$n.groups[2,i]){
      
      do.call('add.ellipse',
                c(list(mu = siber$ML.mu[[i]][,,j],
                     sigma = siber$ML.cov[[i]][,,j]),
                     plot.args,
                     col = j,
                     ...))
#       add.ellipse(siber$ML.mu[[i]][,,j],
#                   siber$ML.cov[[i]][,,j],
#                   col = j, ...)
    }
    
  }
}
# need to move this code over to the eigen value formulation... which is the 
# form i thought it was in!

sigma.SEA <- function(sigma){

  eig <- eigen(sigma)
  
  a <- sqrt(eig$values[1])
  b <- sqrt(eig$values[2])
  
  # NB this is the line causing odd ellipses to be drawn occasionally
  # I suspect there is an internal re-ordering of the axes going on 
  # underlying this. This behaviour is similar to what Mike Fowler and I
  # are struggling with in our linear system stability research.
  #theta <- asin(eig$vectors[1,2]) # OLD LINE #
  theta <- sign(sigma[1,2]) * asin(abs(eig$vectors[2,1])) # NEW LINE 11/07/2011
  
  SEA <- pi*a*b
  
  


  out <- list()
  out$SEA <- pi*a*b
  out$eccentricity <- sqrt(1-((b^2)/(a^2)))
  out$a <- a
  out$b <- b

  return(out)
}
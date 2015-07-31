popSEA <- function(sigma){

A <- sigma[2,2]
C <- sigma[1,1]

B <- -sigma[1,2]

cr <- cov2cor(sigma)

D <- (1-(cr[1,2]^2))*A*C

R <- sqrt((A-C)^2 + 4*B^2)

a <- sqrt(2*D/(A+C-R))
b <- sqrt(2*D/(A+C+R))


out <- list()
out$SEA <- pi*a*b
out$eccentricity <- sqrt(1-((b^2)/(a^2)))
out$a <- a
out$b <- b

return(out)
}
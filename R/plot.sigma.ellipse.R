plot.sigma.ellipse <- function(m,sigma,steps=5,...){

# Extract the coefficients
A <- sigma[2,2]
C <- sigma[1,1]

B <- -sigma[1,2]

cr <- cov2cor(sigma)

D <- (1-(cr[1,2]^2))*A*C

R <- sqrt((A-C)^2 + 4*B^2)

theta <- atan(2*B/(A-C-R))

a <- sqrt(2*D/(A+C-R))
b <- sqrt(2*D/(A+C+R))

# generate the x,y coordinates of the ellipse


psi <- seq(0,2*pi,steps*pi/180)

xtmp <- m[1] + a*cos(theta)*cos(psi) - b*sin(theta)*sin(psi)
ytmp <- m[2] + a*sin(theta)*cos(psi) + b*cos(theta)*sin(psi)

tmp <- siber.convexhull(xtmp,ytmp)

xSEA <- tmp$xcoords
ySEA <- tmp$ycoords

lines(xSEA, ySEA, ...)

out <- list()
out$xSEA <- xSEA
out$ySEA <- ySEA
return(out)


}
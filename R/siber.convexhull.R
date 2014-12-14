siber.convexhull <- function(x,y){

chI <- chull(x,y)
chI <- c(chI,chI[1])
hullX <- x[chI]
hullY <- y[chI]

TA <- hullarea(hullX,hullY)

out <- list()
out$TA <- TA
out$xcoords <- hullX
out$ycoords <- hullY
out$ind <- chI

out

}
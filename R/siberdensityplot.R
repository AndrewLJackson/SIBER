#' Plot credible intervals as shaded boxplots using 
#' \code{\link[hdrcde]{hdr.boxplot}}
#' 
#' This function is essentially \code{\link[hdrcde]{hdr.boxplot}} but it more
#' easily works with matrices of data, where each column is a different variable
#' of interest. It has some limitations though....
#' 
#' @section Warning:: This function will not currently recognise and plot 
#'   multimodal distributions, unlike \code{\link[hdrcde]{hdr.boxplot}}. You
#'   should take care, and plot basic histograms of each variable (column in the
#'   object you are passing) to \code{siardensityplot} and check that they are
#'   indeed unimodal as expected.
#'   
#'   
#' @param dat a matrix of data for which density region boxplots will be 
#'   constructed and plotted for each column.
#' @param probs a vector of credible intervals to represent as box edges. 
#'   Defaults to \code{c(95, 75, 50)}.
#' @param xlab a string for the x-axis label. Defaults to \code{"Group"}.
#' @param ylab a string fo the y-axis label. Defaults to \code{"Value"}.
#' @param xticklabels a vector of strings to override the x-axis tick labels.
#' @param yticklabels a vector of strings to override the y-axis tick labels.
#' @param clr a vector of colours to use for shading each of the box regions. 
#'   Defaults to greyscale \code{grDevices::gray((9:1)/10)}.
#' @param scl a scalar multiplier to scale the box widths. Defaults to 1.
#' @param xspc a scalar determining the amount of spacing between each box. 
#'   Defaults to 0.5.
#' @param prn a logical value determining whether summary statisics of each 
#'   column should be printed to screen \code{prn = TRUE} or suppressed as per 
#'   default \code{prn = FALSE}.
#' @param ct a string of either \code{c("mode", "mean", "median")} which 
#'   determines which measure of central tendancy will be plotted as a point in 
#'   the middle of the boxes. Defaults to "mode".
#' @param ylims a vector of length two, specifying the lower and upper limits 
#'   for the y-axis. Defaults to NULL which inspects the data for appropriate 
#'   limits.
#' @param lbound a lower boundary to specify on the distribution to avoid the 
#'   density kernel estimating values beyond that which can be expecte a priori.
#'   Useful for example when plotting dietary proportions which must lie in the
#'   interval \code{0 <= Y <= 1}. Defaults to -Inf
#' @param ubound an upper boundary to specify on the distribution to avoid the 
#'   density kernel estimating values beyond that which can be expecte a priori.
#'   Useful for example when plotting dietary proportions which must lie in the
#'   interval \code{0 <= Y <= 1}. Defaults to +Inf.
#' @param main a title for the figure. Defaults to blank.
#' @param ylab.line a postive scalar indicating the line spacing for rendering 
#'   the y-axis label. This is included as using the permille symbol has a 
#'   tendancy to push the axis label off the plotting window margins. See the 
#'   \code{line} option in \code{\link[graphics]{axis}} for more details as 
#'   ylab.line passes to this.
#' @param ... further graphical parameters for passing to 
#'   \code{\link[graphics]{plot}}
#'   
#' @return A new figure window.
#'   
#' @examples
#' Y <- matrix(stats::rnorm(1000), 250, 4)
#' siberDensityPlot(Y)
#' @export



siberDensityPlot <- function (dat, probs = c(95, 75, 50),
                             xlab = "Group", ylab = "Value", 
                             xticklabels = NULL, yticklabels = NULL, 
                             clr = grDevices::gray((9:1)/10), 
                             scl = 1, xspc = 0.5, prn = F, 
                             ct = "mode", ylims = NULL, 
                             lbound = -Inf, ubound = Inf, main = "", 
                             ylab.line = 2, ...) 
{
  n <- ncol(dat)
  if (is.null(ylims)) {
    ylims <- c(min(dat) - 0.1 * min(dat), max(dat) + 0.1 * 
                 (max(dat)))
  }
  
  # set up a blank plot
  graphics::plot(1, 1, xlab = "", ylab = "",
                 main = main,
                 xlim = c(1 - xspc, n + xspc),
                 ylim = ylims,
                 type = "n",
                 xaxt = "n", 
                 ...)
  
  # add xlabel text
  graphics::title(xlab = xlab)
  
  # add ylabel text at specific line
  graphics::title(ylab = ylab, line = ylab.line)
  
  if (is.null(xticklabels)) {
    graphics::axis(side = 1, at = 1:n, labels = (as.character(names(dat))))
  }
  else {
    graphics::axis(side = 1, at = 1:n, labels = (xticklabels))
  }
  clrs <- rep(clr, 5)
  for (j in 1:n) {
    temp <- hdrcde::hdr(dat[, j], probs, h = stats::bw.nrd0(dat[, j]))
    line_widths <- seq(2, 20, by = 4) * scl
    bwd <- c(0.1, 0.15, 0.2, 0.25, 0.3) * scl
    if (prn == TRUE) {
      cat(paste("Probability values for Column", j, "\n"))
      cat(paste("\t", "Mode",
                format(temp$mode, digits = 3, scientific = F),
                "Mean",
                format(mean(dat[, j]), digits = 3, scientific = F),
                "Median",
                format(stats::median(dat[, j]), digits = 3, scientific = F), 
                "\n")
          )
    }
    for (k in 1:length(probs)) {
      temp2 <- temp$hdr[k, ]
      
      graphics::polygon(c(j - bwd[k], j - bwd[k], j + bwd[k], j + bwd[k]), 
                        c(max(c(min(temp2[!is.na(temp2)]), lbound)), 
                          min(c(max(temp2[!is.na(temp2)]), ubound)), 
                          min(c(max(temp2[!is.na(temp2)]), ubound)), 
                          max(c(min(temp2[!is.na(temp2)]), lbound))), 
                        col = clrs[k])
      if (ct == "mode") {
        graphics::points(j, temp$mode, pch = 19)
      }
      if (ct == "mean") {
        graphics::points(j, mean(dat[, j]), pch = 19)
      }
      if (ct == "median") {
        graphics::points(j, stats::median(dat[, j]), pch = 19)
      }
      
      if (prn == TRUE) {
        cat(paste("\t", probs[k], "% lower =",
                  format(max(min(temp2[!is.na(temp2)]), lbound), 
                         digits = 3, scientific = FALSE), "upper =", 
                  format(min(max(temp2[!is.na(temp2)]), ubound), 
                         digits = 3, scientific = FALSE), "\n"))
      }
    }
  }
}


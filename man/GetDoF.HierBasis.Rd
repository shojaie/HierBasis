% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/hier_basis.R
\name{GetDoF.HierBasis}
\alias{GetDoF.HierBasis}
\title{Extract Degrees of Freedom}
\usage{
GetDoF.HierBasis(object, lam.index = NULL)
}
\arguments{
\item{object}{An object of class \code{HierBasis}}

\item{lam.index}{An optional integer specifying the index of the
       lambda value. If \code{lam.index} is \code{NULL} (default)
       then the degrees of freedom are calculated for each lambda value.}
}
\value{
\item{dof}{A vector of degrees of freedom for a given lambda value, as
            specified by \code{lam.index}. If no index is specified then
            it returns a vector of length \code{object$nlam}.}
}
\description{
Extract Degrees of Freedom
}
\examples{
require(Matrix)

set.seed(1)

# Generate the points x.
n <- 300
x <- (1:300)/300

# A simple quadratic function.
y1 <- 5 * (x - 0.5)^2
y1dat <- y1 + rnorm(n, sd = 0.1)

poly.fit <- HierBasis(x, y1dat)
dof <- GetDoF.HierBasis(poly.fit)

\dontrun{
ind <- which.min(abs(dof - 3))[1]
plot(x, y1dat, type = "p", ylab = "y1")
lines(x, y1, lwd = 2)
lines(x, poly.fit$fitted.values[, ind], col = "red", lwd = 2)
}
}
\author{
Asad Haris (\email{aharis@uw.edu}),
Ali Shojaie and Noah Simon
}
\references{
Haris, A., Shojaie, A. and Simon, N. (2016). Nonparametric Regression with
Adaptive Smoothness via a Convex Hierarchical Penalty. Available on request
by authors.
}
\seealso{
\code{\link{HierBasis}}, \code{\link{predict.HierBasis}}
}


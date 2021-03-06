% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/hier_basis_additive.R
\name{AdditiveHierBasis}
\alias{AdditiveHierBasis}
\title{Estimating Sparse Additive Models}
\usage{
AdditiveHierBasis(x, y, nbasis = 10, max.lambda = NULL,
  lam.min.ratio = 1e-04, nlam = 50, beta.mat = NULL, alpha = NULL,
  m.const = 3, max.iter = 100, tol = 1e-04, type = c("gaussian",
  "binomial"), intercept = NULL, line.search.par = 0.5, step.size = 1)
}
\arguments{
\item{x}{An \eqn{n \times p}{n x p} matrix of covariates.}

\item{y}{The response vector size \eqn{n}.}

\item{nbasis}{The maximum number of basis functions.}

\item{max.lambda}{The largest lambda value used for model fitting.}

\item{lam.min.ratio}{The ratio of smallest and largest lambda values.}

\item{nlam}{The number of lambda values.}

\item{beta.mat}{An initial estimate of the parameter beta, a
\code{ncol(x)}-by-\code{nbasis} matrix. If NULL (default), the inital estimate
is the zero matrix.}

\item{alpha}{The scaler between 0 and 1 controlling the balance between
the sparsity penalty and the hierarchical penalty. Default is 0.5.}

\item{m.const}{The order of smoothness, usually not more than 3 (default).}

\item{max.iter}{Maximum number of iterations for block coordinate descent.}

\item{tol}{Tolerance for block coordinate descent, stopping precision.}

\item{type}{Specifies type of regression, "gaussian" is for linear regression with continous
response and "binomial" is for logistic regression with binary response.}

\item{intercept}{For logistic regression, this specifies an initial value for
the intercept. If \code{NULL} (default), then the initial value is the coefficient of
the null model obtained by \code{glm} function.}

\item{line.search.par}{For logistic regression, the parameter for the line search
within the proximal gradient descent algorithm, this must be within the interval \eqn{(0,\, 1)}.}

\item{step.size}{For logistic regression, an initial step size for the line search algorithm.}
}
\value{
An object of class addHierBasis with the following elements:

\item{beta}{The \code{(nbasis * p)} \eqn{\times}{x} \code{nlam} matrix of
estimated beta vectors.}
\item{intercept}{The vector of size \code{nlam} of estimated intercepts.}
\item{fitted.values}{The \code{n} \eqn{\times}{x} \code{nlam} matrix of fitted values.}
\item{lambdas}{The sequence of lambda values used for
fitting the different models.}
\item{x, y}{The original \code{x} and \code{y} values used for estimation.}
\item{m.const}{The \code{m.const} value used for defining 'order' of smoothness.}
\item{nbasis}{The maximum number of basis functions
used for additive HierBasis.}
\item{xbar}{The \code{nbasis} \eqn{\times}{x} \code{p} matrix of means
of the full design matrix.}
\item{ybar}{The mean of the vector y.}
}
\description{
The main function for fitting sparse additive models via the additive
HierBasis estimator
}
\details{
This function
fits an additive nonparametric regression model. This is achieved by
minimizing the following function of \eqn{\beta}:
\deqn{minimize_{\beta_1,\ldots, \beta_p}
(1/2n)||y - \sum \Psi_l \beta_l||^2 +
\sum (1 - \alpha) || \beta_l ||_2 + \alpha \Omega_m( \beta_l )  ,}
where \eqn{\beta_l} is a vector of length \eqn{J = } \code{nbasis} and the summation is
over the index \eqn{l}.
The penalty function \eqn{\Omega_m} is given by \deqn{\sum a_{j,m}\beta[j:J],}
where \eqn{\beta[j:J]} is \code{beta[j:J]} for a vector \code{beta} and the sum is
over the index \eqn{j}.
Finally, the weights \eqn{a_{j,m}} are given by
\deqn{a_{j,m} = j^m - (j-1)^m,} where \eqn{m} denotes the 'smoothness level'.
For details see Haris et al. (2016).
}
\examples{
require(Matrix)

set.seed(1)

# Generate the points x.
n <- 100
p <- 30

x <- matrix(rnorm(n*p), ncol = p)

# A simple model with 3 non-zero functions.
y <- rnorm(n, sd = 0.1) + sin(x[, 1]) + x[, 2] + (x[, 3])^3

mod <- AdditiveHierBasis(x, y, nbasis = 50, max.lambda = 30,
                         beta.mat = NULL,
                         nlam = 50, alpha = 0.5,
                         lam.min.ratio = 1e-4, m.const = 3,
                         max.iter = 300, tol = 1e-4)

# Obtain predictions for new.x.
preds <- predict(mod, new.x = matrix(rnorm(n*p), ncol = p))

# Plot the individual functions.
xs <- seq(-3,3,length = 300)
plot(mod,1,30, type  ="l",col = "red", lwd = 2, xlab = "x", ylab = "f_1(x)",
  main = "Estimating the Sine function")
lines(xs, sin(xs), type = "l", lwd = 2)
legend("topleft", c("Estimated Function", "True Function"),
      col = c("red", "black"), lwd = 2, lty = 1)

plot(mod,2,30, type  ="l",col = "red", lwd = 2, xlab = "x", ylab = "f_2(x)",
  main = "Estimating the Linear function")
lines(xs, xs, type = "l", lwd = 2)
legend("topleft", c("Estimated Function", "True Function"),
      col = c("red", "black"), lwd = 2, lty = 1)

plot(mod,3,30, type  ="l",col = "red", lwd = 2, xlab = "x", ylab = "f_3(x)",
     main = "Estimating the cubic polynomial")
lines(xs, xs^3, type = "l", lwd = 2)
legend("topleft", c("Estimated Function", "True Function"),
       col = c("red", "black"), lwd = 2, lty = 1)
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
\code{\link{predict.addHierBasis}}, \code{\link{plot.addHierBasis}}
}


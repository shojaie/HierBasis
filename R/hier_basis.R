
#' Nonparametric regression using hierarchical basis functions
#'
#' One of the main functions of the \code{HierBasis} package. This function
#' fit a univariate nonparametric regression model. This is achieved by
#' minimizing the following function of \eqn{\beta}:
#' \deqn{minimize_{\beta} (1/2n)||y - \Psi \beta||^2 + \lambda\Omega_k(\beta) ,}
#' where \eqn{\beta} is a vector of length \eqn{J = } \code{nbasis}.
#' The penalty function \eqn{\Omega} is given by \deqn{\sum a_{j,k}\beta[j:J],}
#' where \eqn{\beta[j:J]} is \code{beta[j:J]} for a vector \code{beta}.
#' Finally, the weights \eqn{a_{j,k}} are given by
#' \deqn{a_{j,k} = j^k - (j-1)^k,} where \eqn{k} denotes the smoothness level.
#' For details see Haris et al. (2015).
#' @param x A vector of dependent variables.
#' @param y A vector of response values we wish to fit the function to.
#' @param nbasis The number of basis functions. Default is length(y).
#' @param max.lambda The maximum lambda value for the penalized regression
#' problem. If \code{NULL} (default), then the function selects a maximum
#' lambda value such that the fitted function is the trivial estimate, i.e.
#' the mean of \code{y}.
#' @param nlam Number of lambda values for fitting penalized regression.
#' The functions uses a sequence of \code{nlam} lambda values on the log-scale
#' rangeing from \code{max.lambda} to \code{max.lambda * lam.min.ratio}.
#' @param lam.min.ratio The ratio of the largest and smallest lambda value.
#' @param k The order of smoothness, usually not more than 3 (default).
#'
#' @return   An object of class hier.basis with the following elements:
#'
#' \item{beta.hat}{The \code{nbasis * nlam} matrix of estimated beta vectors.}
#' \item{fitted.values}{The \code{nbasis * nlam} matrix of fitted values.}
#' \item{lambdas}{The sequence of lambda values used for
#' fitting the different models.}
#' \item{x, y}{The original \code{x} and \code{y} values used for estimation.}
#' \item{k}{The k value used for defining 'order' of smoothness.}
#' \item{x.mat}{The deisgn matrix used in the main optimization probelm. This is
#' obtained by centering and then orthogonolizeing the simple matrix of
#' \code{cbind(x, x^2, x^3, ..., x^nbasis)}.}
#' \item{nbasis}{The maximum number of basis functions we
#' allowed the method to fit.}
#' \item{active}{The vector of length nlam. Giving the size of the active set.
#' Since we are now centering there is no intercept term.}
#' \item{xbar}{The means of the vectors \code{x, x^2, x^3, ..., x^nbasis}.}
#' \item{ybar}{The mean of the vector y.}
#' \item{qr.obj}{The qr object. For internal use ONLY! This is only passed for
#' computations in the coef.HierBasis function.}
#'
#' @export
#'
#' @examples
#' x <- 1
#' y <- 2
#' x + y
HierBasis <- function(x, y, nbasis = length(y), max.lambda = NULL,
                     nlam = 50, lam.min.ratio = 1e-4, k = 3) {
  # We first evaluate the sample size.
  n <- length(y)

  # Create simple matrix of polynomial basis.
  design.mat <- lapply(1:(nbasis), function(i) {x^i})
  design.mat <- do.call(cbind, design.mat)


  xbar <- apply(design.mat, 2, mean)
  design.mat.centered <- scale(design.mat, scale = FALSE)

  ybar <- mean(y)
  y.centered <- y - ybar

  qr.obj <- qr(design.mat.centered)
  x.mat <- qr.Q(qr.obj) * sqrt(n)
  # Note that for a orthogonal design the two problems are equivalent:
  # (1/2n)*|Y - X %*% beta|^2 + lambda * Pen(beta),
  # (1/2)*|t(X) %*% Y/n - beta|^2 + (lambda) * Pen(beta).

  # Thus all we need, is to solve the proximal problem.
  # Define v = t(X) %*% Y/n for the prox problem.
  v <- crossprod(x.mat, y.centered/n)

  # Now we note that our penalty is given by
  # sum_{k = 1}^{K} a_k * || beta[k:K] ||,
  # where K = nbasis.
  # We now evaluate the weights a_k:
  ak <- (1:nbasis)^k - (0:(nbasis - 1))^k

  # If a maximum value for lambda is not provided we then evaluate a
  # maximum lambda value based on a non-tight bound.
  if(is.null(max.lambda)) {
    max.lambda <- max(abs(v) / ak)
  }

  # Generate sequence of lambda values.
  lambdas <- 10^seq(log10(max.lambda),
         log10(max.lambda * lam.min.ratio),
         length = nlam)

  # Now we find the estimates parameter vector beta for each lambda.
  beta.hat <- sapply(lambdas, FUN = function(lam) {
    GetProx(v, lam * ak)
  })

  # Get size of active set.
  active.set <- apply(beta.hat, 2, function(x) {
    length(which(x != 0))
  })

  # We also evaluate the predicted values.
  y.hat <- sapply(1:nlam, FUN  = function(i) {
    fit <- x.mat %*% beta.hat[, i] + ybar
    fit
  })

  # Return the object for
  result <- list()
  result$beta <- beta.hat
  result$fitted.values <- y.hat
  result$y <- y
  result$x <- x
  result$lambdas <- lambdas
  result$k <- k
  result$x.mat <- x.mat
  result$nbasis <- nbasis
  result$active <- active.set
  result$xbar <- xbar
  result$ybar <- ybar
  result$qr.obj <- qr.obj
  class(result) <- "HierBasis"

  return(result)
}


# The S3 method for extracting the coefficients of the fitted model.
# The idea here is that this should return the coefficients on the original
# scale. This function uses the 'backsolve' function for solving the
# upper.triangular system.
#
# Args:
#   object: An object of class HierBasis.
#   ...: Additional arguments to be passed to the function.
# Returns:
#   beta: An nbasis * nlam matrix of coefficients of the fitted model.
#   intercept: A vector of length nlam, for the intercept term of each fitted model.
coef.HierBasis <- function(object, ...) {
  # Recall that on the original scale we have an X matrix.
  # We then center to get X_c and then we find X_c = Q * R.
  # Thus the estimated beta from the main fit is given by
  # beta.hat = R * beta.hat.original.
  #
  # Hence all we need is to solve for x, R * x = beta.hat.
  # And then 'uncenter' to find the intercept terms.

  # First we find the R matrix in the qr Decomposition.
  R.mat <- qr.R(object$qr.obj) / sqrt(length(object$y))

  # Now we solve the linear system for each fitted beta.hat.
  beta <- apply(object$beta, 2, function(x) {
    backsolve(R.mat, x)
  })

  # Now we simply find the intercepts for each fitted model.
  intercept <- apply(beta, 2, function(vec) {
    object$ybar - sum(object$xbar * vec)
  })

  # Return list of objects.
  return(list("beta" = beta,
         "intercept" = intercept))
}


# This function evaluates the Degrees of Freedom for the different fitted
# models which are described by the object hier.basis.
GetDoF.HierBasis <- function(hier.basis, lam.index = NULL) {
  # Obtain the sample size.
  n <- length(hier.basis$y)

  x.mat <- hier.basis$x.mat

  # Get weights ak.
  k <- hier.basis$k
  nbasis <- hier.basis$nbasis
  ak <- (1:nbasis)^k - (0:(nbasis - 1))^k

  # Get the sequence of lambda values.
  lambdas <- hier.basis$lambdas

  # Define a temporary function we'll use:
  temp.fun <- function(i) {
    beta <- hier.basis$beta[, i]

    if(all(beta == 0)) {
      return(0)
    }
    #print(i)

    # We first obtain K'.
    K.prime <- max(which(beta != 0))
    beta.k <- beta[1:K.prime]

    # Now the weights.
    weights <- (lambdas[i]) * ak
    weights <- weights[1:K.prime]

    # New calculations using another method.
    beta.mat <- tcrossprod(beta.k)

    # Identity mat I'll use later.
    iden <- diag(rep(1, K.prime))


    # Get norms for each of the cases.
    norms <- rev(sqrt((cumsum(rev(beta.k^2)))))

    # THe weight which we multiple with the identity matrix.
    w1 <- weights/norms
    w2 <- weights/(norms^3)

    # Begin inner matrices
    # inner.mat <- diag(1, K.prime)
    inner.mat <- sapply(1:K.prime, function(j) {
      ans <- w1[j] * iden - w2[j] * beta.mat
      if(j != 1) {
        ans[1:(j-1), ] <- 0
        ans[, 1:(j-1)] <- 0
      }
      ans
    })


    if(length(inner.mat) == 1) {
      res <- x.mat[, 1:K.prime] %*% solve(n + inner.mat) %*% t(x.mat[, 1:K.prime])
      #res <- res %*% t(x.mat[, 1:K.prime])
    } else {
      res <- x.mat[, 1:K.prime] %*% solve(n*diag(rep(1, K.prime)) +
                                            matrix(apply(inner.mat, 1, sum),
                                                   ncol = K.prime, nrow = K.prime))
      res <- res %*% t(x.mat[, 1:K.prime])
    }

    sum(diag(res))
  }

  if(!is.null(lam.index)) {
    temp.fun(lam.index)
  } else {
    sapply(1:length(hier.basis$lambdas), FUN = temp.fun)
  }


}

# This function gives predictions for the curve at the points
# defined in new.x via linear interpolation.
#
# Args:
#   object: An object of class HierBasis
#   new.x: A vector of x values we wish to fit the data at. This should be
#          within the range of the training data.
#   interpolate: A logical indicator of if we wish to use linear interpolation
#                for estimation of fitted values. This becomes useful for high dof
#                when the estimation of betas on the original scale becomes unstable.
# Returns:
#   matrix: With length(new.x) rows and no. of cols is equal to number of lambda
#           values used.
predict.HierBasis <- function(object, new.x = NULL, interpolate = FALSE, ...) {
  train.x <- object$x  # x-values used for fitting the model.
  yhat <- object$fitted.values  # Fitted values which define the curve.
  nlam <- length(object$lambdas)  # Number of lambdas.

  if(!interpolate) {
    # Obtain the coefficients on the original scale.
    coef.obj <- coef.HierBasis(object, ...)

    # Obtain the design matrix.
    newx.mat <- sapply(1:object$nbasis, function(i) {
      new.x^i
    })

    # This is the X %*% beta without the intercept part.
    fitted <- newx.mat %*% coef.obj$beta

    # Now we add the intercept.
    t(apply(fitted, 1, "+", coef.obj$intercept))
  } else {

    # Return predicted values.
    sapply(1:nlam, FUN = function(i) {
      # Obtain curve for a particular value.
      yhat.temp <- yhat[, i]

      # Return predictions.
      approx(x = train.x, y = yhat.temp, xout = new.x)$y
    })

  }


}



# A different simulation function. Here we wish to plot the
# the MSE as a function of degrees of freedom.
#
# Args:
#   dat: A data set from the function GenerateData.
#   ...: Other arguments to be passed onto the function HierBasis.
#
# Returns:
#   mse: The optimal MSE value on the validation set.
#   dof: The corresponding Dof estimated by the unbiased estimator.

SimHierBasis <- function(dat, ...) {

  # Fit object.
  hier.basis <- HierBasis(dat$x, dat$y,  ...)

  # Get fitted values on test set.
  fits.test <- predict.HierBasis(hier.basis, new.x = dat$x.test)
  # Obtain the MSE and dof.
  mse <- GetMSE(dat$y.test, fits.test)

  # Obtain the best index value.
  ind <- which.min(mse)[1]
  mse.val <- mean((dat$y.val - fits.test[, ind])^2)
  mse.true <- mean((dat$f0 - hier.basis$fitted.values[, ind])^2)
  dof <- GetDoF.HierBasis(hier.basis, lam.index = ind)

  return(list("mse.val" = mse.val,
              "mse.true" = mse.true,
              "dof" = dof))
}



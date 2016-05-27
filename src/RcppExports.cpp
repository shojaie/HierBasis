// This file was generated by Rcpp::compileAttributes
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppArmadillo.h>
#include <Rcpp.h>

using namespace Rcpp;

// FitAdditive
List FitAdditive(arma::vec y, arma::mat weights, arma::vec ak, NumericVector x, arma::mat beta, double max_lambda, double lam_min_ratio, double alpha, double tol, int p, int J, int n, int nlam, double max_iter, bool beta_is_zero, arma::vec active_set);
RcppExport SEXP HierBasis_FitAdditive(SEXP ySEXP, SEXP weightsSEXP, SEXP akSEXP, SEXP xSEXP, SEXP betaSEXP, SEXP max_lambdaSEXP, SEXP lam_min_ratioSEXP, SEXP alphaSEXP, SEXP tolSEXP, SEXP pSEXP, SEXP JSEXP, SEXP nSEXP, SEXP nlamSEXP, SEXP max_iterSEXP, SEXP beta_is_zeroSEXP, SEXP active_setSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< arma::vec >::type y(ySEXP);
    Rcpp::traits::input_parameter< arma::mat >::type weights(weightsSEXP);
    Rcpp::traits::input_parameter< arma::vec >::type ak(akSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type x(xSEXP);
    Rcpp::traits::input_parameter< arma::mat >::type beta(betaSEXP);
    Rcpp::traits::input_parameter< double >::type max_lambda(max_lambdaSEXP);
    Rcpp::traits::input_parameter< double >::type lam_min_ratio(lam_min_ratioSEXP);
    Rcpp::traits::input_parameter< double >::type alpha(alphaSEXP);
    Rcpp::traits::input_parameter< double >::type tol(tolSEXP);
    Rcpp::traits::input_parameter< int >::type p(pSEXP);
    Rcpp::traits::input_parameter< int >::type J(JSEXP);
    Rcpp::traits::input_parameter< int >::type n(nSEXP);
    Rcpp::traits::input_parameter< int >::type nlam(nlamSEXP);
    Rcpp::traits::input_parameter< double >::type max_iter(max_iterSEXP);
    Rcpp::traits::input_parameter< bool >::type beta_is_zero(beta_is_zeroSEXP);
    Rcpp::traits::input_parameter< arma::vec >::type active_set(active_setSEXP);
    __result = Rcpp::wrap(FitAdditive(y, weights, ak, x, beta, max_lambda, lam_min_ratio, alpha, tol, p, J, n, nlam, max_iter, beta_is_zero, active_set));
    return __result;
END_RCPP
}
// GetProx
arma::sp_mat GetProx(arma::vec y, arma::mat weights);
RcppExport SEXP HierBasis_GetProx(SEXP ySEXP, SEXP weightsSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< arma::vec >::type y(ySEXP);
    Rcpp::traits::input_parameter< arma::mat >::type weights(weightsSEXP);
    __result = Rcpp::wrap(GetProx(y, weights));
    return __result;
END_RCPP
}
// solveHierBasis
List solveHierBasis(arma::mat design_mat, arma::vec y, arma::vec ak, arma::mat weights, int n, double lam_min_ratio, int nlam, double max_lambda);
RcppExport SEXP HierBasis_solveHierBasis(SEXP design_matSEXP, SEXP ySEXP, SEXP akSEXP, SEXP weightsSEXP, SEXP nSEXP, SEXP lam_min_ratioSEXP, SEXP nlamSEXP, SEXP max_lambdaSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< arma::mat >::type design_mat(design_matSEXP);
    Rcpp::traits::input_parameter< arma::vec >::type y(ySEXP);
    Rcpp::traits::input_parameter< arma::vec >::type ak(akSEXP);
    Rcpp::traits::input_parameter< arma::mat >::type weights(weightsSEXP);
    Rcpp::traits::input_parameter< int >::type n(nSEXP);
    Rcpp::traits::input_parameter< double >::type lam_min_ratio(lam_min_ratioSEXP);
    Rcpp::traits::input_parameter< int >::type nlam(nlamSEXP);
    Rcpp::traits::input_parameter< double >::type max_lambda(max_lambdaSEXP);
    __result = Rcpp::wrap(solveHierBasis(design_mat, y, ak, weights, n, lam_min_ratio, nlam, max_lambda));
    return __result;
END_RCPP
}
// solveHierLogistic
List solveHierLogistic(arma::mat design_mat, arma::vec y, arma::vec ak, arma::mat weights, int n, int nlam, int J, double max_lambda, double lam_min_ratio, double tol, int max_iter);
RcppExport SEXP HierBasis_solveHierLogistic(SEXP design_matSEXP, SEXP ySEXP, SEXP akSEXP, SEXP weightsSEXP, SEXP nSEXP, SEXP nlamSEXP, SEXP JSEXP, SEXP max_lambdaSEXP, SEXP lam_min_ratioSEXP, SEXP tolSEXP, SEXP max_iterSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< arma::mat >::type design_mat(design_matSEXP);
    Rcpp::traits::input_parameter< arma::vec >::type y(ySEXP);
    Rcpp::traits::input_parameter< arma::vec >::type ak(akSEXP);
    Rcpp::traits::input_parameter< arma::mat >::type weights(weightsSEXP);
    Rcpp::traits::input_parameter< int >::type n(nSEXP);
    Rcpp::traits::input_parameter< int >::type nlam(nlamSEXP);
    Rcpp::traits::input_parameter< int >::type J(JSEXP);
    Rcpp::traits::input_parameter< double >::type max_lambda(max_lambdaSEXP);
    Rcpp::traits::input_parameter< double >::type lam_min_ratio(lam_min_ratioSEXP);
    Rcpp::traits::input_parameter< double >::type tol(tolSEXP);
    Rcpp::traits::input_parameter< int >::type max_iter(max_iterSEXP);
    __result = Rcpp::wrap(solveHierLogistic(design_mat, y, ak, weights, n, nlam, J, max_lambda, lam_min_ratio, tol, max_iter));
    return __result;
END_RCPP
}
// testf
List testf();
RcppExport SEXP HierBasis_testf() {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    __result = Rcpp::wrap(testf());
    return __result;
END_RCPP
}

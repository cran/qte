% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/qte.R
\name{computeSE}
\alias{computeSE}
\title{computeSE}
\usage{
computeSE(bootIters, qteobj, alp = 0.05)
}
\arguments{
\item{bootIters}{List of bootstrap iterations}

\item{alp}{The significance level used for constructing bootstrap
confidence intervals}
}
\value{
SEObj
}
\description{
Computes standard errors from bootstrap results.  This function
is called by several functions in the qte package
}
\keyword{internal}

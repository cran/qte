% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ddid2.R
\name{ddid2}
\alias{ddid2}
\title{ddid2}
\usage{
ddid2(
  formla,
  xformla = NULL,
  t,
  tmin1,
  tname,
  data,
  panel = TRUE,
  dropalwaystreated = TRUE,
  idname = NULL,
  probs = seq(0.05, 0.95, 0.05),
  iters = 100,
  alp = 0.05,
  method = "logit",
  se = TRUE,
  retEachIter = FALSE,
  seedvec = NULL,
  pl = FALSE,
  cores = NULL
)
}
\arguments{
\item{formla}{The formula y ~ d where y is the outcome and d is the
treatment indicator (d should be binary)}

\item{xformla}{A optional one sided formula for additional covariates that
will be adjusted for.  E.g ~ age + education.  Additional covariates can
also be passed by name using the x paramater.}

\item{t}{The 3rd time period in the sample (this is the name of the column)}

\item{tmin1}{The 2nd time period in the sample (this is the name of the
column)}

\item{tname}{The name of the column containing the time periods}

\item{data}{The name of the data.frame that contains the data}

\item{panel}{Boolean indicating whether the data is panel or repeated cross
sections}

\item{dropalwaystreated}{How to handle always treated observations
in panel data case (not currently used)}

\item{idname}{The individual (cross-sectional unit) id name}

\item{probs}{A vector of values between 0 and 1 to compute the QTET at}

\item{iters}{The number of iterations to compute bootstrap standard errors.
This is only used if se=TRUE}

\item{alp}{The significance level used for constructing bootstrap
confidence intervals}

\item{method}{The method for estimating the propensity score when covariates
are included}

\item{se}{Boolean whether or not to compute standard errors}

\item{retEachIter}{Boolean whether or not to return list of results
from each iteration of the bootstrap procedure}

\item{seedvec}{Optional value to set random seed; can possibly be used
in conjunction with bootstrapping standard errors.}

\item{pl}{boolean for whether or not to compute bootstrap error in parallel.
Note that computing standard errors in parallel is a new feature and may
not work at all on Windows.}

\item{cores}{the number of cores to use if bootstrap standard errors are
computed in parallel}
}
\value{
\code{QTE} object
}
\description{
\code{ddid2} computes the Quantile Treatment Effect
on the Treated (QTET) using the method of Callaway, Li, and Oka (2015).
}
\examples{
##load the data
data(lalonde)

## Run the ddid2 method on the observational data with no covariates
d1 <- ddid2(re ~ treat, t=1978, tmin1=1975, tname="year",
 data=lalonde.psid.panel, idname="id", se=FALSE,
 probs=seq(0.05, 0.95, 0.05))
summary(d1)

## Run the ddid2 method on the observational data with covariates
d2 <- ddid2(re ~ treat, t=1978, tmin1=1975, tname="year",
 data=lalonde.psid.panel, idname="id", se=FALSE,
 xformla=~age + I(age^2) + education + black + hispanic + married + nodegree,
 probs=seq(0.05, 0.95, 0.05))
summary(d2)


}
\references{
Callaway, Brantly, Tong Li, and Tatsushi Oka.  ``Quantile Treatment Effects
in Difference in Differences Models under Dependence Restrictions and with
Only Two Time Periods.'' Working Paper, 2015.
}

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bounds.R
\name{getlb}
\alias{getlb}
\title{getlb}
\usage{
getlb(s, F.change.treated, F.treated.tmin1, y)
}
\arguments{
\item{s}{A particular value of distribution for which to calculate the bound}

\item{F.change.treated}{ecdf object of distribution of change in outcomes
for the treated group}

\item{F.treated.tmin1}{ecdf object of distribution of outcomes in period
t-1 for the treated group}

\item{y}{a vector of values that observations could take in the previous
period ?}
}
\description{
Helper function to compute the lower bound in bounds method.
Usually called by vapply function.
}
\keyword{internal}

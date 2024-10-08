% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/allClasses.R, R/methods-TxpSliceList.R
\docType{class}
\name{TxpSliceList-class}
\alias{TxpSliceList-class}
\alias{TxpSliceList}
\alias{txpValueNames,TxpSliceList-method}
\alias{txpTransFuncs,TxpSliceList-method}
\alias{duplicated,TxpSliceList-method}
\alias{as.TxpSliceList}
\title{List of TxpSlice objects}
\usage{
TxpSliceList(...)

\S4method{txpValueNames}{TxpSliceList}(x, simplify = FALSE)

\S4method{txpTransFuncs}{TxpSliceList}(x, simplify = FALSE)

\S4method{duplicated}{TxpSliceList}(x)

as.TxpSliceList(x)
}
\arguments{
\item{...}{\link{TxpSlice} object to create \code{TxpSliceList} object; MUST give
unique names to each slice}

\item{x}{\code{TxpSliceList} object}

\item{simplify}{Scalar logical, when \code{TRUE} the returned \code{list} is simplified
to a \code{vector}/\link{TxpTransFuncList} object}
}
\description{
Extension of \link[S4Vectors:SimpleList-class]{S4Vectors::SimpleList} that requires
uniquely-named elements and holds only \link{TxpSlice} objects.
}
\details{
Note, there is no coercion for \link{TxpSlice} to \code{TxpSliceList} because unique
names are required.
}
\section{Functions}{
\itemize{
\item \code{txpValueNames(TxpSliceList)}: Return \code{list} of \code{txpValueNames} slots for the
contained \link{TxpSlice} objects, or \code{vector} when \code{simplify = TRUE}

\item \code{txpTransFuncs(TxpSliceList)}: Return \code{list} of \code{txpTransFuncs} slots for the
contained \link{TxpSlice} objects, or \link{TxpTransFuncList} when \code{simplify = TRUE}

\item \code{duplicated(TxpSliceList)}: Returns logical vector of \code{length(x)}, where
\code{TRUE} indicates a duplicate slice in the list; see \link[base:duplicated]{base::duplicated}

}}
\examples{
## Create TxpSlice objects
s1 <- TxpSlice("input1", list(linear = function(x) x))
s2 <- TxpSlice(c("input2", "input3"), 
               list(log = function(x) log(x), sqrt = function(x) sqrt(x)))

## Create TxpSliceList
sl <- TxpSliceList(s1 = s1, s2 = s2)

## Accessors
txpValueNames(sl)
txpValueNames(sl, simplify = TRUE)

txpTransFuncs(sl)
txpTransFuncs(sl, simplify = TRUE)

## Coercion
as(list(s1 = TxpSlice("hello"), s2 = TxpSlice("user")), "TxpSliceList")
as.TxpSliceList(c(s1 = TxpSlice("hello"), s2 = TxpSlice("user")))

## Concatenation
c(sl, TxpSliceList(s3 = TxpSlice("input4")))

## Reduce TxpSliceList to single slice
Reduce(merge, sl)
}

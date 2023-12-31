% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download_file.R
\name{download_file}
\alias{download_file}
\title{Download a file}
\usage{
download_file(url, destfile = NA, mode = "wb", method = "auto", ...)
}
\arguments{
\item{url}{a character string naming the URL of a resource to be downloaded.}

\item{destfile}{a character string with the name where the downloaded file is saved.}

\item{mode}{Method to be used for downloading files. See \href{https://www.rdocumentation.org/packages/utils/versions/3.6.2/topics/download.file}{utils::download.file}}

\item{method}{Method to be used for downloading files. See \href{https://www.rdocumentation.org/packages/utils/versions/3.6.2/topics/download.file}{utils::download.file}}

\item{...}{Arguments to be passed to utils::download.file(...)}
}
\value{
character. Path of downloaded file (\code{destfile})
}
\description{
This is a wrapper for \href{https://www.rdocumentation.org/packages/utils/versions/3.6.2/topics/download.file}{utils::download.file}
that has sensible default parameters that make it easier to use in the context of this package.
}

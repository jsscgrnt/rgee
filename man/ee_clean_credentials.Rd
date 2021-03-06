% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ee_clean.R
\name{ee_clean_credentials}
\alias{ee_clean_credentials}
\title{Delete Credentials}
\usage{
ee_clean_credentials(email = "not_defined", quiet = FALSE)
}
\arguments{
\item{email}{Character. Earth Engine user (e.g. \code{data.colec.fbf}).}

\item{quiet}{Logical. Suppress info messages.}
}
\description{
Delete all the credentials according to a specific user. The credentials
(Google Earth Engine, Google Drive and Google Cloud Storage) are created
after running successfully \code{ee_Initialize(...)}. They are saved in
the path \code{rgee::ee_get_earthengine_path()}.
}
\examples{
\dontrun{
library(rgee)

ee_clean_credentials()
ee_clean_credentials('data.colec.fbf@gmail.com')

}
}
\seealso{
Other ee_clean functions: 
\code{\link{ee_clean_container}()},
\code{\link{ee_clean_pyenv}()}
}
\concept{ee_clean functions}

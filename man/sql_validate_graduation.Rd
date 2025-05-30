% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/validations.R
\name{sql_validate_graduation}
\alias{sql_validate_graduation}
\title{\code{sql_validate_graduation} will generate the standard sql query for pulling Graduation Validations from Edify.
Validations are done through Edify.
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}}
\usage{
sql_validate_graduation(data_source, name, context)
}
\arguments{
\item{data_source}{The server you will be full from. Currently, Edify.}

\item{name}{The name you want the SQL file to have in your sql folder. This is a string and must be provided in quotes
(e.g., "your_filename.sql").}

\item{context}{The context of your project.  "project", "shiny", and "sandbox". The default is "project".}
}
\value{
A sql file in your SQL folder
}
\description{
\code{sql_validate_graduation} will generate the standard sql query for pulling Graduation Validations from Edify.
Validations are done through Edify.
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}
}

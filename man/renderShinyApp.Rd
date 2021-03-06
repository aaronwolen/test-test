% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/renderShinyApp.R
\name{renderShinyApp}
\alias{renderShinyApp}
\title{Render Shiny Application in a Jupyter Notebook}
\usage{
renderShinyApp(
  ui = NULL,
  server = NULL,
  appFile = NULL,
  appDir = NULL,
  port = 3000
)
}
\arguments{
\item{ui}{The UI definition of the app.}

\item{server}{A function with three parameters: \code{input}, \code{output}, and
\code{session}. The function is called once for each session ensuring that each
app is independent.}

\item{appFile}{Path to a .R file containing a Shiny application}

\item{appDir}{Path to directory that contains a Shiny app (i.e. a server.R
file and either ui.R or www/index.html)}

\item{port}{The TCP port that the application should listen on (defaults to 3000).}
}
\description{
Render Shiny Application in a Jupyter Notebook
}

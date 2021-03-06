#' Render Shiny Application in a Jupyter Notebook
#'
#' @param ui The UI definition of the app.
#' @param port The TCP port that the application should listen on (defaults to 3000).
#' @inheritParams shiny::shinyApp
#' @importFrom IRdisplay display_html
#' @import shiny
#' @importFrom callr r_bg
#' @importFrom pingr is_up
#' @export

renderShinyApp <- function(
  ui = NULL,
  server = NULL,
  appFile = NULL,
  appDir = NULL,
  port = 3000
) {
  if (!is.null(ui) || !is.null(server)) {
    app <- shiny::shinyApp(ui, server)
  } else if (!is.null(appFile)) {
    app <- shiny::shinyAppFile(appFile)
  } else if (!is.null(appDir)) {
    app <- shiny::shinyAppDir(appDir)
  } else {
    stop(
      "You must define either 'ui'/'server', 'appFile', or 'appDir'",
      call. = FALSE
    )
  }

  run_app <- function(appDir, host, port) {
    shiny::runApp(appDir, host = host, port = port)
  }
  args <- list(appDir = app, host = "0.0.0.0", port = port)

  rproc <- callr::r_bg(
    func = run_app,
    args = args,
    supervise = TRUE
  )

  while(!pingr::is_up(destination = args$host, port = args$port)) {
    if (!rproc$is_alive()) stop(rproc$read_all_error())
    Sys.sleep(0.05)
  }
  host <- getShinyHost(port = args$port)
  displayIframe(host)
}


getShinyHost <- function(port) {
  jupyterUser <- Sys.getenv("JUPYTERHUB_USER")
  jupyterApiURL <- Sys.getenv("JUPYTERHUB_API_URL", unset=NA)
  # If jupyter is running inside k8s-hub create a url to use jupyter-server-proxy
  if (jupyterUser != "" && !is.na(jupyterApiURL)) {
    host <- sprintf("/user/%s/proxy/%s/", jupyterUser, port)
    return(host)
  }
  host <- sprintf('http://127.0.0.1:%s', port)
  return(host)
}


displayIframe <- function(host) {
  html <- sprintf('<iframe src="%s" width="100%%" style="border: 0;height: calc(100vh - 70px);margin: 0;"></iframe>', host)
  display_html(html)
}



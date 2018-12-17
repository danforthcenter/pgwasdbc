#' Disconnection
#'
#' This is an example function that connects to
#' a local Docker instance of the GWAS database.
#'
#' @param conn Connection object

disconnect <- function(conn) {
  RPostgres::dbDisconnect(conn)
}

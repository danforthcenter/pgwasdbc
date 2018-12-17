#' List available traits
#' @description List all the known unique traits for all datasets
#' @param conn Connection Object
#' @return List
#'


listAllKnownTraits <- function(conn) {
  sql = "SELECT DISTINCT t.trait_name FROM trait t;"


  return(RPostgres::dbGetQuery(conn, sql))
}

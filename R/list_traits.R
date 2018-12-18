#' List available traits
#' @description List all the known unique traits for all datasets
#' @return List
#' @export list_traits
 list_traits <- function() {
  results <- tryCatch(
    {
      conn <- connect()
      results <- RPostgres::dbGetQuery(conn = conn, statement = "SELECT DISTINCT t.trait_name FROM trait t;")
      return(results)
    },
    error=function(cond) {
      message(cond)
      return(NA)
    },
    warning=function(cond) {
      message(cond)
      return(NULL)
    },
    finally={
      RPostgres::dbDisconnect(conn)
    }
  )
}

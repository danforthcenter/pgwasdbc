#' List available traits
#' @description List all the known unique traits for all datasets
#' @return List
 list_traits <- function() {
  results <- tryCatch(
    {
      conn <- gwasdbconnector::connect()
      results <- RPostgres::dbGetQuery(conn,stmt = "SELECT DISTINCT t.trait_name FROM trait t;")
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
      # Step 4: Clear results
      if (exists("res"))
        RPostgres::dbClearResult(res = res)
      # Step 5: Close up connection to database
      RPostgres::dbDisconnect(conn)
    }
  )
}

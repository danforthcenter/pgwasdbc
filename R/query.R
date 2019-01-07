#' Query
#'
#' This is a function intended to processing custom queries to the GWAS database.
#'
#' @param stmt Custom query string
#' @return Dataframe results of query as dataframe
#' @export query
query <- function(stmt) {
  results <- tryCatch(
    {
      if (is.null(stmt))
        stop("SQL query is undefined.")

      conn <- connect()
      results <- RPostgres::dbGetQuery(conn, statement = stmt)
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

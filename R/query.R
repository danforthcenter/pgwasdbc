#' Query
#'
#' This is a function intended to processing custom queries to the GWAS database.
#'
#' @param conn Connection object to database
#' @param sql Custom query string
#' @return Dataframe results of query as dataframe


query <- function(conn, sql) {
  return(RPostgres::dbGetQuery(conn, sql))
}

#' # # List all chromosomes
# results <- dbGetQuery(conn, "SELECT * FROM chromosome;")
# print(results)
#
# # Show the existing databases
# dbGetQuery(conn, "SELECT datname FROM pg_database WHERE datistemplate = FALSE")
#
# # Show all tables within the baxdb database
# dbGetQuery(conn, "SELECT table_name FROM information_schema.tables
#                    WHERE table_schema='public'")
#
# listChromosomes <- function() {
#   conn <- connect()
#   RPostgreSQL::dbGetQuery(conn, "SELECT * FROM chromosome;")
# }

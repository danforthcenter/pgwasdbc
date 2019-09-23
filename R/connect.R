#' Connection
#'
#' @description This is an example function that connects to a local Docker instance of the GWAS database.
#' @param drv DBI driver
#' @param dbname String name of the database (default: gwasdb)
#' @param host Host of database (default: localhost)
#' @param port Number (default: 5434)
#' @param user String (default: postgres)
#' @param password String (default: password)
#' @return A connection object
connect <- function(drv = RPostgres::Postgres(),
                    dbname = "pgwasdb_3011261_prod",
                    host = "10.5.1.102",
                    port = 5432,
                    user = "pgwasdb_prod_owner",
                    password = "password"
                    ) {
  conn <- RPostgres::dbConnect(drv = drv, dbname = dbname, host = host, port = port, user = user, password = password)
  return(conn)
}


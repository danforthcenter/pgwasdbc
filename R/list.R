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

#' List available species
#' @description List all the known unique species for all datasets
#' @return List
#' @export list_species
list_species <- function() {
  results <- tryCatch(
    {
      conn <- connect()
      results <- RPostgres::dbGetQuery(conn = conn, statement = "SELECT DISTINCT s.binomial, s.shortname FROM species s;")
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

#' List available growouts
#' @description List all the known unique growouts for all datasets
#' @return List
#' @export list_growouts
list_growouts <- function() {
  results <- tryCatch(
    {
      conn <- connect()
      results <- RPostgres::dbGetQuery(conn = conn, statement = "SELECT DISTINCT go.growout_name, l.code FROM growout go LEFT JOIN location l ON go.growout_location = l.location_id")
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



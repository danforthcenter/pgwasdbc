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

#' List the trait names for a given species
#' @description Given a species (binomial name), return the known traits
#' The species string must be an exact match.
#' @param species String binomial name of the species of interest
#' @return Dataframe results of query
#' @export list_traits_for_species
list_traits_for_species <- function(species) {
  # Input validation
  results <- tryCatch(
    {
      if (is.null(species))
        stop("Species is undefined.")
      conn <- connect()
      # For prepared statements, we cannot use dbGetQuery because
      # the action must be performed separatedly

      # Step 1: Statement w/ placeholders
      stmt <- " SELECT
                DISTINCT(t.trait_name)
                FROM
                  trait t
                INNER JOIN phenotype ph ON
                  ph.phenotype_trait = t.trait_id
                INNER JOIN \"line\" l ON
                  ph.phenotype_line = l.line_id
                INNER JOIN population p ON
                  l.line_population = p.population_id
                INNER JOIN species s ON
                  p.population_species = s.species_id
                WHERE s.binomial ILIKE $1
                ORDER BY t.trait_name
              "
      # Step 2: Send query
      res <- RPostgres::dbSendQuery(conn = conn, statement = stmt)
      # Step 3: Bind parameters
      species <- paste0("%", species, "%")
      params <- list(species)
      RPostgres::dbBind(res = res, params = params)
      # Step 4: Fetch results
      results <- RPostgres::dbFetch(res)
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
      # Step 5: Clear results
      if (exists("res"))
        RPostgres::dbClearResult(res = res)
      # Step 6: Close up connection to database
      # RPostgres::dbDisconnect(conn)
    }
  )
}


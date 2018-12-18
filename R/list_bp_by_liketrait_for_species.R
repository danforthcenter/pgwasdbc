#' List available traits
#' @param trait String name of the trait of interest
#' @param species String name of the species of interest
#' @return Dataframe results of query
list_bp_by_liketrait_for_species <- function(trait, species) {
  # Input validation
  results <- tryCatch(
    {
      if (is.null(trait))
        stop("Trait is undefined.")
      if (is.null(species))
        stop("Species is undefined.")
      conn <- gwasdbconnector::connect()
      # For prepared statements, we cannot use dbGetQuery because
      # the action must be performed separatedly

      # Step 1: Statement w/ placeholders
      stmt <- " SELECT
                	s.binomial AS organism,
                	c.chromosome_name AS chromosome,
                	gres.basepair AS basepair,
                	t.trait_name AS trait
                FROM
                	trait t
                INNER JOIN gwas_run grun on
                	grun.gwas_run_trait = t.trait_id
                INNER JOIN gwas_result gres on
                	gres.gwas_result_gwas_run = grun.gwas_run_id
                LEFT JOIN chromosome c on
                	c.chromosome_id = gres.gwas_result_chromosome
                LEFT JOIN species s on
                	s.species_id = c.chromosome_species
                WHERE t.trait_name ilike $1
                AND s.binomial = $2
              "

      # Step 2: Send query
      res <- RPostgres::dbSendQuery(conn = conn, statement = stmt)
      # Step 3: Prepend and append wildcard characters and bind parameters
      trait <- paste0("%", trait, "%")
      params <- list(trait, species)
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
      RPostgres::dbDisconnect(conn)
    }
  )
}

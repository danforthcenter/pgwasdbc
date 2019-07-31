#' List the chromosome and SNP position for a given trait and species
#' @description Given a trait and species, return the chromosome and SNP position
#' @param trait String name of the trait of interest. This will match any trait that contains this value.
#' @param species String name of the species of interest
#' @param cutoff Numeric (float) maximum value for model added p-value. The results will have a p-value less than or equal to the cutoff value specified.
#' @return Dataframe results of query
#' @export list_bp_by_liketrait_for_species
list_bp_by_liketrait_for_species <- function(trait, species, cutoff = 0.05) {
  # Input validation
  results <- tryCatch(
    {
      if (is.null(trait))
        stop("Trait is undefined.")
      if (is.null(species))
        stop("Species is undefined.")
      if (!is.null(cutoff) & !is.na(cutoff) & !is.numeric(cutoff))
        stop("Cutoff value provided is invalid. Please enter a decimal number between 0.0 and 1.0")
      conn <- connect()
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
                AND gres.cofactor = 1
              "
      # When a cutoff p-value is provided, add the condition to the SQL statement
      if (!is.null(cutoff)) {
        stmt <- paste0(stmt, "\nAND gres.model_added_pval <= $3")
      }
      # Step 2: Send query
      res <- RPostgres::dbSendQuery(conn = conn, statement = stmt)
      # Step 3: Prepend and append wildcard characters and bind parameters
      trait <- paste0("%", trait, "%")
      params <- list(trait, species)
      # When a cutoff p-value is provided, add the cutoff value to the parameter list
      if (!is.null(cutoff)) {
        params <- c(params, cutoff)
      }
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

#' List the chromosome and SNP position for a given trait and species
#' @description Given a trait and species, return the chromosome and SNP position.
#' The trait string must be an exact match.
#' @seealso \code{\link{list_bp_by_liketrait_for_species}}
#' @param trait String name of the trait of interest. This is an exact match.
#' @param species String name of the species of interest
#' @param cutoff Numeric (float) maximum value for model added p-value. The results will have a p-value less than or equal to the cutoff value specified.
#' @return Dataframe results of query
#' @export list_bp_by_trait_for_species
list_bp_by_trait_for_species <- function(trait, species, cutoff = 0.05) {
  # Input validation
  results <- tryCatch(
    {
      if (is.null(trait))
        stop("Trait is undefined.")
      if (is.null(species))
        stop("Species is undefined.")
      if (!is.null(cutoff) & !is.na(cutoff) & !is.numeric(cutoff))
        stop("Cutoff value provided is invalid. Please enter a decimal number between 0.0 and 1.0")
      conn <- connect()
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
      WHERE t.trait_name = $1
      AND s.binomial = $2
      AND gres.cofactor = 1
      "
      # When a cutoff p-value is provided, add the condition to the SQL statement
      if (!is.null(cutoff)) {
        stmt <- paste0(stmt, "\nAND gres.model_added_pval <= $3")
      }
      # Step 2: Send query
      res <- RPostgres::dbSendQuery(conn = conn, statement = stmt)
      # Step 3: Bind parameters
      params <- list(trait, species)
      # When a cutoff p-value is provided, add the cutoff value to the parameter list
      if (!is.null(cutoff)) {
        params <- c(params, cutoff)
      }
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


#' List the chromosome and SNP position for a given a species for all its traits
#' @description Given a species, return the chromosome and SNP position for all of its traits.
#' @seealso \code{\link{list_bp_for_species}}
#' @param species String name of the species of interest
#' @param cutoff Numeric (float) maximum value for model added p-value. The results will have a p-value less than or equal to the cutoff value specified.
#' @return Dataframe results of query
#' @export list_bp_by_trait_for_species
list_bp_for_species <- function(species, cutoff = 0.05, model='MaxCof') {
  # Input validation
  results <- tryCatch(
    {
      if (is.null(species))
        stop("Species is undefined.")
      if (!is.null(cutoff) & !is.na(cutoff) & !is.numeric(cutoff))
        stop("Cutoff value provided is invalid. Please enter a decimal number between 0.0 and 1.0")
      conn <- connect()
      # For prepared statements, we cannot use dbGetQuery because
      # the action must be performed separatedly

      # Step 1: Statement w/ placeholders
      stmt <- "select
              	s.binomial as organism,
              	c.chromosome_name as chromosome,
              	gres.basepair as basepair,
              	t.trait_name as trait
              from
              	species s
              inner join chromosome c on
              	c.chromosome_species = s.species_id
              inner join gwas_result gres on
              	gres.gwas_result_chromosome = c.chromosome_id
              inner join gwas_run grun on
              	grun.gwas_run_id = gres.gwas_result_gwas_run
              inner join trait t on
              	t.trait_id = grun.gwas_run_trait
              where
              	gres.model = $3
              	and s.binomial = $1
              	and gres.cofactor = 1
                and gres.model_added_pval <= $2"
      # Step 2: Send query
      res <- RPostgres::dbSendQuery(conn = conn, statement = stmt)
      # Step 3: Bind parameters
      params <- list(species)
      # When a cutoff p-value is provided, add the cutoff value to the parameter list
      if (!is.null(cutoff)) {
        params <- c(params, cutoff)
      }
      # When a modle is provided, add the model value to the parameter list
      if (!is.null(model)) {
        params <- c(params, model)
      }
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


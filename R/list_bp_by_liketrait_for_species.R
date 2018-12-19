#' List the chromosome and SNP position for a given trait and species
#' @description Given a trait and species, return the chromosome and SNP position
#' @param trait String name of the trait of interest. This will match any trait that contains this value.
#' @param species String name of the species of interest
#' @param cutoff Numeric (float) maximum value for model added p-value. The results will have a p-value less than or equal to the cutoff value specified.
#' @return Dataframe results of query
#' @export list_bp_by_liketrait_for_species
list_bp_by_liketrait_for_species <- function(trait, species, cutoff) {
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
list_bp_by_trait_for_species <- function(trait, species, cutoff) {
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


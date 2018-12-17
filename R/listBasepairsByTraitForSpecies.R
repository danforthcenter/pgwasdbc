#' List available traits
#' @param conn Connection object to database
#' @param params Tuple containing species and trait to search by
#' @return Dataframe results of query
#'


listBasepairsByTraitForSpecies <- function(conn, params = list("Zea Maize")) {
  sql = " SELECT
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
          WHERE t.trait_name ilike '%B11%';"

  return(RPostgres::dbSendQuery(conn, sql, params))
}

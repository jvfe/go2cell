#' Get cell types from GO ids
#'
#' Return cell type information for specific Gene Ontology identifiers
#'
#' This function takes in a character vector of
#' Gene Ontology (GO) identifiers, queries Wikidata
#' (\url{https://www.wikidata.org/})
#' for genes related to said identifiers, and crosses this data
#' with a local RDF database of cell type-marker correspondence,
#' returning, at last, a dataframe of cell type information related to
#' the given GO identifiers.
#'
#' @param go_ids A character vector of Gene Ontology identifiers.
#' @param species A character of a species, can either be Homo sapiens
#'    (default) or Mus musculus.
#'
#' @return A dataframe of 5 columns: The first two correspond to cell types,
#'    that is, their Wikidata Identifier and their name. The two following
#'    columns correspond to the Gene Ontology IDs given, and the last column
#'    corresponds to the cell type's marker that led to the result.
#'
#' @seealso \url{https://www.wikidata.org/} for information regarding
#'   Wikidata and \url{https://panglaodb.se/index.html} for the
#'   original database this information was adapted from.
#'
#' @export
#'
#' @examples
#' # Return cell types related to 'muscle contraction' and 'metabolism'
#' go2cell(c("GO:0006936", "GO:0008152"))
#'
#' # Return cell types related to 'response to zinc ion'
#' go2cell("GO:0010043")
#' \dontrun{
#' # IDs should use ':' not '_'
#' go2cell("GO_0010043")
#' }
go2cell <- function(go_ids, species = "Homo sapiens") {
  if (any(grepl("GO:\\d+", go_ids) == FALSE)) {
    stop("A GO identifier given doesn't match the regex 'GO:\\d+',
             check your input for inconsistencies.")
  }

  species_item <- .get_species_item(species)
  go_ids_collapsed <- .collapse_as_values(go_ids, quotes = TRUE)

  query <- stringr::str_glue(
    "SELECT ?cell_type ?cell_typeLabel ?go_ids ?go_termLabel ?geneLabel WHERE {{
  VALUES (?go_ids) {{{go_ids_collapsed}}
  ?go_term wdt:P686 ?go_ids.
  ?protein wdt:P703 wd:{species_item};
    ?godomain ?go_term;
    wdt:P702 ?gene.
  ?cell_type wdt:P8872 ?gene.
  SERVICE wikibase:label {{ bd:serviceParam wikibase:language \"en\". }}
  }}"
  )

  results <- WikidataQueryServiceR::query_wikidata(query) %>%
    dplyr::mutate(cell_type = .remove_wdt_url(cell_type))
}


#' Get GO ids from cell types
#'
#' Return GO identifiers related to gene markers
#' of specific cell types.
#'
#' This function takes in a character vector of
#' cell type Q identifiers (QIDs), queries Wikidata
#' (\url{https://www.wikidata.org/})
#' and a local RDF database to return GO IDs related
#' to gene markers of these cell types.
#'
#' @param celltype_qids A character vector of cell type Wikidata IDs
#'
#' @return A dataframe of 5 columns: The first two correspond to cell types,
#'    that is, their Wikidata Identifier and their name. The two following
#'    columns correspond to the Gene Ontology IDs given, and the last column
#'    corresponds to the cell type's marker that led to the result.
#'
#' @seealso \url{https://www.wikidata.org/} for information regarding
#'   Wikidata and \url{https://panglaodb.se/index.html} for the
#'   original database this information was adapted from. For an
#'   example of a cell type item in Wikidata, see
#'   \url{https://www.wikidata.org/wiki/Q101405098}
#'
#' @export
#'
#' @examples
#' # Return GO IDs related to cell type
#' # 'human smooth muscle cell'
#' cell2go("Q101404901")
#' \dontrun{
#' # IDs should always start with 'Q'
#' go2cell("101404901")
#' }
cell2go <- function(celltype_qids) {
  if (any(grepl("Q\\d+", celltype_qids) == FALSE)) {
    stop("A QID given doesn't match the regex 'Q\\d+',
             check your input for inconsistencies.")
  }

  with_wd <- paste(stringr::str_glue("wd:{celltype_qids}"), collapse = " ")

  query <- stringr::str_glue(
    "SELECT ?cell_type ?cell_typeLabel ?go_ids ?go_termLabel ?geneLabel WHERE {{
  VALUES ?cell_type {{{with_wd}}
  ?cell_type wdt:P8872 ?gene.
  ?gene wdt:P688 ?protein.
  ?protein (wdt:P680|wdt:P681|wdt:P682) ?go_term.
  ?go_term wdt:P686 ?go_ids.
  SERVICE wikibase:label {{ bd:serviceParam wikibase:language \"en\". }}
  }}"
  )

  results <- WikidataQueryServiceR::query_wikidata(query) %>%
    dplyr::mutate(cell_type = .remove_wdt_url(cell_type))
}

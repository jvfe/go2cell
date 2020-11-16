#' Query Wikidata for genes related to GO ids
#'
#' @param go_ids A character vector of GO identifiers
#'
#' @return A dataframe of GO ids and genes
.get_genes_from_go <- function(go_ids) {
  if (any(grepl("GO:\\d+", go_ids) == FALSE)) {
    stop(
      "A GO identifier given doesn't match the regex 'GO:\\d+', check your input for inconsistencies."
    )
  }

  message("Querying wikidata for GO/gene correspondence...")
  go_query <- sprintf(
    'SELECT ?gene ?go_ids ?go_termLabel ?geneLabel
      WHERE
      {
        VALUES (?go_ids) {%s}
        ?go_term wdt:P686 ?go_ids.
        ?protein wdt:P703 wd:Q15978631;
                 ?godomain ?go_term;
                 wdt:P702 ?gene.
        SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
      }',
    go_ids
  )

  WikidataQueryServiceR::query_wikidata(go_query) %>%
    dplyr::mutate(
      gene = .remove_wdt_url(gene),
    )
}

#' Query local database for cell types related to particular markers
#'
#' @param gene_items A character vector of markers
#'
#' @return A dataframe of cell type Wikidata items and their respective markers
.query_ctp_turtle <- function(gene_items) {
  celltype_marker_graph <- rdflib::rdf_parse(celltype_marker_turtle,
    format = c("turtle")
  )

  ctp_sparql <-
    sprintf(
      "PREFIX ctp: <http://celltypes.wiki.opencura.com/entity/>
                     PREFIX wd: <http://www.wikidata.org/entity/>
                       SELECT ?cell_type ?gene
                       WHERE {
                        VALUES (?genes) {%s}
                        BIND (?genes AS ?gene)
                        ?cell_type ctp:P9 ?gene .
                       }",
      gene_items
    )

  rdflib::rdf_query(celltype_marker_graph, ctp_sparql) %>%
    dplyr::mutate(
      cell_type = .remove_wdt_url(cell_type),
      gene = .remove_wdt_url(gene)
    )
}

#' Query Wikidata for cell type item names from cell type QIDs
#'
#' @param celltype_ids A character vector of cell type QIDs
#'
#' @return A dataframe of QIDs and their respective labels
#'
.get_celltype_items <- function(celltype_ids) {
  message("Querying wikidata for cell type labels...")
  celltype_sparql <- sprintf(
    'SELECT ?cell_type ?cell_typeLabel
  WHERE
  {
    VALUES (?cell_type) {%s}
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
  }',
    celltype_ids
  )

  celltype_wdt <-
    WikidataQueryServiceR::query_wikidata(celltype_sparql) %>%
    dplyr::mutate(cell_type = .remove_wdt_url(cell_type))
}

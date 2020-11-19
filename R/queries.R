#' Query Wikidata for genes related to GO ids
#'
#' @param go_ids A character vector of GO identifiers
#'
#' @return A dataframe of GO ids and genes
#' @examples
#' .get_genes_from_go('('GO:0006936')')
.get_genes_from_go <- function(go_ids) {
    if (any(grepl("GO:\\d+", go_ids) == FALSE)) {
        stop("A GO identifier given doesn't match the regex 'GO:\\d+',
             check your input for inconsistencies.")
    }

    message("Querying wikidata for GO/gene correspondence...")
    go_query <- sprintf("SELECT ?gene ?go_ids ?go_termLabel ?geneLabel
      WHERE
      {
        VALUES (?go_ids) {%s}
        ?go_term wdt:P686 ?go_ids.
        ?protein wdt:P703 wd:Q15978631;
                 ?godomain ?go_term;
                 wdt:P702 ?gene.
        SERVICE wikibase:label { bd:serviceParam wikibase:language \"en\". }
      }",
        go_ids)

    WikidataQueryServiceR::query_wikidata(go_query) %>% dplyr::mutate(gene = .remove_wdt_url(gene))
}

#' Query local database for cell types related to particular markers
#'
#' @param query_values A character vector of SPARQL-valid values
#' @param query_key A character of the key value to select items by
#' @param selector A character vector of the query_values entity
#'
#' @return A dataframe of cell type Wikidata items and their respective markers
#' @examples
#' .query_ctp_turtle('(wd:Q14881255) (wd:Q18016342)')
.query_ctp_turtle <- function(query_values, query_key, selector) {
    celltype_marker_graph <- rdflib::rdf_parse(celltype_marker_turtle,
        format = c("turtle"))

    ctp_sparql <- stringr::str_glue(
    "PREFIX ctp: <http://celltypes.wiki.opencura.com/entity/>
     PREFIX wd: <http://www.wikidata.org/entity/>
      SELECT ?{query_key} ?{selector}
           WHERE {{
            VALUES (?values) {{{query_values}}}
            BIND (?values AS ?{selector})
            ?{query_key} ctp:P9 ?{selector}.
           }}"
    )

    rdflib::rdf_query(celltype_marker_graph, ctp_sparql) %>%
      dplyr::mutate(cell_type = .remove_wdt_url(cell_type),
        gene = .remove_wdt_url(gene))
}

#' Query Wikidata for cell type item names from cell type QIDs
#'
#' @param celltype_ids A character vector of cell type QIDs
#'
#' @return A dataframe of QIDs and their respective labels
#' @examples
#' .get_celltype_items('(wd:Q101405098) (wd:Q101404862)')
.get_celltype_items <- function(celltype_ids) {
    message("Querying wikidata for cell type labels...")
    celltype_sparql <- sprintf("SELECT ?cell_type ?cell_typeLabel
  WHERE
  {
    VALUES (?cell_type) {%s}
    SERVICE wikibase:label { bd:serviceParam wikibase:language \"en\". }
  }",
        celltype_ids)

    celltype_wdt <- WikidataQueryServiceR::query_wikidata(celltype_sparql) %>%
        dplyr::mutate(cell_type = .remove_wdt_url(cell_type))
}

#' Query Wikidata for GO ids associated with particular genes
#'
#' @param genes A character vector of SPARQL-valid gene items
#'
#' @return A dataframe of GO ids and genes
#'
#' @examples
#' .get_go_from_genes("(wd:Q15317282) (wd:Q14912592) (wd:Q14912176)")
.get_go_from_genes <- function(genes) {
  message("Querying wikidata for GO/gene correspondence...")
  gene_sparql <- stringr::str_glue(
  "SELECT ?gene ?go_term ?go_itemLabel ?geneLabel
      WHERE
      {{
        VALUES (?gene) {{{genes}}}
        ?gene wdt:P703 wd:Q15978631;
              wdt:P688 ?protein .
        ?protein (wdt:P680|wdt:P681|wdt:P682) ?go_item.
        ?go_item wdt:P686 ?go_term.

        SERVICE wikibase:label {{ bd:serviceParam wikibase:language 'en'. }}
      }}")

  WikidataQueryServiceR::query_wikidata(gene_sparql) %>%
    dplyr::mutate(gene = .remove_wdt_url(gene))
}

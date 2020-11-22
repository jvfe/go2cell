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
go2cell <- function(go_ids) {
  go_ids_collapsed <- .collapse_as_values(go_ids, quotes = TRUE)

  genes_from_go <- .get_genes_from_go(go_ids_collapsed)

  gene_values <- unique(genes_from_go$gene)

  celltypes <- .query_ctp_turtle(gene_values, query_key = "cell_type", selector = "gene", mode = "go2cell")

  celltypes_collapsed <- .collapse_as_values(celltypes$cell_type)

  celltype_wdt <- .get_celltype_items(celltypes_collapsed)

  final_table <- celltypes %>%
    dplyr::inner_join(genes_from_go,
      by = "gene"
    ) %>%
    dplyr::left_join(celltype_wdt, by = c("cell_type")) %>%
    dplyr::select(
      cell_type, cell_typeLabel, go_ids, go_termLabel,
      geneLabel
    )
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

  with_wd <- stringr::str_glue("wd:{celltype_qids}")

  celltypes <- .query_ctp_turtle(with_wd, query_key = "gene", selector = "cell_type", mode = "cell2go")

  gene_values <- .collapse_as_values(celltypes$gene)

  go_from_genes <- .get_go_from_genes(gene_values)

  celltypes_collapsed <- .collapse_as_values(celltypes$cell_type)

  celltype_wdt <- .get_celltype_items(celltypes_collapsed)

  final_table <- celltypes %>%
    dplyr::inner_join(go_from_genes, by = "gene") %>%
    dplyr::left_join(celltype_wdt, by = c("cell_type")) %>%
    dplyr::select(
      cell_type, cell_typeLabel, go_term, go_itemLabel,
      geneLabel
    )
}

#' Title
#'
#' @param go_ids
#'
#' @return
#' @export
#'
#' @examples
go2cell <- function(go_ids) {

  go_ids_collapsed <- .collapse_as_values(go_ids, quotes = TRUE)

  genes_from_go <- .get_genes_from_go(go_ids_collapsed)

  gene_values <- .collapse_as_values(genes_from_go$gene)

  celltypes <- .query_ctp_turtle(gene_values)

  celltypes_collapsed <- .collapse_as_values(celltypes$cell_type)

  celltype_wdt <- .get_celltype_items(celltypes_collapsed)

  final_table <- celltypes %>%
    dplyr::inner_join(genes_from_go, by = "gene") %>%
    dplyr::left_join(celltype_wdt, by = c("cell_type")) %>%
    dplyr::select(cell_type, cell_typeLabel, go_ids, go_termLabel, geneLabel)
}

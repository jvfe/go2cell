collapsed_go_id <- "('GO:0006936')"
collapsed_gene_items <- "(wd:Q14881255) (wd:Q18016342)"
collapsed_cell_types <- "(wd:Q101405098) (wd:Q101404862)"

test_that("Querying GO ids for genes works", {
  genes <- .get_genes_from_go(collapsed_go_id)

  expect_s3_class(genes, "data.frame")
  expect_equal(unique(genes$go_ids), "GO:0006936")
  expect_true(nrow(genes) > 100)
  expect_equal(ncol(genes), 4)
})

test_that("Querying local rdf for cell types", {
  celltypes <- .query_ctp_turtle(collapsed_gene_items, query_key = "gene", selector = "cell_type")

  expect_s3_class(celltypes, "data.frame")
  expect_true(nrow(celltypes) > 300)
  expect_equal(ncol(celltypes), 2)
})

test_that("Querying Wikidata for cell type labels", {
  wdt_celltypes <- .get_celltype_items(collapsed_cell_types)

  expect_s3_class(wdt_celltypes, "data.frame")
  expect_equal(unique(wdt_celltypes$cell_type), c("wd:Q101405098", "wd:Q101404862"))
  expect_equal(nrow(wdt_celltypes), 2)
  expect_equal(ncol(wdt_celltypes), 2)
})

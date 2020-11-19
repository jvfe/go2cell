go_ids <- c(
  "GO:0006936", "GO:0008152", "GO:0015031",
  "GO:0006468", "GO:0010043", "GO:0006837",
  "GO:0006359", "GO:0005978", "GO:0007260", "GO:0014873"
)

celltype_qids <- c("Q101404881", "Q101404901", "Q101404922")

broken_id <- "GO_0006936"
# broken_qid <-

test_that("go2cell works", {
  celltype_info <- go2cell(go_ids)

  expect_setequal(unique(celltype_info$go_ids), go_ids)
  expect_true(nrow(celltype_info) > 100)
  expect_equal(ncol(celltype_info), 5)
})

test_that("cell2go works", {
  celltype_info <- cell2go(celltype_qids)

  expect_setequal(unique(celltype_info$cell_type), stringr::str_glue("wd:{celltype_qids}"))
  expect_true(nrow(celltype_info) > 3400)
  expect_equal(ncol(celltype_info), 5)
})

test_that("broken GO ids raise error", {
  expect_error(go2cell(broken_id))
})

to_collapse <- c(rep(c("GO:0006936", "GO:0008152"), 7))
to_collapse_single <- "GO:0006936"

to_clean <- c("http://www.wikidata.org/entity/Q18031649", "http://www.wikidata.org/entity/Q227339")

test_that("basic collapsing works", {
  vec_collapsed <- .collapse_as_values(to_collapse)
  single_collapsed <- .collapse_as_values(to_collapse_single)

  expect_equal(vec_collapsed, "(GO:0006936) (GO:0008152)")
  expect_equal(single_collapsed, "(GO:0006936)")
})

test_that("quoted collapsing works", {
  vec_collapsed <- .collapse_as_values(to_collapse, quotes = TRUE)
  single_collapsed <- .collapse_as_values(to_collapse_single, quotes = TRUE)

  expect_equal(vec_collapsed, "('GO:0006936') ('GO:0008152')")
  expect_equal(single_collapsed, "('GO:0006936')")
})

test_that("URL removal works", {
  clean <- .remove_wdt_url(to_clean)

  expect_equal(clean, c("wd:Q18031649", "wd:Q227339"))
})

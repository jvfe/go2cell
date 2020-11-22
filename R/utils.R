#' Format string or character vector as SPARQL-compatible list
#'
#' @param item_vector A string or a character vector of items
#' @param quotes A logical to indicate whether or not to encase in quotes
#'
#' @return A SPARQL-compatible string of the values
#' @examples
#' .collapse_as_values(c("GO:0006936", "GO:0008152"))
.collapse_as_values <- function(item_vector, quotes = FALSE) {
  unique_items <- stringr::str_trim(unique(item_vector))

  if (quotes) {
    paste(paste0("('", unique_items, "')"), collapse = " ")
  } else {
    paste(paste0("(", unique_items, ")"), collapse = " ")
  }
}

#' Substitute the wikidata url for a SPARQL-friendly wd:
#'
#' @param column The column of the dataframe to substitute
#'
#' @return A character vector
#' @examples
#' .remove_wdt_url("http://www.wikidata.org/entity/Q18031649")
.remove_wdt_url <- function(column) {
  stringr::str_replace_all(
    column, "http://www.wikidata.org/entity/",
    "wd:"
  )
}

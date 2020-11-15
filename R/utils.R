#' Title
#'
#' @param item_vector
#' @param quotes
#'
#' @return
#' @export
#'
#' @examples
.collapse_as_values <- function(item_vector, quotes = FALSE) {
  unique_items <- unique(item_vector)

  if (quotes) {
    paste(paste0("('", unique_items, "')"), collapse = " ")
  } else {
    paste(paste0("(", unique_items, ")"), collapse = " ")
  }
}

#' Title
#'
#' @param column
#'
#' @return
#' @export
#'
#' @examples
.remove_wdt_url <- function(column) {
  stringr::str_replace_all(column, "http://www.wikidata.org/entity/", "wd:")
}

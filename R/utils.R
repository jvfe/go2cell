#' Format string or character vector as SPARQL-compatible list
#'
#' @param item_vector A string or a character vector of items
#' @param quotes A logical to indicate whether or not to encase in quotes
#'
#' @return A SPARQL-compatible string of the values
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
.remove_wdt_url <- function(column) {
  stringr::str_replace_all(
    column, "http://www.wikidata.org/entity/",
    "wd:"
  )
}

#' Return the item for a particular species
#'
#' @param species_name The scientific name of the species
#'
#' @return The Wikidata item for said species
.get_species_item <- function(species_name) {
  values <- c("Q15978631", "Q83310")
  names(values) <- c("Homo sapiens", "Mus musculus")

  if (!(species_name %in% names(values))) {
    stop("Species must be either 'Homo sapiens' or 'Mus musculus'")
  }

  values[[species_name]]
}

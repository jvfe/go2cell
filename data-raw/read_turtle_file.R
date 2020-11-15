
ttl_file <- "data-raw/celltype_marker_graph.ttl"

celltype_marker_turtle <- readChar(ttl_file, file.info(ttl_file)$size)

usethis::use_data(celltype_marker_turtle, overwrite = TRUE)

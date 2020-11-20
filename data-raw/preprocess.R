
ttl_file <- "data-raw/celltype_marker_graph.ttl"

celltype_marker_turtle <- readChar(ttl_file, file.info(ttl_file)$size)

go2cell_test_data <- read.csv("data-raw/go_small_dataset.csv")

usethis::use_data(celltype_marker_turtle, overwrite = TRUE)
usethis::use_data(go2cell_test_data, overwrite = TRUE)

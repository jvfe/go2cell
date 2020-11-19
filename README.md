
<!-- README.md is generated from README.Rmd. Please edit that file -->

# go2cell

<!-- badges: start -->

<!-- badges: end -->

By using [Wikidata](https://www.wikidata.org/wiki/Wikidata:Main_Page)
and a local RDF database of cell type gene markers, go2cell links Gene
Ontology terms to cell types, therefore enriching Omics results with
open semantic knowledge.

## Installation

You can install the latest version of go2cell from GitHub with:

``` r
install.packages("remotes")
remotes::install_github("jvfe/go2cell")
```

## Quickstart

Suppose we want to retrieve cell types with gene markers related to GO
terms ‘muscle contraction’ and ‘glycoprotein metabolic process’:

``` r
library(go2cell)

go_ids <- c("GO:0006936", "GO:0009100")

results <- go2cell(go_ids)
```

| cell\_type    | cell\_typeLabel     | go\_ids      | go\_termLabel                  | geneLabel |
| :------------ | :------------------ | :----------- | :----------------------------- | :-------- |
| wd:Q101404949 | human myofibroblast | <GO:0006936> | muscle contraction             | CALD1     |
| wd:Q101404949 | human myofibroblast | <GO:0006936> | muscle contraction             | ACTA2     |
| wd:Q101404949 | human myofibroblast | <GO:0006936> | muscle contraction             | MYL9      |
| wd:Q101404949 | human myofibroblast | <GO:0006936> | muscle contraction             | DES       |
| wd:Q101404922 | human epsilon cell  | <GO:0009100> | glycoprotein metabolic process | PCSK6     |
| wd:Q101404940 | human myoblast      | <GO:0006936> | muscle contraction             | TPM2      |

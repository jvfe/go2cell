
<!-- README.md is generated from README.Rmd. Please edit that file -->

# go2cell

<!-- badges: start -->

[![R build
status](https://github.com/jvfe/go2cell/workflows/R-CMD-check/badge.svg)](https://github.com/jvfe/go2cell/actions)
[![docs](https://github.com/jvfe/go2cell/workflows/pkgdown/badge.svg)](https://jvfe.github.io/go2cell/index.html)
<!-- badges: end -->

By using [Wikidata](https://www.wikidata.org/wiki/Wikidata:Main_Page),
go2cell links Gene Ontology terms to cell types, therefore enriching
Omics results with open semantic knowledge.

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

| cell\_type    | cell\_typeLabel     | go\_ids      | go\_termLabel      | geneLabel |
| :------------ | :------------------ | :----------- | :----------------- | :-------- |
| wd:Q101404903 | human myocyte       | <GO:0006936> | muscle contraction | ANKRD2    |
| wd:Q101404861 | human fibroblast    | <GO:0006936> | muscle contraction | TBX20     |
| wd:Q101405077 | human cardiomyocyte | <GO:0006936> | muscle contraction | TBX20     |
| wd:Q101405077 | human cardiomyocyte | <GO:0006936> | muscle contraction | CKMT2     |
| wd:Q101405077 | human cardiomyocyte | <GO:0006936> | muscle contraction | MYBPC3    |
| wd:Q101404903 | human myocyte       | <GO:0006936> | muscle contraction | MYH1      |

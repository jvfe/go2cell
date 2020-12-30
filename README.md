
<!-- README.md is generated from README.Rmd. Please edit that file -->

# go2cell

<!-- badges: start -->

[![R build
status](https://github.com/jvfe/go2cell/workflows/R-CMD-check/badge.svg)](https://github.com/jvfe/go2cell/actions)
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

| cell\_type    | cell\_typeLabel          | go\_ids      | go\_termLabel      | geneLabel |
| :------------ | :----------------------- | :----------- | :----------------- | :-------- |
| wd:Q101404903 | human myocyte            | <GO:0006936> | muscle contraction | ACTN2     |
| wd:Q101405077 | human cardiomyocyte      | <GO:0006936> | muscle contraction | ACTN2     |
| wd:Q101404901 | human smooth muscle cell | <GO:0006936> | muscle contraction | DES       |
| wd:Q101404903 | human myocyte            | <GO:0006936> | muscle contraction | DES       |
| wd:Q101404909 | human sertoli cell       | <GO:0006936> | muscle contraction | DES       |
| wd:Q101404940 | human myoblast           | <GO:0006936> | muscle contraction | DES       |

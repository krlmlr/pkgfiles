
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pkgfiles

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/krlmlr/pkgfiles.svg?branch=master)](https://travis-ci.org/krlmlr/pkgfiles)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/krlmlr/pkgfiles?branch=master&svg=true)](https://ci.appveyor.com/project/krlmlr/pkgfiles)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/pkgfiles)](https://cran.r-project.org/package=pkgfiles)
<!-- badges: end -->

The goal of pkgfiles is to enumerate and classify all files in an R
package project. This is mostly useful for other packages that iterate
over all files of a specific kind in an R package.

## Installation

Once released, you can install the released version of pkgfiles from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("pkgfiles")
```

For now, install from GitHub with

``` r
# install.packages("devtools")
devtools::install_github("krlmlr/pkgfiles")
```

## Example

The `pf_get()` function enumerates and classifies all files in the
current project.

``` r
library(pkgfiles)
pf_get()
#> ✔ Setting active project to '/home/kirill/git/R/pkgfiles'
#> ●   4 R source
#> ●   1 DESCRIPTION
#> ●   1 NEWS
#> ●   1 RStudio project
#> ●   1 Documentation
#> ●   1 NAMESPACE
#> ●   3 CI configuration
#> ●   2 README
#> ●   1 Build-ignore configuration
#> ●   1 Git-ignore configuration
#> ●   1 R history
#> ● 136 Git internal
#> ●  60 RStudio internal
```

Under the hood, the returned object is a tibble that contains the return
from a `fs::dir_info()` call augmented by a `class` column:

``` r
tibble::as_tibble(pf_get())
#> # A tibble: 213 x 19
#>    path       type     size permissions modification_time   user  group
#>    <fs::path> <fct> <fs::b> <fs::perms> <dttm>              <chr> <chr>
#>  1 .Rbuildig… file       89 rw-rw-r--   2019-05-20 16:06:14 kiri… kiri…
#>  2 .Rhistory  file    3.55K rw-rw-r--   2019-05-20 16:03:43 kiri… kiri…
#>  3 .Rproj.us… file        8 rw-rw-r--   2019-05-20 11:29:47 kiri… kiri…
#>  4 .Rproj.us… file       23 rw-rw-r--   2019-05-20 11:29:47 kiri… kiri…
#>  5 .Rproj.us… file        0 rw-rw-r--   2019-05-20 11:29:47 kiri… kiri…
#>  6 .Rproj.us… file      136 rw-rw-r--   2019-05-20 11:29:47 kiri… kiri…
#>  7 .Rproj.us… file       73 rw-rw-r--   2019-05-20 11:29:47 kiri… kiri…
#>  8 .Rproj.us… file      478 rwxrwxr-x   2019-05-20 11:29:47 kiri… kiri…
#>  9 .Rproj.us… file      896 rwxrwxr-x   2019-05-20 11:29:47 kiri… kiri…
#> 10 .Rproj.us… file    3.25K rwxrwxr-x   2019-05-20 11:29:47 kiri… kiri…
#> # … with 203 more rows, and 12 more variables: device_id <dbl>,
#> #   hard_links <dbl>, special_device_id <dbl>, inode <dbl>,
#> #   block_size <dbl>, blocks <dbl>, flags <int>, generation <dbl>,
#> #   access_time <dttm>, change_time <dttm>, birth_time <dttm>, class <chr>
```

The classification is based on regular expressions for the
project-relative path of the files. This list is extensible but the
existing entries should rarely change.

``` r
pkgfiles:::classification
#> # A tibble: 33 x 3
#>    class             regex                        desc                     
#>    <chr>             <chr>                        <chr>                    
#>  1 R                 "^R/(?:[^/])+\\.[rR]$"       R source                 
#>  2 R/unix            "^R/unix/(?:[^/])+\\.[rR]$"  R source (Unix only)     
#>  3 R/windows         "^R/windows/(?:[^/])+\\.[rR… R source (Windows only)  
#>  4 DESCRIPTION       ^DESCRIPTION$                DESCRIPTION              
#>  5 NEWS              "^(?:NEWS|NEWS\\.md|ChangeL… NEWS                     
#>  6 Rproj             ^.*[.]Rproj$                 RStudio project          
#>  7 man               "^man/(?:[^/])+\\.Rd$"       Documentation            
#>  8 man/unix          "^man/unix/(?:[^/])+\\.Rd$"  Documentation (Unix only)
#>  9 man/windows       "^man/windows/(?:[^/])+\\.R… Documentation (Windows o…
#> 10 vignettes/text/R… "^vignettes/(?:[^/])+\\.Rmd… Vignette (Rmd sources)   
#> # … with 23 more rows
```

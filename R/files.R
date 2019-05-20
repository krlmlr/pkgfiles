#' Enumerates all files in a package
#'
#' Wraps [fs::dir_info()] and appends a column `"class"`.
#' Operates on the directory returned by [usethis::proj_get()].
#'
#' @export
pf_get <- function() {
  proj <- usethis::proj_get()

  files_abs <- fs::dir_ls(proj, all = TRUE, recurse = TRUE, type = "file")
  files_rel <- fs::path_rel(files_abs, proj)
  files <- fs::file_info(files_rel)

  pf_classify(files)
}

pf_classify <- function(files) {
  files[["class"]] <- class_from_path(files[["path"]])

  new_pkgfiles(files)
}

new_pkgfiles <- function(x) {
  structure(x, class = c("pkgfiles", class(x)))
}

#' @export
print.pkgfiles <- function(x, ...) {
  class <- forcats::fct_drop(factor(x[["class"]], levels = forcats::fct_inorder(classification[["class"]])))
  xs <- split(x, class)

  nrows <- map_int(xs, nrow)
  descs <- classification[["desc"]][match(names(nrows), classification[["class"]])]

  unclass <- which(is.na(class))
  if (has_length(unclass)) {
    nrows <- c(nrows, length(unclass))
    descs <- c(descs, paste0("Other: ", comma_list(crayon::magenta(x[["path"]][unclass]))))
  }

  cli::cat_bullet(crayon::green(format(nrows)), " ", descs)

  invisible(x)
}

comma_list <- function(x) {
  MAX_LIST <- 6
  if (length(x) > MAX_LIST) {
    length(x) <- MAX_LIST
    x[[MAX_LIST]] <- cli::symbol$ellipsis
  }

  paste(x, collapse = ", ")
}

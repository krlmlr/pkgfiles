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

file_class <- function(dir, ext) {
  paste0("^", dir, "/[^/]*[.]", ext, "$")
}

classification <- c(
  R = file_class("R", "[rR]"),
  man = file_class("man", "Rd")
)

class_from_path <- function(x) {
  class_from(x, 1)
}

class_from <- function(x, i) {
  ret <- rep_along(x, NA_character_)

  if (i > length(classification)) {
    return(ret)
  }

  this_class <- grepl(classification[[i]], x, perl = TRUE)
  ret[this_class] <- names(classification)[[i]]
  ret[!this_class] <- class_from(x[!this_class], i + 1L)
  ret
}

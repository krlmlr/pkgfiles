file_class <- function(dir, ext) {
  rex(
    start,

    dir,

    "/",
    one_or_more(none_of("/")),
    ".",

    regex(ext),

    end
  )
}

classification <- tribble(
  ~class, ~regex,
  "R",    file_class("R", "[rR]"),
  "man",  file_class("man", "Rd"),
)

class_from_path <- function(x) {
  class_from(x, 1)
}

class_from <- function(x, i) {
  ret <- rep_along(x, NA_character_)

  if (i > length(classification)) {
    return(ret)
  }

  this_class <- grepl(classification[["regex"]][[i]], x, perl = TRUE)
  ret[this_class] <- classification[["class"]][[i]]
  ret[!this_class] <- class_from(x[!this_class], i + 1L)
  ret
}

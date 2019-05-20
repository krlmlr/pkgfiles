file_name_anywhere <- function(name) {
  if (length(name) > 1) {
    name <- rex(or(name))
  }

  rex(
    or(start, "/"),

    name,

    end
  )
}

file_name <- function(name) {
  if (length(name) > 1) {
    name <- rex(or(name))
  }

  rex(
    start,

    name,

    end
  )
}

file_dir <- function(dir) {
  rex(
    start,

    dir,

    "/",
    one_or_more(none_of("/"))
  )
}

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
  ~class,               ~regex,                                               ~desc,
  "R",                  file_class("R", "[rR]"),                              "R source",
  "R/unix",             file_class("R/unix", "[rR]"),                         "R source (Unix only)",
  "R/windows",          file_class("R/windows", "[rR]"),                      "R source (Windows only)",
  "DESCRIPTION",        file_name("DESCRIPTION"),                             "DESCRIPTION",
  "Rproj",              file_name(regex(".*[.]Rproj")),                       "RStudio project",
  "man",                file_class("man", "Rd"),                              "Documentation",
  "man/unix",           file_class("man/unix", "Rd"),                         "Documentation (Unix only)",
  "man/windows",        file_class("man/windows", "Rd"),                      "Documentation (Windows only)",
  "vignettes/text/Rmd", file_class("vignettes", "Rmd"),                       "Vignette (Rmd sources)",
  "vignettes/text/Rnw", file_class("vignettes", "Rnw"),                       "Vignette (Rnw sources)",
  "vignettes/data",     file_dir("vignettes"),                                "Vignette (unknown/data)",
  "tests/src/other",    file_class("tests", "[rR]"),                          "Test (code, other)",
  "tests/src/testthat", file_class("tests/testthat", "[rR]"),                 "Test (code, testthat files)",
  "tests/data",         file_dir("tests"),                                    "Test (data)",
  "NAMESPACE",          file_name("NAMESPACE"),                               "NAMESPACE",
  "data",               file_dir("data"),                                     "Data",
  "src/code/c",         file_class("src", "c"),                               "Compiled code (C source)",
  "src/code/cpp",       file_class("src", "cpp"),                             "Compiled code (C++ source)",
  "src/code/h",         file_class("src", "h"),                               "Compiled code (C/C++ header)",
  "src/data",           file_dir("src"),                                      "Compiled code (unknown/data)",
  "inst",               file_dir("inst"),                                     "Installed",
  "exec",               file_dir("exec"),                                     "Executable scripts",
  "po",                 file_dir("po"),                                       "Translation",
  "tools",              file_dir("tools"),                                    "Auxiliary for configuration",
  "ci",                 file_name(c(".travis.yml", "appveyor.yml", "tic.R")), "CI configuration",
  "README",             file_name(c("README.md", "README.Rmd")),              "README",
  "Rbuildignore",       file_name(".Rbuildignore"),                           "Build-ignore configuration",
  "gitignore",          file_name_anywhere(".gitignore"),                     "Git-ignore configuration",
  ".Rhistory",          file_name(".Rhistory"),                               "R history",
  ".git",               file_dir(".git"),                                     "Git internal",
  ".svn",               file_dir(".svn"),                                     "SVN internal",
  ".Rproj.user",        file_dir(".Rproj.user"),                              "RStudio internal",
)

class_from_path <- function(x) {
  class_from(x, 1)
}

class_from <- function(x, i) {
  ret <- rep_along(x, NA_character_)

  if (i > NROW(classification)) {
    return(ret)
  }

  this_class <- grepl(classification[["regex"]][[i]], x, perl = TRUE)
  ret[this_class] <- classification[["class"]][[i]]
  ret[!this_class] <- class_from(x[!this_class], i + 1L)
  ret
}

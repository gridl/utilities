#' Simple test utility.
#'
#' @export
#' @rdname internal
test_guard <- function () guard()

log <- function (level, ...) {
  ccat0(default = "red", '[', level, '] ', ..., '\n')
}

#' Debug utilities.
#' 
#' @param ... Parts of the message, concatenated with an empty string.
#'
#' @export
#' @rdname debug
dbg <- function (...) {
  if (isTRUE(getOption("utilities.debug"))) log("DEBUG", ...)
}

#' @param fname Optional name of the function `guard()` is called from.
#'
#' @export
#' @rdname debug
guard <- function (fname = NULL) {
  if (is.null(fname)) {
    x <- sys.call(-1)[[1]]
  
    fname <- '<unnamed>'
    if (is.symbol(x) || (is.language(x) && is_double_colon(x[[1]]))) {
      fname <- deparse(x)
    }
  }

  stopifnot(is_nonempty_string(fname))

  dbg("-> ", fname, '()')
  
  parent <- sys.frame(sys.parent(1))
  expr <- substitute(dbg(x), list(x = paste0('<- ', fname, '()')))
  do.call(on.exit, list(expr = expr, add = TRUE), envir = parent)
  
  invisible()
}

#' Stop if condition is met.
#'
#' @param ... Expression(s) that must evaluate to `FALSE`.
#'
#' @export
stopif <- function (...) {
  i <- which(map_lgl(list(...), function(x)isTRUE(as.logical(x))))
  if (!length(i)) return(invisible(FALSE))
  mc <- match.call()
  lb <- map_chr(mc[i+1], deparse)
  stop('following conditions are true: ', join(lb, ', '), call. = FALSE)
}


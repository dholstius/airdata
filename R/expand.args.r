#' expand.args
#'
#' Return positional, named, and optional (...) arguments from within a function
#'
#' @examples
#' f <- function(a, b=2, ..., z=26) {
#'    expand.args()
#' }
#' > f(1, j=10)
#'
expand.args <- function() {
    named_args <- as.list(parent.frame())
    dot_args <- as.list(substitute(list(...), parent.frame()))[-1L]
    c(named_args, dot_args)
}
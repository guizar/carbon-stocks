resave <- function(..., list = character(), file) {
   previous  <- load(file)
   var.names <- c(list, as.character(substitute(list(...)))[-1L])
   for (var in var.names) assign(var, get(var, envir = parent.frame()))
   save(list = unique(c(previous, var.names)), file = file)
}

# Example
# x1 <- 1
# x2 <- 2
# x3 <- 3
# save(x1, x2, x3, file = "abc.RData")
# source: http://stackoverflow.com/questions/11813096/updating-an-existing-rdata-file
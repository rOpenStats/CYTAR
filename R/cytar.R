#' CYTARDatasource
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @import testthat
#' @import readr
#' @export
CYTARDatasource <- R6Class("CYTARDatasource",
  public = list(
   delim                   = NA,
   data.url                = NA,
   data.filename           = NA,
   col.types               = NA,
   #state
   data                    = NA,
   logger                  = NA,
   initialize = function(data.url, data.filename, col.types,
                         delim = ";"){
    self$data.url      <- data.url
    self$data.filename <- data.filename
    self$col.types     <- col.types
    self$delim         <- delim
    self$logger        <- genLogger(self)
    self
   },
   loadData = function(){
    data.dir <- getEnv("data_dir")
    data.path <- file.path(data.dir, self$data.filename)
    if (!file.exists(data.path)){
     dir.create(data.dir, showWarnings = FALSE, recursive = TRUE)
     download.file(url = self$data.url, destfile = data.path)
    }
    self$data <- read_delim(file = data.path, delim = self$delim,
                            col_types = self$col.types)
    self$data
   }))

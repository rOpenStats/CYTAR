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
   data                    = NA,
   #state
   initialize = function(data.url, data.filename, col.types,
                         delim = ";"){
    self$data.url      <- data.url
    self$data.filename <- data.filename
    self$col.types     <- col.types
    self$delim         <- delim
    self
   },
   loadData = function(){
    data.dir <- getEnv("data_dir")
    data.path <- file.path(data.dir, self$data.filename)
    if (!file.exists(data.path)){
      dir.create(data.dir, showWarnings = FALSE, recursive = TRUE)
      download.file(url = self$data.url, destfile = data.path)
    }
    read_delim(file = data.path, delim = self$delim,
               col_types = cols(
                persona_id = col_double(),
                nombre = col_character(),
                apellido = col_character(),
                sexo_id = col_double(),
                edad = col_double(),
                cvar_ultimo_acceso = col_date(format = "")
               ))
   }))

#' CYTARPersonas
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @import testthat
#' @export
CYTARPersonas <- R6Class("CYTARPersonas",
  inherit = CYTARDatasource,
  public = list(
  initialize = function(){
    super$initialize(data.url = "https://datasets.datos.mincyt.gob.ar/dataset/06ae9728-c376-47bd-9c41-fbdca68707c6/resource/8ab77b16-f1a8-4d3f-b664-67becf83a9b9/download/personas.csv",
                     "personas.csv",
                     col.types = cols(
                      persona_id = col_double(),
                      nombre = col_character(),
                      apellido = col_character(),
                      sexo_id = col_double(),
                      edad = col_double(),
                      cvar_ultimo_acceso = col_date(format = "")
                     ))
    self
  }))

#' CYTARPersonas2018
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @import testthat
#' @export
CYTARPersonas2018 <- R6Class("CYTARPersonas2018",
  inherit = CYTARDatasource,
  public = list(
   initialize = function(){
    super$initialize(data.url = "https://datasets.datos.mincyt.gob.ar/dataset/06ae9728-c376-47bd-9c41-fbdca68707c6/resource/87a7573d-98b1-4ba5-97f1-c37ac1970043/download/personas_2018.csv",
                     data.filename = "personas_2018.csv",
                     col.types = NULL)
    self
   }))

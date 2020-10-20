
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
                     data.filename = "personas.csv",
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

#' CYTAR
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @import testthat
#' @export
#super$initialize(data.url = "https://datasets.datos.mincyt.gob.ar/dataset/06ae9728-c376-47bd-9c41-fbdca68707c6/resource/7b07fb44-64c3-4902-ab73-f59d4ed8a2f5/download/personas_2018.csv",


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
   consolidated = NA,
   personas = NA,
   initialize = function(){
    super$initialize(data.url = "https://datasets.datos.mincyt.gob.ar/dataset/06ae9728-c376-47bd-9c41-fbdca68707c6/resource/7b07fb44-64c3-4902-ab73-f59d4ed8a2f5/download/personas_2018.csv",
                     data.filename = "personas_2018.csv",
                     col.types = cols(
                       .default = col_integer(),
                       seniority_level = col_character()
                     ))
    self
   },
   checkConsolidatedFields = function(fields){

   },
   consolidate = function(){
     self$personas <- CYTARPersonas$new()
     self$personas$loadData()

     self$loadData()
     personas.data <- self$personas$data
     personas.data %<>% select(persona_id, nombre, apellido, cvar_ultimo_acceso)
     self$consolidated <- self$data %>% inner_join(personas.data, by = "persona_id")
     #TODO check sexo and edad
     self$checkConsolidatedFields(c("sexo_id", "edad"))
     self$data
   }))




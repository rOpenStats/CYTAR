#' CYTARDisciplinasRef
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @import testthat
#' @export
CYTARDisciplinasRef <- R6Class("CYTARDisciplinasRef",
  inherit = CYTARDatasource,
  public = list(
   consolidated = NA,
   disciplinas = NA,
   initialize = function(){
    super$initialize(data.url = "https://datasets.datos.mincyt.gob.ar/dataset/06ae9728-c376-47bd-9c41-fbdca68707c6/resource/ab280873-8206-4e16-a020-064a9243277f/download/ref_disciplina.csv",
                     data.filename = "ref_disciplina.csv",
                     col.types =
                      cols(
                       disciplina_id = col_integer(),
                       gran_area_codigo = col_integer(),
                       gran_area_descripcion = col_character(),
                       area_codigo = col_integer(),
                       area_descripcion = col_character(),
                       disciplina_codigo = col_character(),
                       disciplina_descripcion = col_character()
                      )
    )
    self
   },
   checkConsolidatedFields = function(fields){

   },
   consolidate = function(){
    self$loadData()
    self$data
   }))

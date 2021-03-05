#' CYTARCategoriaConicetRef
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @import testthat
#' @export
CYTARCategoriaConicetRef <- R6Class("CYTARCategoriaConicetRef",
  inherit = CYTARDatasource,
  public = list(
   consolidated = NA,
   disciplinas = NA,
   initialize = function(){
    super$initialize(data.url = "https://datasets.datos.mincyt.gob.ar/dataset/06ae9728-c376-47bd-9c41-fbdca68707c6/resource/c72c9f88-d9ef-4349-bb20-5c9a1aca5d67/download/ref_categoria_conicet.csv",
                     data.filename = "ref_categoria_conicet.csv",
                     col.types =
                       cols(
                         categoria_conicet_id = col_double(),
                         categoria_conicet_descripcion = col_character()
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

#' CYTARTipoPersonalRef
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @import testthat
#' @export
CYTARTipoPersonalRef <- R6Class("CYTARTipoPersonalRef",
 inherit = CYTARDatasource,
 public = list(
    consolidated = NA,
    disciplinas = NA,
    initialize = function(){
       super$initialize(data.url = "https://datasets.datos.mincyt.gob.ar/dataset/06ae9728-c376-47bd-9c41-fbdca68707c6/resource/90d498e9-5a96-46df-b51d-956b5702bb02/download/ref_tipo_personal.csv",
                        data.filename = "ref_tipo_personal.csv",
                        col.types = cols(
                          tipo_personal_id = col_double(),
                          tipo_personal_descripcion = col_character()
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
                            disciplina_id = col_double(),
                            gran_area_codigo = col_double(),
                            gran_area_descripcion = col_character(),
                            area_codigo = col_double(),
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

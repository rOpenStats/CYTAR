
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
  },
  consolidate = function(){
     self$configure()
     self$loadData()
     self$data
  }))



#' CYTARPersonasAnio
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @import testthat
#' @export
CYTARPersonasAnio <- R6Class("CYTARPersonasAnio",
 inherit = CYTARDatasource,
 public = list(
   disciplinas.ref       = NA,
   categoria.conicet.ref = NA,
   tipo.personal.ref     = NA,
   categorias.summary    = NA,
   initialize = function(year, data.url, disciplinas.ref){
     url.splitted <- strsplit(data.url, split = "/")[[1]]
     super$initialize(data.url = data.url,
                      data.filename = url.splitted[length(url.splitted)],
                      col.types =
                        cols(
                          .default = col_double(),
                          seniority_level = col_character()
                        )
                      )
     self
   },
   configure = function(){
      if (!self$configured){
         self$disciplinas.ref <- CYTARDisciplinasRef$new()
         self$tipo.personal.ref <- CYTARTipoPersonalRef$new()
         self$categoria.conicet.ref <- CYTARCategoriaConicetRef$new()
         self$disciplinas.ref$consolidate()
         self$tipo.personal.ref$consolidate()
         self$categoria.conicet.ref$consolidate()
         self$configured <- TRUE
      }
   },
   checkConsolidatedFields = function(fields){

   },
   consolidate = function(){
     self$configure()
     self$loadData()
     self.debug <<- self
     self$disciplinas.ref$data$disciplina_id
     disciplina.experticia <- self$disciplinas.ref$data
     names(disciplina.experticia) <- gsub("disciplina_", "", names(disciplina.experticia))
     names(disciplina.experticia) <- paste("disciplina_experticia_", names(disciplina.experticia), sep = "")
     self$data %<>% left_join(disciplina.experticia, by = "disciplina_experticia_id")
    names(self$data)
     self$data %<>% left_join(self$tipo.personal.ref$data, by = "tipo_personal_id")
     self$data %<>% left_join(self$categoria.conicet.ref$data, by = "categoria_conicet_id")


     self$categorias.summary <- self$data %>%
        group_by(categoria_conicet_descripcion, tipo_personal_descripcion) %>%
        summarize(n = n()) %>% arrange(-n)
     names(self$data)
     self$data
   }))





#' CYTARPersonasAnioDownloader
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @import testthat
#' @export
CYTARPersonasAnioDownloader <- R6Class("CYTARPersonasAnioDownloader",
   public = list(
     personas.year.url = NA,
     initialize = function(){
       self$personas.year.url <- list()
       self
     },
     configure = function(){
       self$personas.year.url[["2011"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/06ae9728-c376-47bd-9c41-fbdca68707c6/resource/11dca5bb-9a5f-4da5-b040-28957126be18/download/personas_2011.csv"
       self$personas.year.url[["2012"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/06ae9728-c376-47bd-9c41-fbdca68707c6/resource/5d49a616-2fc1-4270-8b09-73f1f5cdd335/download/personas_2012.csv"
       self$personas.year.url[["2013"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/06ae9728-c376-47bd-9c41-fbdca68707c6/resource/0fb38a7e-829b-4128-b318-4affd51c022c/download/personas_2013.csv"
       self$personas.year.url[["2014"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/06ae9728-c376-47bd-9c41-fbdca68707c6/resource/0c8dfedc-a2b5-4c0a-8e78-eed5fe90025f/download/personas_2014.csv"
       self$personas.year.url[["2015"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/06ae9728-c376-47bd-9c41-fbdca68707c6/resource/b5c212d2-104f-426c-95d0-25ac5bf819d8/download/personas_2015.csv"
       self$personas.year.url[["2016"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/06ae9728-c376-47bd-9c41-fbdca68707c6/resource/2fbdbf08-4de0-4a1b-92d5-d16751757ab8/download/personas_2016.csv"
       self$personas.year.url[["2017"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/06ae9728-c376-47bd-9c41-fbdca68707c6/resource/ff318872-775a-4403-bff5-a1c5cdeb85ea/download/personas_2017.csv"
       self$personas.year.url[["2018"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/06ae9728-c376-47bd-9c41-fbdca68707c6/resource/7b07fb44-64c3-4902-ab73-f59d4ed8a2f5/download/personas_2018.csv"
     },
     generatePersonasYear = function(year){
       ret <- NULL
       year <- as.character(year)
       if (!year %in% names(self$personas.year.url)){
         stop(paste("Año", year, "sin información disponible sobre personas CYTAR"))
       }
       else{
         ret <- CYTARPersonasAnio$new(year, self$personas.year.url[[year]])
         ret$consolidate()
       }
       ret
     }
     ))


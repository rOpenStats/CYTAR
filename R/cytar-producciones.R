
#' CYTARProduccionYear
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @import testthat
#' @export
CYTARProduccionYear <- R6Class("CYTARProduccionYear",
  inherit = CYTARDatasource,
  public = list(
   publication.keywords = NULL,
   initialize = function(data.url, year){
    super$initialize(data.url      = data.url,
                     data.filename = paste("producciones_", year, ".csv", sep =""),
                     col.types     = cols(
                      producto_id = col_integer(),
                      tipo_produccion_id = col_integer(),
                      idioma_id = col_integer(),
                      anio_publica = col_integer(),
                      titulo = col_character(),
                      resumen = col_character(),
                      palabras_clave = col_character()
                     )
                     )
    self
   },
   loadData = function(){
    super$loadData()
    self$data$palabras_clave <-
     tolower(self$data$palabras_clave)
    self$data$titulo         <-
     tolower(self$data$titulo)
    self$data$resumen        <-
     tolower(self$data$resumen)
    #self$processKeywords()
    self
   },
   processKeywords = function(){
    logger <- getLogger(self)
    nrow <- nrow(self$data)
    freq.log <- round(nrow/100)
    for (i in seq_len(nrow)){
     current.publication <- self$data[i,]
     current.keywords <- strsplit(current.publication$palabras_clave, split = "\\|")[[1]]
     if (i %% freq.log == 0){
      #debug
      #print(names(current.publication))
      logger$trace("Processing keywords", i = i, nrow = nrow, perc = paste(round(i/n * 100, 2), "%", sep =""),
                   keywords = current.publication$palabras_clave)
     }
     publication.keywords <- NULL
     for (keyword in current.keywords){
      current.publication.keywords <- tibble(publication.id = current.publication$producto_id,
                                                 keyword        = keyword,
                                                 stringsAsFactors = FALSE)
      publication.keywords <- rbind(publication.keywords, current.publication.keywords)
     }
     self$publication.keywords <- rbind(self$publication.keywords, publication.keywords)
    }
   }
   ))


#' current.yearTARPersonas2018
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @import testthat
#' @import lgr
#' @export
CYTARProducciones <- R6Class("CYTARProducciones",
  public = list(
   producciones.years.url = NA,
   producciones.years     = NA,
   logger                 = NA,
   initialize = function(){
    self$producciones.years.url <- list()
    self$producciones.years     <- list()
    self$logger <- genLogger(self)
    self
   },
   configAll = function(){
    self$producciones.years.url[["2011"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/749f0b9d-5f51-4cb1-b2b4-35910fd04439/download/producto_2011.csv"
    self$producciones.years.url[["2012"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/306efae2-ff42-4b2c-abca-cd9651e72376/download/producto_2012.csv"
    self$producciones.years.url[["2013"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/15fdec11-12e4-4a7d-bf33-4b0b6d2943c4/download/producto_2013.csv"
    self$producciones.years.url[["2014"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/190f6b01-6bfc-4a01-8b7c-dc6bdfface52/download/producto_2014.csv"
    self$producciones.years.url[["2015"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/479eb76c-1f4a-409e-9d53-5cb862b6389d/download/producto_2015.csv"
    #self$producciones.years.url[["2016"]] <- ""
    self$producciones.years.url[["2017"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/be663208-1b91-461c-a015-f2b300b484ea/download/producto_2017.csv"
    self$producciones.years.url[["2018"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/439f3533-a2fe-4ef9-8996-977de5192f26/download/producto_2018.csv"
   },
   loadAll = function(){
    logger <- getLogger(self)
    for (current.year in names(self$producciones.years.url)){
      producciones.url       <- self$producciones.years.url[[current.year]]
      producciones.filename  <- paste("producciones_", current.year, ".csv", sep ="")
      producciones.col.types <- cols(
                                  producto_id = col_integer(),
                                  tipo_produccion_id = col_integer(),
                                  idioma_id = col_integer(),
                                  anio_publica = col_integer(),
                                  titulo = col_character(),
                                  resumen = col_character(),
                                  palabras_clave = col_character()
                                 )
      logger$info("Processing producciones",
                  year     = current.year,
                  filename = producciones.filename,
                  url      = producciones.url)
      # self$producciones.years[[current.year]] <- CYTARDatasource$new(data.url = producciones.url,
      #                                                        data.filename = producciones.filename,
      #                                                        col.types = producciones.col.types)
      self$producciones.years[[current.year]] <- CYTARProduccionYear$new(data.url = producciones.url,
                                                                             year = current.year)
      self$producciones.years[[current.year]]$loadData()
    }
    self$data
   }))



#' CYTARProductoYear
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @import testthat
#' @export
CYTARProductoYear <- R6Class("CYTARProductoYear",
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
   processKeywords = function(){
    # This approach is not feasible
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
   },
   getProducciones = function(producciones.id){
    self$data %>% filter(producto_id %in% producciones.id)
   },
   consolidate = function(){
     super$loadData()
     self$data %<>% mutate(titulo = normalizeString(titulo))
     self$data %<>% mutate(palabras_clave = normalizeString(palabras_clave))
     self$data %<>% mutate(resumen = normalizeString(resumen))
     self$data
   }
   ))

#' CYTARProductoAutorYear
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @import testthat
#' @export
CYTARProductoAutorYear <- R6Class("CYTARProductoAutorYear",
  inherit = CYTARDatasource,
  public = list(
   publication.keywords = NULL,
   initialize = function(data.url, year){
    super$initialize(data.url      = data.url,
                     data.filename = paste("producto_autor_", year, ".csv", sep =""),
                     col.types     = cols(
                      producto_id = col_integer(),
                      alias = col_character(),
                      orden = col_integer(),
                      tipo_autor_id = col_integer(),
                      organizacion_id = col_integer(),
                      pais_id = col_integer()
                     )

    )
    self
   },
   consolidate = function(){
     super$loadData()
     self$data %<>% mutate(alias = normalizeString(alias))
     self$data
   }
  ))

#' CYTARProductoPersonaFuncionYear
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @import testthat
#' @export
CYTARProductoPersonaFuncion <- R6Class("CYTARProductoPersonaFuncion",
  inherit = CYTARDatasource,
  public = list(
   publication.keywords = NULL,
   initialize = function(){
    super$initialize(data.url      = "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/7da80541-1b05-4c29-b677-b6373e141415/download/producto_persona_funcion.csv",
                     data.filename = paste("producto_persona_funcion",".csv", sep =""),
                     col.type      = cols(
                      producto_id = col_integer(),
                      persona_id = col_integer(),
                      es_autor = col_character(),
                      es_editor_compilador = col_character(),
                      es_revisor = col_character()
                     )
    )
    self
   },
   consolidate = function(){
     super$loadData()
     self$data
   }

  ))


#' CYTARProducciones
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @import testthat
#' @import lgr
#' @import stringr
#' @export
CYTARProducciones <- R6Class("CYTARProducciones",
  public = list(
   producciones.years.url   = NA,
   producciones.years       = NA,
   producto.autor.years.url = NA,
   producto.autor.years     = NA,
   personas.years           = NA,
   producto.persona.funcion = NA,
   logger                   = NA,
   initialize = function(){
    self$producciones.years.url   <- list()
    self$producciones.years       <- list()
    self$producto.autor.years.url <- list()
    self$producto.autor.years     <- list()
    self$personas.years           <- list()
    self$logger <- genLogger(self)
    self
   },
   configAll = function(years = NULL){
     if("2011" %in% years | is.null(years)){
       self$producciones.years.url[["2011"]]   <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/749f0b9d-5f51-4cb1-b2b4-35910fd04439/download/producto_2011.csv"
       self$producto.autor.years.url[["2011"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/c6c5b25b-1565-4f23-a372-bc7e49172558/download/producto_autor_2011.csv"
     }
     if("2012" %in% years | is.null(years)){
       self$producciones.years.url[["2012"]]   <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/306efae2-ff42-4b2c-abca-cd9651e72376/download/producto_2012.csv"
       self$producto.autor.years.url[["2012"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/00e9b63d-89bc-4df9-8b9d-61c5c03d9343/download/producto_autor_2012.csv"
     }
     if("2013" %in% years | is.null(years)){
       self$producciones.years.url[["2013"]]   <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/15fdec11-12e4-4a7d-bf33-4b0b6d2943c4/download/producto_2013.csv"
       self$producto.autor.years.url[["2013"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/e87622d1-2931-42c3-bccc-929b0c634118/download/producto_autor_2013.csv"
     }
     if("2014" %in% years | is.null(years)){
       self$producciones.years.url[["2014"]]   <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/190f6b01-6bfc-4a01-8b7c-dc6bdfface52/download/producto_2014.csv"
       self$producto.autor.years.url[["2014"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/ed9ec403-e54c-438a-a8f5-89eb5dbb6658/download/producto_autor_2014.csv"
     }
     if("2015" %in% years | is.null(years)){
       self$producciones.years.url[["2015"]]   <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/479eb76c-1f4a-409e-9d53-5cb862b6389d/download/producto_2015.csv"
       self$producto.autor.years.url[["2015"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/5793d777-49fe-4e4d-b77c-944096582edd/download/producto_autor_2015.csv"
     }
     if("2016" %in% years | is.null(years)){
       #FIXME 2016 el link está oculto y tiene los datos de 2015
       #https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/479eb76c-1f4a-409e-9d53-5cb862b6389d/download/producto_2016.csv
       #self$producciones.years.url[["2016"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/479eb76c-1f4a-409e-9d53-5cb862b6389d/download/producto_2016.csv"
       self$producto.autor.years.url[["2016"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/22758256-4e24-4353-841a-1c080a8b72d4/download/producto_autor_2016.csv"
     }
     if("2017" %in% years | is.null(years)){
       self$producciones.years.url[["2017"]]   <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/be663208-1b91-461c-a015-f2b300b484ea/download/producto_2017.csv"
       self$producto.autor.years.url[["2017"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/a1637ed6-5aff-428d-be49-52121ac64e5a/download/producto_autor_2017.csv"
     }
     if("2018" %in% years | is.null(years)){
       self$producciones.years.url[["2018"]]   <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/439f3533-a2fe-4ef9-8996-977de5192f26/download/producto_2018.csv"
       self$producto.autor.years.url[["2018"]] <- "https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/9a49271f-5d1a-49b6-a678-b1f83ad55f77/download/producto_autor_2018.csv"
     }

     self
   },
   loadAll = function(){
    logger <- getLogger(self)
    personas.anio.downloader <- CYTARPersonasAnioDownloader$new()
    dummy <- personas.anio.downloader$configure()

    for (current.year in sort(names(self$producciones.years.url))){
      producciones.url       <- self$producciones.years.url[[current.year]]
      producto.autor.url     <- self$producto.autor.years.url[[current.year]]

      logger$info("Processing producciones",
                  year     = current.year,
                  url      = producciones.url)
      # self$producciones.years[[current.year]] <- CYTARDatasource$new(data.url = producciones.url,
      #                                                        data.filename = producciones.filename,
      #                                                        col.types = producciones.col.types)
      self$producciones.years[[current.year]] <- CYTARProductoYear$new(data.url = producciones.url,
                                                                             year = current.year)
      self$producciones.years[[current.year]]$consolidate()

      self$producto.autor.years[[current.year]] <- CYTARProductoAutorYear$new(data.url = producto.autor.url,
                                                                       year = current.year)
      self$producto.autor.years[[current.year]]$consolidate()

      self$personas.years[[current.year]] <-personas.anio.downloader$generatePersonasYear(current.year)

    }
    self$producto.persona.funcion <- CYTARProductoPersonaFuncion$new()
    self$producto.persona.funcion$consolidate()
   },
   getProduccionesPersonas = function(personas.df, add.persona.info = TRUE){
     logger <- getLogger(self)
     stopifnot(inherits(personas.df, "data.frame"))
     productos.personas.selected <- self$producto.persona.funcion$data %>% filter(persona_id %in% personas.df$persona_id)
     ret <- NULL
     for (current.year in names(self$producciones.years)){
      producciones.current.year <- self$producciones.years[[current.year]]
      producciones.current <- producciones.current.year$getProducciones(producciones.id = productos.personas.selected$producto_id)
      logger$info("Searching", current.year =  current.year,
                  found = nrow(producciones.current))
      ret <- rbind(ret, producciones.current)
     }
     if (add.persona.info){
      ret.personas <- personas.df %>% left_join(productos.personas.selected, by = "persona_id")
      ret.personas %<>% left_join(ret, by = "producto_id")
      ret.personas %<>% arrange(persona_id, anio_publica, producto_id)
      ret <- ret.personas
     }
     ret
   },
   getPersonasArea = function(producciones.df){
     logger <- getLogger(self)
     stopifnot("producto_id" %in% names(producciones.df))
     stopifnot("anio_publica" %in% names(producciones.df))
     producciones.join.df <- producciones.df %>% select(producto_id, anio_publica)
     productos.personas.selected <- self$producto.persona.funcion$data %>% filter(producto_id %in% producciones.df$producto_id)
     phase.1.rows <- nrow(productos.personas.selected)
     productos.personas.selected %<>% inner_join(producciones.join.df, by = "producto_id")
     phase.2.rows <- nrow(productos.personas.selected)
     if (phase.2.rows < phase.1.rows){
       logger$info("Lost rows when joining productos personas",
                   phase.1 = phase.1.rows, phase.2 = phase.2.rows)
     }
     all.years <- sort(unique(productos.personas.selected$anio_publica))
     ret <- NULL
     for (current.year in all.years){
       current.year <- as.character(current.year)
       if (current.year %in% names(self$personas.years)){
         personas.year <- self$personas.years[[current.year]]$data
         productos.personas.year <- productos.personas.selected %>% inner_join(personas.year,
                                            by = c("persona_id", "anio_publica" = "anio"))
         logger$info("Recovering personas from", year = current.year, nrow = nrow(productos.personas.year))
         ret <- rbind(ret, productos.personas.year)
       }
     }
     phase.3.rows <- nrow(ret)
     if (phase.3.rows < phase.2.rows){
       logger$info("Lost rows when joining personas anio",
                   phase.2 = phase.2.rows, phase.3 = phase.3.rows)
     }
     else{
       logger$info("Retrieved author information for",
                   personas = phase.3.rows)
     }
     ret %<>% arrange(persona_id, anio_publica, producto_id)
     ret
   },
   search = function(regexp,
                     search.fields = c("palabras_clave", "resumen", "titulo"),
                     years = NULL,
                     negate = FALSE){
     logger <- getLogger(self)
     logger$info("Searching", regexp =  regexp,
                 search.fields = paste(search.fields, collapse = ", "))
     ret <- NULL
     all.years <- names(self$producciones.years)
     if (!is.null(years)){
       all.years <- intersect(all.years, years)
     }
     for (current.year in sort(all.years)){
       producciones.current.year <- self$producciones.years[[current.year]]
       #debug
       rows.all.cols <- NULL
       search.fields <- intersect(search.fields, names(producciones.current.year$data))
       producciones.detected <- producciones.current.year$data %>%
         filter_at(vars(search.fields),
         any_vars(str_detect(., pattern = regexp, negate=negate))                                           )
       logger$info("Searching", current.year =  current.year,
                   found = nrow(producciones.detected))
       ret <- rbind(ret, producciones.detected)
     }
     logger$info("Retrieved publications for",
                 publications = nrow(ret))

     ret
   }
  ))


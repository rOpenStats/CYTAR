
<!-- README.md is generated from README.Rmd. Please edit that file -->

CYTAR
=====

A package for analysing Argentina’s Science and technology system (CYT)

<!-- . -->

Package
=======

How to get started (Development version)
========================================

Install the R package using the following commands on the R console:

    # install.packages("devtools")
    devtools::install()

How to use it
=============

First add variable with your preferred configurations in `~/.Renviron`.

    CYTAR_data_dir = "~/.R/CYTAR/"

    library(CYTAR)
    #> Warning: replacing previous import 'magrittr::equals' by 'testthat::equals' when
    #> loading 'CYTAR'
    #> Warning: replacing previous import 'magrittr::not' by 'testthat::not' when
    #> loading 'CYTAR'
    #> Warning: replacing previous import 'magrittr::is_less_than' by
    #> 'testthat::is_less_than' when loading 'CYTAR'
    #> Warning: replacing previous import 'dplyr::matches' by 'testthat::matches' when
    #> loading 'CYTAR'
    library(ggplot2)
    library(lgr)
    #> 
    #> Attaching package: 'lgr'
    #> The following object is masked from 'package:ggplot2':
    #> 
    #>     Layout

CYTAR analytics over people and researchs
=========================================

opendata From Ministerio de Ciencia de la Nación Argentina

    log.dir <- file.path(getEnv("data_dir"), "logs")
    dir.create(log.dir, recursive = TRUE, showWarnings = FALSE)
    log.file <- file.path(log.dir, "cytar.log")
    lgr::get_logger("root")$add_appender(AppenderFile$new(log.file))
    lgr::threshold("info", lgr::get_logger("root"))
    lgr::threshold("info", lgr::get_logger("CYTARPersonal"))


    personas <- CYTARPersonas$new()
    self <- personas
    personas$loadData()
    #> Warning: 3 parsing failures.
    #>    row        col  expected             actual                       file
    #> 184049 NA         6 columns 3 columns          '~/.R/CYTAR//personas.csv'
    #> 184050 persona_id a double   SANCHEZ VILLAGRAN '~/.R/CYTAR//personas.csv'
    #> 184050 NA         6 columns 4 columns          '~/.R/CYTAR//personas.csv'
    #> # A tibble: 185,618 x 6
    #>    persona_id nombre           apellido      sexo_id  edad cvar_ultimo_acceso
    #>         <dbl> <chr>            <chr>           <dbl> <dbl> <date>            
    #>  1          1 JUAN PABLO       SOTO                2    44 2017-11-29        
    #>  2          2 SILVINA          GONZALEZ            1    36 2012-02-06        
    #>  3          3 DIEGO FERNANDO   ASENSIO             2    46 2018-09-20        
    #>  4          4 MARÍA VICTORIA   TIGNINO             1    37 2019-04-24        
    #>  5          5 CLAUDIA LEDA     MATTEO              1    55 2018-09-02        
    #>  6          6 EDUARDO          SPOTORNO            2    51 2011-11-07        
    #>  7          7 PATRICIO LEANDRO ACOSTA              2    38 2018-09-05        
    #>  8          8 EDUARDO AUGUSTO  WAGENER SEGUÍ       2    70 2013-08-28        
    #>  9          9 ANDRES MARIANO   RUIZ                2    68 2016-09-05        
    #> 10         10 SERGIO NESTOR    SANTILLANA          2    59 2019-06-24        
    #> # … with 185,608 more rows
    nrow(personas$data)
    #> [1] 185618


    personas.2018 <- CYTARPersonas2018$new()
    self <- personas.2018
    personas.2018$loadData()
    #> # A tibble: 68,552 x 21
    #>    persona_id  anio sexo_id  edad maximo_grado_ac… disciplina_maxi…
    #>         <int> <int>   <int> <int>            <int>            <int>
    #>  1          1  2018       2    43               -1               -1
    #>  2          5  2018       1    55                1              255
    #>  3          7  2018       2    37                1              158
    #>  4         10  2018       2    58                5              248
    #>  5         11  2018       1    46                2              223
    #>  6         12  2018       2    55                1               58
    #>  7         13  2018       2    48                3              281
    #>  8         15  2018       1    53                1              258
    #>  9         17  2018       2    60                2              281
    #> 10         19  2018       2    59                1              255
    #> # … with 68,542 more rows, and 15 more variables:
    #> #   disciplina_titulo_grado_id <int>, disciplina_experticia_id <int>,
    #> #   tipo_personal_id <int>, producciones_ult_anio <int>,
    #> #   producciones_ult_2_anios <int>, producciones_ult_3_anios <int>,
    #> #   producciones_ult_4_anios <int>, institucion_trabajo_id <int>,
    #> #   seniority_level <chr>, categoria_conicet_id <int>,
    #> #   categoria_incentivos <int>, max_dedicacion_horaria_docente_id <int>,
    #> #   institucion_cargo_docente_id <int>, clase_cargo_docente_id <int>,
    #> #   tipo_condicion_docente_id <int>
    nrow(personas.2018$data)
    #> [1] 68552
    personas.2018$consolidate()
    #> Warning: 3 parsing failures.
    #>    row        col  expected             actual                       file
    #> 184049 NA         6 columns 3 columns          '~/.R/CYTAR//personas.csv'
    #> 184050 persona_id a double   SANCHEZ VILLAGRAN '~/.R/CYTAR//personas.csv'
    #> 184050 NA         6 columns 4 columns          '~/.R/CYTAR//personas.csv'
    #> # A tibble: 68,552 x 21
    #>    persona_id  anio sexo_id  edad maximo_grado_ac… disciplina_maxi…
    #>         <int> <int>   <int> <int>            <int>            <int>
    #>  1          1  2018       2    43               -1               -1
    #>  2          5  2018       1    55                1              255
    #>  3          7  2018       2    37                1              158
    #>  4         10  2018       2    58                5              248
    #>  5         11  2018       1    46                2              223
    #>  6         12  2018       2    55                1               58
    #>  7         13  2018       2    48                3              281
    #>  8         15  2018       1    53                1              258
    #>  9         17  2018       2    60                2              281
    #> 10         19  2018       2    59                1              255
    #> # … with 68,542 more rows, and 15 more variables:
    #> #   disciplina_titulo_grado_id <int>, disciplina_experticia_id <int>,
    #> #   tipo_personal_id <int>, producciones_ult_anio <int>,
    #> #   producciones_ult_2_anios <int>, producciones_ult_3_anios <int>,
    #> #   producciones_ult_4_anios <int>, institucion_trabajo_id <int>,
    #> #   seniority_level <chr>, categoria_conicet_id <int>,
    #> #   categoria_incentivos <int>, max_dedicacion_horaria_docente_id <int>,
    #> #   institucion_cargo_docente_id <int>, clase_cargo_docente_id <int>,
    #> #   tipo_condicion_docente_id <int>
    nrow(personas.2018$consolidated)
    #> [1] 68552
    names(personas.2018$consolidated)
    #>  [1] "persona_id"                          
    #>  [2] "anio"                                
    #>  [3] "sexo_id"                             
    #>  [4] "edad"                                
    #>  [5] "maximo_grado_academico_id"           
    #>  [6] "disciplina_maximo_grado_academico_id"
    #>  [7] "disciplina_titulo_grado_id"          
    #>  [8] "disciplina_experticia_id"            
    #>  [9] "tipo_personal_id"                    
    #> [10] "producciones_ult_anio"               
    #> [11] "producciones_ult_2_anios"            
    #> [12] "producciones_ult_3_anios"            
    #> [13] "producciones_ult_4_anios"            
    #> [14] "institucion_trabajo_id"              
    #> [15] "seniority_level"                     
    #> [16] "categoria_conicet_id"                
    #> [17] "categoria_incentivos"                
    #> [18] "max_dedicacion_horaria_docente_id"   
    #> [19] "institucion_cargo_docente_id"        
    #> [20] "clase_cargo_docente_id"              
    #> [21] "tipo_condicion_docente_id"           
    #> [22] "nombre"                              
    #> [23] "apellido"                            
    #> [24] "cvar_ultimo_acceso"

    library(dplyr)
    #> 
    #> Attaching package: 'dplyr'
    #> The following objects are masked from 'package:stats':
    #> 
    #>     filter, lag
    #> The following objects are masked from 'package:base':
    #> 
    #>     intersect, setdiff, setequal, union
    library(readr)

    producciones <- CYTARProducciones$new()
    self <- producciones
    producciones$configAll()
    #> <CYTARProducciones>
    #>   Public:
    #>     clone: function (deep = FALSE) 
    #>     configAll: function () 
    #>     getProduccionesPersonas: function (personas.df, add.persona.info = TRUE) 
    #>     initialize: function () 
    #>     loadAll: function () 
    #>     logger: Logger, Filterable, R6
    #>     producciones.years: list
    #>     producciones.years.url: list
    #>     producto.autor.years: list
    #>     producto.autor.years.url: list
    #>     producto.persona.funcion: NA
    producciones$loadAll()
    #> INFO  [17:43:08.337] Processing producciones {year: 2011, url: https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/749f0b9d-5f51-4cb1-b2b4-35..}
    #> Warning: 6 parsing failures.
    #>    row         col   expected            actual                                  file
    #>  51116 NA          6 columns  2 columns         '~/.R/CYTAR//producto_autor_2011.csv'
    #>  51117 producto_id an integer GORDON, ARIEL     '~/.R/CYTAR//producto_autor_2011.csv'
    #>  51117 NA          6 columns  5 columns         '~/.R/CYTAR//producto_autor_2011.csv'
    #> 113183 NA          6 columns  2 columns         '~/.R/CYTAR//producto_autor_2011.csv'
    #> 113184 producto_id an integer JOSÉ A. MAIZTEGUI '~/.R/CYTAR//producto_autor_2011.csv'
    #> ...... ........... .......... ................. .....................................
    #> See problems(...) for more details.
    #> INFO  [17:43:12.324] Processing producciones {year: 2012, url: https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/306efae2-ff42-4b2c-abca-cd..}
    #> INFO  [17:43:16.218] Processing producciones {year: 2013, url: https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/15fdec11-12e4-4a7d-bf33-4b..}
    #> INFO  [17:43:20.047] Processing producciones {year: 2014, url: https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/190f6b01-6bfc-4a01-8b7c-dc..}
    #> INFO  [17:43:23.700] Processing producciones {year: 2015, url: https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/479eb76c-1f4a-409e-9d53-5c..}
    #> INFO  [17:43:27.203] Processing producciones {year: 2017, url: https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/be663208-1b91-461c-a015-f2..}
    #> INFO  [17:43:28.735] Processing producciones {year: 2018, url: https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6c8-89a32d61329f/resource/439f3533-a2fe-4ef9-8996-97..}
    #> NULL
    names(producciones$producciones.years)
    #> [1] "2011" "2012" "2013" "2014" "2015" "2017" "2018"

    personas.selected <- personas$data %>% filter(grepl("kornblihtt", apellido, ignore.case = TRUE))
    personas.selected
    #> # A tibble: 3 x 6
    #>   persona_id nombre          apellido   sexo_id  edad cvar_ultimo_acceso
    #>        <dbl> <chr>           <chr>        <dbl> <dbl> <date>            
    #> 1      17759 ALBERTO RODOLFO KORNBLIHTT       2    65 2019-03-18        
    #> 2      23135 JUAN            KORNBLIHTT       2    39 2018-09-07        
    #> 3      26145 LAURA INÉS      KORNBLIHTT       1    65 2017-03-21
    producciones.personas <- producciones$getProduccionesPersonas(personas.df = personas.selected)
    #> INFO  [17:43:32.912] Searching {current.year: 2011, found: 10}
    #> INFO  [17:43:32.927] Searching {current.year: 2012, found: 5}
    #> INFO  [17:43:32.941] Searching {current.year: 2013, found: 11}
    #> INFO  [17:43:32.952] Searching {current.year: 2014, found: 11}
    #> INFO  [17:43:32.964] Searching {current.year: 2015, found: 10}
    #> INFO  [17:43:33.000] Searching {current.year: 2017, found: 3}
    #> INFO  [17:43:33.011] Searching {current.year: 2018, found: 0}

    write_csv(producciones.personas, file = file.path(getDataDir(), "producciones_kornblihtt.csv"))

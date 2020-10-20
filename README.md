
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

    producciones <- CYTARProducciones$new()
    self <- producciones
    producciones$configAll()
    producciones$loadAll()
    #> INFO  [14:03:38.102] Processing producciones {year: 2011, filename: producciones_2011.csv, url: https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6..}
    #> INFO  [14:03:39.494] Processing producciones {year: 2012, filename: producciones_2012.csv, url: https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6..}
    #> INFO  [14:03:41.264] Processing producciones {year: 2013, filename: producciones_2013.csv, url: https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6..}
    #> INFO  [14:03:42.779] Processing producciones {year: 2014, filename: producciones_2014.csv, url: https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6..}
    #> INFO  [14:03:43.979] Processing producciones {year: 2015, filename: producciones_2015.csv, url: https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6..}
    #> INFO  [14:03:44.832] Processing producciones {year: 2017, filename: producciones_2017.csv, url: https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6..}
    #> INFO  [14:03:45.822] Processing producciones {year: 2018, filename: producciones_2018.csv, url: https://datasets.datos.mincyt.gob.ar/dataset/4f823995-1a78-4f43-b6..}
    #> NULL

#' getEnv
#' @author kenarab
#' @export
getEnv <- function(variable.name, package.prefix = getPackagePrefix(),  fail.on.empty = TRUE, env.file = "~/.Renviron", call.counter = 0){
 prefixed.variable.name <- paste(package.prefix, variable.name, sep ="")
 ret <- Sys.getenv(prefixed.variable.name)
 if (nchar(ret) == 0){
  if (call.counter == 0){
   readRenviron(env.file)
   ret <- getEnv(variable.name = variable.name, package.prefix = package.prefix,
                 fail.on.empty = fail.on.empty, env.file = env.file,
                 call.counter = call.counter + 1)
  }
  else{
   stop(paste("Must configure variable", prefixed.variable.name, " in", env.file))
  }

 }
 ret
}

#' getPackagePrefix
#' @author kenarab
#' @export
getPackagePrefix <- function(){
 "CYTAR_"
}


#' genLogger
#' @author kenarab
#' @export
genLogger <- function(r6.object){
  lgr::get_logger(class(r6.object)[[1]])
}

#' getLogger
#' @import lgr
#' @author kenarab
#' @export
getLogger <- function(r6.object){
  #TODO check if not a better solution
  ret <- r6.object$logger
  if (is.null(ret)){
    class <- class(r6.object)[[1]]
    stop(paste("Class", class, "don't seems to have a configured logger"))
  }
  else{
    ret.class <- class(ret)[[1]]
    if (ret.class == "logical"){
      stop(paste("Class", class, "needs to initialize logger: self$logger <- genLogger(self)"))
    }
  }
  ret
}

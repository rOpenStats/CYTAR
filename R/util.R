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

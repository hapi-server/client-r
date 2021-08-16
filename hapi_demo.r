# source("C:/Users/Dan/hapi/hapi.r")
# Get path of demo file.
# RStudio
script_path <- dirname(rstudioapi::getActiveDocumentContext()$path)
# Command line
#script_path <- dirname(print(getSrcDirectory()[1]))

source(paste(script_path, "/hapi.r", sep=""))

servers <- hapi()
print(servers)
  
catalog <- hapi("http://hapi-server.org/servers/TestData2.0/hapi/")
#catalog <- hapi("http://hapi-server.org/servers/SSCWeb/hapi/")
  
for (i in 1:length(catalog$catalog)) {
  print(catalog$catalog[[i]][["id"]])
}
  
info <- hapi("http://hapi-server.org/servers/TestData2.0/hapi/", "dataset1")
for (i in 1:length(info$parameters[[1]])) {
  print(info$parameters[[i]][["name"]])
}
  
server     <- "http://hapi-server.org/servers/TestData2.0/hapi/"
dataset    <- "dataset1"
parameters <- "scalar,scalarstr"
start      <- "1970-01-01Z"
stop       <- "1970-01-01T00:00:11Z"
  
data <- hapi(server, dataset, parameters, start, stop)
data

server     <- "http://hapi-server.org/servers/TestData2.0/hapi/"
dataset    <- "dataset1"
parameters <- "transformmulti"
start      <- "1970-01-01Z"
stop       <- "1970-01-01T00:00:11Z"
  
#meta = hapi(server, dataset, parameters)
  
data <- hapi(server, dataset, parameters, start, stop)

data


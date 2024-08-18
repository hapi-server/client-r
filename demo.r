script_path <- dirname(rstudioapi::getActiveDocumentContext()$path)
source(paste(script_path, "/hapi.r", sep=""))

server     <- "http://hapi-server.org/servers/TestData2.0/hapi/"
dataset    <- "dataset1"
parameters <- ""
start      <- "1970-01-01Z"
stop       <- "1970-01-01T00:00:11Z"

#meta = hapi(server, dataset, parameters)

data <- hapi(server, dataset, parameters, start, stop)

#data
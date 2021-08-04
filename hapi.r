library(RJSONIO)
library("stringr")
#library("rjson")

hapi <- function(...) {
  args = list(...)
  if (length(args) == 0) {
    url = "https://github.com/hapi-server/servers/raw/master/all.txt"
    print(url)
    servers = read.csv(url, header=FALSE)
    return(servers["V1"][[1]])
  }
  if (length(args) == 1) {
    url = paste(args[1], "catalog", sep="")
    print(url)
    catalog = fromJSON(url)
    return(catalog)
  }
  if (length(args) == 2) {
    url = paste(args[1], "info?id=", args[2], sep="")
    print(url)
    info = fromJSON(url)
    return(info)
  }
  if (length(args) == 5) {
    url = paste(args[1], "data?id=", args[2], "&parameters=", args[3], "&time.min=", args[4], "&time.max=", args[5], sep="")
    print(url)
    csv = read.csv(url, header=FALSE)
    
    parameters = unlist(strsplit(paste("Time", args[3], sep=","), ","))

    # Put each column from csv into individual list element
    data = list(csv[, 1])
    for (i in 2:length(parameters)) {
      data <- c(data, list(csv[, i]))
    }    
    # Add names based on request parameters
    # If args[3] = "param1,param2", the following is equivalent to 
    # e.g., names(data) <- c("Time", "param1", "param2")
    names(data) <- c(parameters)

    return(data)
  }
}

servers = hapi()
print(servers)

catalog = hapi("http://hapi-server.org/servers/TestData2.0/hapi/")
#catalog = hapi("http://hapi-server.org/servers/SSCWeb/hapi/")

for (i in 1:length(catalog[[1]])) {
  print(catalog[[1]][[i]]["id"][[1]])
}

info = hapi("http://hapi-server.org/servers/TestData2.0/hapi/", "dataset1")
for (i in 1:length(info["parameters"][[1]])) {
  print(info["parameters"][[1]][[i]][["name"]])
}

server     = "http://hapi-server.org/servers/TestData2.0/hapi/"
dataset    = "dataset1"
parameters = "scalar,scalarstr"
start      = "1970-01-01Z"
stop       = "1970-01-01T00:00:11Z"

data = hapi(server, dataset, parameters, start, stop)
data


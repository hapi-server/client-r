#it is best to not source a file, we should create a package eventually
source("C:/Users/Dan/hapi/hapi.r")

if (FALSE) {
  servers <- hapi()
  print(servers)
  
  catalog <- hapi("http://hapi-server.org/servers/TestData2.0/hapi/")
  #catalog <- hapi("http://hapi-server.org/servers/SSCWeb/hapi/")
  
  for (i in 1:length(catalog$catalog)) {
    print(catalog$catalog[[i]][["id"]])
  }
  
  #This does not work, I cannot not tell what the intended output is
  #I added five options below that print different things
  info <- hapi("http://hapi-server.org/servers/TestData2.0/hapi/", "dataset1")
  for (i in 1:length(info$parameters[[1]])) {
    print(info$parameters[[1]][[i]][["name"]])
  }
  
  #option 1: prints the contents of each item in each list
  info <- hapi("http://hapi-server.org/servers/TestData2.0/hapi/", "dataset1")
  for (i in 1:length(info$parameters[[1]])) {
    print(info$parameters[[1]][[i]])
  }
  
  #option 2: DOES NOT USE FOR LOOP, prints the name value
  info <- hapi("http://hapi-server.org/servers/TestData2.0/hapi/", "dataset1")
  print(info$parameters[[1]]$name)
  
  #option 3: DOES NOT USE FOR LOOP, prints the name value as a list
  info <- hapi("http://hapi-server.org/servers/TestData2.0/hapi/", "dataset1")
  print(info$parameters[[1]][1])  
  
  #option 4: prints each item as a list
  info <- hapi("http://hapi-server.org/servers/TestData2.0/hapi/", "dataset1")
  for (i in 1:length(info$parameters[[1]])) {
    print(info$parameters[[1]][i])
  } 
  
  #option 5: prints the name of each item in the list, DOES NOT USE LOOP
  info <- hapi("http://hapi-server.org/servers/TestData2.0/hapi/", "dataset1")
  names(info$parameters[[1]])
  
  server     <- "http://hapi-server.org/servers/TestData2.0/hapi/"
  dataset    <- "dataset1"
  parameters <- "scalar,scalarstr"
  start      <- "1970-01-01Z"
  stop       <- "1970-01-01T00:00:11Z"
  
  data <- hapi(server, dataset, parameters, start, stop)
  data
}

server     <- "http://hapi-server.org/servers/TestData2.0/hapi/"
dataset    <- "dataset1"
parameters <- "transformmulti"
start      <- "1970-01-01Z"
stop       <- "1970-01-01T00:00:11Z"

#meta = hapi(server, dataset, parameters)

data <- hapi(server, dataset, parameters, start, stop)
data

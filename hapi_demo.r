# TODO: Make this a relative path.
source("/Users/weigel/git/hapi/client-r/hapi.r")

if (FALSE) {
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
}

server     = "http://hapi-server.org/servers/TestData2.0/hapi/"
dataset    = "dataset1"
parameters = "transformmulti"
start      = "1970-01-01Z"
stop       = "1970-01-01T00:00:11Z"

#meta = hapi(server, dataset, parameters)

data = hapi(server, dataset, parameters, start, stop)
data

# Want data['transformmulti'] to be a matrix with dimensions (10,3,3)

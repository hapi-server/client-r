library(RJSONIO)
library("stringr")
library(data.table)
hapi <- function(server = NULL, dataset = NULL, parameters = NULL, start = NULL, stop = NULL) {
  if (is.null(server)) {
    url <- "https://github.com/hapi-server/servers/raw/master/all.txt"
    print(paste("hapi(): Downloading", url, sep=" "))
    servers <- data.table::fread(url, header=FALSE)
    return(servers[[1]])
  }
  if (is.null(dataset)) {
    url <- paste(server, "catalog", sep="")
    print(paste("hapi(): Downloading", url, sep=" "))
    catalog <- fromJSON(url)
    return(catalog)
  }
  if (is.null(parameters)) {
    url <- paste(server, "info?id=", dataset, sep="")
    print(paste("hapi(): Downloading", url, sep=" "))
    info <- fromJSON(url)
    return(info)
  }
  if (is.null(start)) {
    url <- paste(server, "info?id=", dataset, "&parameters=", parameters, sep="")
    print(paste("hapi(): Downloading", url, sep=" "))
    info <- fromJSON(url)
    return(info)
  }
  if (is.null(stop)){
    stop("must enter a stop value")
  }

  meta <- hapi(server, dataset, parameters)

  url <- paste(server, "data?id=", dataset, "&parameters=", parameters, "&time.min=", start, "&time.max=", stop, sep="")
  print(paste("hapi(): Downloading", url, sep=" "))
  csv <- data.table::fread(url)

  parameters <- unlist(strsplit(paste("Time", parameters, sep=","), ","))

  if (FALSE) {
    parameters = vector()
    for (i in 2:length(meta$parameters)) {
      parameters <- append(parameters, getElement(meta$parameters[[i]],"name"))
      print(getElement(meta$parameters[[i]],"name"))
    }
    print(parameters)
  }
  # Put each column from csv into individual list element
  data <- list(csv[, 1])

  # Number of rows (time values)
  Nr <- nrow(data[[1]])

  k = 2
  for (i in 2:length(parameters)) {
    if ("size" %in% names(meta$parameters[[i]])) {
      size <- meta$parameters[[i]]$size
    } else {
      size <- 1
    }

    # TODO: If number of elements in size > 2, raise error
    # and note that this client does not handle.

    # Number of columns of parameter
    Nc <- prod(size)
    print(paste("Extracting columns ", k, "through", (k+Nc-1)), sep="")

    # Convert into a matrix in order to convert into an array 
    data2 <- data.matrix(as.factor(unlist((csv[, k:(k+Nc-1)]))))
    dim(data2) <- c(Nr, Nc)
    if(length(size) == 1){
      data_final <- data2
    }
    else{
      listfinal <- c()
      for(p in 1:Nr){
        currentcol <- 1
        ncolumns <- size[1] * size[2]
        nmat <- Nc/ncolumns
        listmat <- list()
        for(m in 1:nmat){
          dataformat <- data2[p,currentcol:(currentcol + ncolumns - 1)]
          dim(dataformat) <- c(size[2],size[1])
          dataformat <- t(dataformat)
          listmat[[m]] <- dataformat
          currentcol <- currentcol + ncolumns
        }
        matvec <- c()
        for(l in 1:nmat){
          matvec <- append(matvec, listmat[[l]])
        }
        array_cur <- array(matvec, dim = size)
        listfinal[[p]] <- array_cur
      }
      finalvec <- c()
      for(val in 1:Nr){
        finalvec <- append(finalvec, listfinal[[p]])
      }
      size <- append(size, Nr)
      data_final <- array(finalvec, dim = size)
    }
    

    data <- c(data, list(data_final))

    k <- k + Nc

  }
  # Add names based on request parameters
  # If args[3] = "param1,param2", the following is equivalent to 
  # e.g., names(data) <- c("Time", "param1", "param2")
  names(data) <- c(parameters)

  return(data)

}

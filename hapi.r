library(RJSONIO)
library("stringr")

hapi <- function(...) {
  args = list(...)
  if (length(args) == 0) {
    url = "https://github.com/hapi-server/servers/raw/master/all.txt"
    print(paste("hapi(): Downloading", url, sep=" "))
    servers = read.csv(url, header=FALSE)
    return(servers["V1"][[1]])
  }
  if (length(args) == 1) {
    url = paste(args[1], "catalog", sep="")
    print(paste("hapi(): Downloading", url, sep=" "))
    catalog = fromJSON(url)
    return(catalog)
  }
  if (length(args) == 2) {
    url = paste(args[1], "info?id=", args[2], sep="")
    print(paste("hapi(): Downloading", url, sep=" "))
    info = fromJSON(url)
    return(info)
  }
  if (length(args) == 3) {
    url = paste(args[1], "info?id=", args[2], "&parameters=", args[3], sep="")
    print(paste("hapi(): Downloading", url, sep=" "))
    info = fromJSON(url)
    return(info)
  }
  if (length(args) == 5) {
    
    # TODO: Why [[]] needed here?
    meta = hapi(args[[1]], args[[2]], args[[3]])

    url = paste(args[[1]], "data?id=", args[[2]], "&parameters=", args[[3]], "&time.min=", args[4], "&time.max=", args[5], sep="")
    print(paste("hapi(): Downloading", url, sep=" "))
    csv = read.csv(url, header=FALSE)
    
    parameters = unlist(strsplit(paste("Time", args[3], sep=","), ","))
    
    # Put each column from csv into individual list element
    data = list(csv[, 1])
    
    # Number of rows (time values)
    Nr = length(data[[1]])
    
    k = 2
    for (i in 2:length(parameters)) {
      if ("size" %in% names(meta["parameters"][[1]][[i]])) {
        size = meta["parameters"][[1]][[i]][['size']]
      } else {
        size = 1
      }
      
      size = as.integer(size)

      # Number of columns of parameter
      Nc = prod(size)
      
      print(paste("Extracting columns ", k, "through", (k+Nc+1)), sep="")
      data <- c(data, list(csv[, k:(k+Nc-1)]))
      
      if (FALSE) {
        size = array(size)
        
        # Prepend number of rows (number of time values) so that
        # size = array(Nr, Nc[1], Nc[2], ...)
        size = append(size, Nr, 0)
  
        print(paste("Extracting columns ", k, "through", (k+Nc+1)), sep="")

        # Extract columns and re-shape to have shape Nr, Nc[1], Nc[2], ...
        data2 = array(data.matrix(csv[, k:(k+Nc-1)]), size)
        
        # Add to named list (not working properly)
        data <- c(data, data2)
      }
      k = k + Nc

    }
    # Add names based on request parameters
    # If args[3] = "param1,param2", the following is equivalent to 
    # e.g., names(data) <- c("Time", "param1", "param2")
    names(data) <- c(parameters)

    return(data)
  }
}




library(tictoc)
library(purrr)

a <- list(iris, cars, 1:5)
lapply(a, summary)
map(a, summary) # APlicar la función a cada componente de la lista


# Ciclos for
lista_resutados <- vector(mode = "list", length = length(a))

for(i in 1:length(a)){ # for(i in seq_along(a))
  
  lista_resutados[[i]] <-  summary(a[[i]])
}

class(a[[1]])
class(a[1])




datos <- iris[iris$Species != "setosa", c(1, 5)]
table(datos$Species)



trials <- 10000
res <- data.frame()

tic()
trial <- 1
while(trial <= trials) {
  ind <- sample(100, 100, replace=TRUE)
  result1 <- glm(Species ~ Sepal.Length, data = datos[ind,], family =  
                   binomial(logit))
  r <- coefficients(result1)
  res <- rbind(res, r)
  trial <- trial + 1
}

toc()    


trials <- seq(1, 10000)
boot_fx <- function(trial) {
  ind <- sample(100, 100, replace=TRUE)
  result1 <- glm(Species ~ Sepal.Length, data = datos[ind,], family =  
                   binomial(logit))
  r <- coefficients(result1)
  res <- rbind(data.frame(), r) 
}

tic()
results <- lapply(trials, boot_fx)
toc()





library(parallel)
numCores <- detectCores() - 1
numCores


trials <- seq(1, 10000)
boot_fx <- function(trial) {
  ind <- sample(100, 100, replace=TRUE)
  result1 <- glm(Species ~ Sepal.Length, data = datos[ind,], family =  
                   binomial(logit))
  r <- coefficients(result1)
  res <- rbind(data.frame(), r)
}
# Linux o mac
tic()
  results <- mclapply(trials, boot_fx, mc.cores = numCores)
toc()







# Foreach

for (i in 1:3) {
  print(sqrt(i))
}

Correr el programa con foreach tiene un enfoque muy similar:
  
library(foreach)
 foreach (i=1:3) %do% {
  sqrt(i)
}



a <- foreach (i=1:3) %do% {
  sqrt(i)
}
unlist(a)


a <- foreach (i=1:3, .combine = c) %do% {
  sqrt(i)
}
a




foreach soporta un parámetro llamado do paralle que hace uso de todos los procesarores:
  
  
library(foreach)
library(doParallel)

registerDoParallel(numCores)  # use multicore, set to the number of our cores
foreach (i=1:3) %dopar% {
  sqrt(i)
}

registerDoParallel(numCores)  # use multicore, set to the number of our cores
foreach (i=1:3, .combine = c) %dopar% {
  sqrt(i)
}

Veamos el ejemplo del bootstrap:
  
trials <- 10000
tic()
  r <- foreach(i=1:10000, .combine=rbind) %dopar% {
    ind <- sample(100, 100, replace=TRUE)
    result1 <- glm(Species ~ Sepal.Length, data = datos,   
                   family=binomial(logit))
    coefficients(result1)
  }
toc()


tic()
r <- foreach(i=1:10000) %dopar% {
  ind <- sample(100, 100, replace=TRUE)
  result1 <- glm(Species ~ Sepal.Length, data = datos,   
                 family=binomial(logit))
  coefficients(result1)
}
toc()


En contraste con la velocidad si no se paraleliza:
  
tic()  
  r <- foreach(icount(trials), .combine=rbind) %do% {
    ind <- sample(100, 100, replace=TRUE)
    result1 <- glm(Species ~ Sepal.Length, data = datos,   
                   family=binomial(logit))
    coefficients(result1)
  }
toc()  
}



También puede paralelizarse un lapply:
  
  
library(parallel)
trials <- seq(1, 10000)
boot_fx <- function(trial) {
  datos <- iris[iris$Species != "setosa", c(1, 5)]
  ind <- sample(100, 100, replace=TRUE)
  result1 <- glm(Species ~ Sepal.Length, data = datos[ind,], family =  
                   binomial(logit))
  r <- coefficients(result1)
  res <- rbind(data.frame(), r)
}
tic()
  cl <- makeCluster(detectCores()-1)
  results <- parLapply(cl, trials, boot_fx)

toc()  
stopCluster(cl)



# Sacar el rmse 
train <- rsample::initial_split(iris, 0.7)
trials <- seq(1, 10000)

rmse <- function(df) {
  library(magrittr)
  df_train <- df %>% rsample::analysis()
  df_test  <-  df %>% rsample::assessment()
  modelo <- lm(Sepal.Length ~ Petal.Length, data = df_train)
  
  yhat <- predict(modelo, df_test)
  sqrt(mean( (df_test$Sepal.Length -  yhat)^2))
}

lista <- rsample::vfold_cv(data = iris, v = 10)[[1]] 
rmse(lista[[10]])

tic()
lapply(lista, rmse)
toc()

tic()
cl <- makeCluster(detectCores()-1)
results <- parLapply(cl, lista, rmse)
toc()  
stopCluster(cl)





lapply(iris[-5], mean)
is.list(iris)

as.list(iris)

caracter <- function(x){
  x <- as.character(x)
}

b <- lapply(iris[-5], caracter)
b<- as.data.frame(b)


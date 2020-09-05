library(data.table)
library(tictoc)
library(data.table)
library(bit64)
library(stringr)

setwd("/home/jose/Documentos/datos/")
dir()
s11_I <- fread("s11_2019I.txt", sep = "|")

tic()
s11_II <- fread("s11_2019II.txt", sep = "|", encoding = "UTF-8")
toc()

divipola <- fread("divipola.txt" , sep = "|", encoding = "UTF-8")

saber <- rbindlist(list(s11_I, s11_II), use.names = T)

# Dudas del taller
Mejores <- saber[nom_mpio %in% c("BOGOTÁ","CALI", "MEDELLÍN","BARRANQUILLA"),
                    .(ESTU_CONSECUTIVO, PUNT_GLOBAL, nom_mpio),
                    by = nom_mpio][order(-PUNT_GLOBAL), .SD[1:5], by = nom_mpio]
divipola <- fread("divipola.txt" , sep = "|", encoding = "UTF-8")
divipola <- unique(divipola, by = "cod_mpio")
setkey(divipola, cod_mpio)
setkey(saber, COLE_COD_MCPIO_UBICACION)
saber <- saber[divipola, nomatch=0]

p7 <- saber[COLE_COD_MCPIO_UBICACION %in% c(5001, 76001, 8001),
      .(ESTU_CONSECUTIVO, PUNT_MATEMATICAS, COLE_COD_MCPIO_UBICACION),]
p7 <- p7[order(-PUNT_MATEMATICAS),,]
p7 <- p7[,ranking := 1:nrow(.SD), by = list(COLE_COD_MCPIO_UBICACION)][ranking <=5,,]


# Use las pruebas saber consolidadas del año 2019 pero limite las columnas necesarias para este punto. 
# Construya el puntaje global calculando la mediana de las asignaturas abordadas por el estudiante.
# #Posteriormente calcule un ranking de los 100 mejores colegios del país según este puntaje.

asignaturas <- c("PUNT_LECTURA_CRITICA", 
 "PUNT_MATEMATICAS",  "PUNT_C_NATURALES", "PUNT_SOCIALES_CIUDADANAS",  "PUNT_INGLES")

# En R base: la primera parte del calculo de la mediana
df <- saber[,asignaturas,with = F]
saber$PG <- rowMeans(df) # with = F ese es pedazo data.table
saber$PG <- apply(df, 1, FUN = mean ) # with = F ese es pedazo data.table
# apply(df, 2, FUN = mean, na.rm = T )
# Esto es lento
saber$PGMdiana <- apply(df, 1, FUN = median ) # with = F ese es pedazo data.table
# Calculen el coeficiente de variación para cada niño

cv <- function(x){
  100 * sd(x, na.rm = T) / mean(x, na.rm = T)
}
cv(c(3, 4, 60, 100))
# Cada vector va a ser cada fila, por el 1 (por columna si fuera el dos)
saber$CV_PG <- apply(df, 1, FUN = cv ) # with = F ese es pedazo data.table
# which(saber$CV_PG == max(saber$CV_PG, na.rm = T))
# a <- saber[25365,]
#cv(c(0,0,0,0,36))

# Más rapido así:
prueba <- df[, `:=` (PuntajeMediana = median(as.numeric(.SD), na.rm = T)), by = 1:nrow(df)]
# Aun muy
tic()
prueba <-saber[,
                    PtoMed := as.integer(median(c(PUNT_LECTURA_CRITICA, PUNT_MATEMATICAS, PUNT_C_NATURALES, 
                                                  PUNT_SOCIALES_CIUDADANAS, PUNT_INGLES), na.rm = TRUE)),
                    by = ESTU_CONSECUTIVO]
toc()

tic()
prueba <-saber[,
               PtoMed := as.integer(median(.SD, na.rm = TRUE)),
               by = ESTU_CONSECUTIVO, .SDcols=c("PUNT_LECTURA_CRITICA", "PUNT_MATEMATICAS", 
                                                "PUNT_C_NATURALES", 
                                                "PUNT_SOCIALES_CIUDADANAS", "PUNT_INGLES")]
toc()


# 
# dt[, `:=`(AVG= mean(as.numeric(.SD),na.rm=TRUE),MIN = min(.SD, na.rm=TRUE),MAX = max(.SD, na.rm=TRUE),
#           SUM = sum(.SD, na.rm=TRUE)),.SDcols=c(Q1, Q2,Q3,Q4),by=1:nrow(dt)] 

# Luego calcular el promedio del puntaje global (construido con la mediana) por cada colegio
# Luego crear un ranking y filtrar los 100 primeros



# Ejemplos SD
data(iris)
# Objeto debe ser data.table
iris <- as.data.table(iris)

data(iris)
iris <- setDT(iris)

iris[,.SD,]
identical(iris, iris[,.SD,]) # Iguales

iris[,.SD, by = Species]

# Una agrupación para una sola variable que quede en la misma tabla
data(iris)
iris <- setDT(iris)
iris <- iris[,conteo := .N, by =.(Species)]
iris <- iris[,prom_SepalLength := mean(Sepal.Length), by =.(Species)]

setDT(iris)[,conteo := .N, by =.(Species)]
iris 

# No es lo mismo que haer una agregación en donde reduzco a una estadística resumen por cada nivel de la variable agrupamiento
iris[,.(prom_sepalLength = mean(Sepal.Length)),by = .(Species)]

data(iris)
iris2 <- setDT(iris)
iris2 <- iris2[,c("prom_SepalLength", "mediana_SepalLength"):=.(mean(Sepal.Length), median(Sepal.Length)),
     by = .(Species)]

# Parenteisis
list(c(1,2), c(1,4))
as.data.frame(list(c(1,2), c(1,4)))
list(c(1,2), c(1,4), c(1, 2, 5))
#as.data.frame(list(c(1,2), c(1,4), c(1, 2, 5)))
list(c(1,2), iris, matrix(1:4, nco = 2), list(c(1,2), c(3,4)))
# Todo dataframe es una lista!!!!!!!!!!!!!!
as.data.frame(list(c(1,2), c(1,4)))

# lapply hago operaciones para cada componente de la lista
list(c(1,2), c(1,2,5))
lapply(list(c(1,2), c(1,2,5)), length)
lapply(list(c(1,2), c(1,2,5)), sum)
lapply(list(c(1,2), c(1,2,5), 6), function(x)x ^2) # ELevar al cuadrado
#lapply(lista, funcion)
class(mean)
data(iris)
lapply(iris, class)

mifuncion <- function(x){
  if(class(x) == "numeric") res <- mean(x)
  if(class(x) == "character" | class(x) == "factor") res <- table(x)
res
}

lapply(iris, mifuncion)
lapply(iris[-5], mifuncion)

# A veces los resultados de lapply se pueden ensambar en un vector
sapply(iris, length)
sapply(iris, length)
sapply(iris[-5], mifuncion)
#sapply(iris, mifuncion)

mifuncion2 <- function(x){
  cor(x, iris$Sepal.Length)
}
mifuncion2(iris$Petal.Width)

lapply(iris[-5],mifuncion2)
sapply(iris[-5],mifuncion2)

lapply(iris[-5],sum)

lapply(1:5, function(x)x*x)


# All the continuous variables in the dataset

iris2 <- iris2[,c("prom_SepalLength", "mediana_SepalLength"):=.(mean(Sepal.Length), median(Sepal.Length)),
               by = .(Species)]
data(iris)
iris2 <- setDT(iris)
col <- c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")
iris2[,lapply(.SD, median), by = list(Species), .SDcol = col]

iris3 <- setDT(as.data.frame(t(as.matrix(iris[,-5])))) # DEjar solo las columnas numericas
col <- names(iris3)
prueba <- iris3[,lapply(.SD, median),  .SDcol = col]
df_medianas <- setDT(as.data.frame(t(as.matrix(prueba))))
iris <- cbind(iris, df_medianas)


# tic()
# df_puntaje <- saber[,c("PUNT_LECTURA_CRITICA", "PUNT_MATEMATICAS", 
#                        "PUNT_C_NATURALES", 
#                        "PUNT_SOCIALES_CIUDADANAS", "PUNT_INGLES"), with=F]
# 
# pruebadt <- setDT(as.data.frame(t(as.matrix(df_puntaje))))  # paso 1 
# col <- names(pruebadt)  # paso 2
# prueba <- pruebadt[,lapply(.SD, median), , .SDcol = col]  # paso 3
# df_medianas <- setDT(as.data.frame(t(as.matrix(prueba))))  # paso 4
# pruebadt <- cbind(puntoSaberI, df_medianas)   # paso 5  
# toc()


tic()
c1 <- saber[, .(PUNT_LECTURA_CRITICA,PUNT_MATEMATICAS,                              
                PUNT_C_NATURALES,PUNT_SOCIALES_CIUDADANAS,PUNT_INGLES)]
library(matrixStats)
c1[,medianglobal := rowMedians (as.matrix(.SD))]
c1
saber <- cbind(saber, c1)
toc()

tic()
c1 <- saber[, .(PUNT_LECTURA_CRITICA,PUNT_MATEMATICAS,                              
                PUNT_C_NATURALES,PUNT_SOCIALES_CIUDADANAS,PUNT_INGLES)]
library(matrixStats)
c1[,mediaglobal := rowMeans (as.matrix(.SD))]
c1
toc()

  cv <- function(x){
    100 * sd(x, na.rm = T) / mean(x, na.rm = T)
  }
cvPorFila<- function(M){
  apply(M,1,cv)
}
cvPorFila(iris[,-5])

library(matrixStats)

tic()
c1 <- saber[,cv_puntaje := cvPorFila(as.matrix(.SD)),
            .SDcol = c("PUNT_LECTURA_CRITICA","PUNT_MATEMATICAS",                              
                  "PUNT_C_NATURALES","PUNT_SOCIALES_CIUDADANAS","PUNT_INGLES")]

toc()

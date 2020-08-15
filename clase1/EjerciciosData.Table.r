library(data.table)
setwd("C:/Users/Home/Documents/Laboral2020/Konrad Lorenz/BigData/Clase 3")
dir()
s11_2019I <- fread("s11_2019I.txt", sep = "|")
s11_2019II <- fread("s11_2019II.txt", sep = "|")
divipola <-  fread("divipola.txt", sep = "|")
class(s11_2019II)
c1 <- s11_2019II[,list(prom_mat =
                       mean(PUNT_MATEMATICAS)),]
c1 <- s11_2019II[,.(prom_mat =
                         mean(PUNT_MATEMATICAS)),]
c2 <- s11_2019II[,.(prom_mat =
                      mean(PUNT_MATEMATICAS)),
                 by = .(COLE_NATURALEZA, COLE_JORNADA)]

c3 <- s11_2019II[,.(prom_mat =
                      mean(PUNT_MATEMATICAS)),
                 by = .(COLE_NATURALEZA, COLE_JORNADA)]
c3 <- c3[order(-prom_mat),,]

# Punto 4
# intersect(names(divipola), names(s11_2019II))
setkey(divipola, cod_mpio)
setkey(s11_2019II, COLE_COD_MCPIO_UBICACION)

s11_2019II <- divipola[s11_2019II]
str(s11_2019II$cod_mpio)
c4 <- s11_2019II[cod_dpto == 11 | cod_dpto == 25,
                 .(prom_mat =
                      mean(PUNT_MATEMATICAS)),
                 by = .(COLE_NATURALEZA, COLE_JORNADA)]
c4 <- c4[order(-prom_mat),,]

c4 <- s11_2019II[cod_dpto %in% c(11,25),
                 .(prom_mat =
                     mean(PUNT_MATEMATICAS)),
                 by = .(COLE_NATURALEZA, COLE_JORNADA)]
c4 <- c4[order(-prom_mat),,]

# Pegar por debajo las dos tablas:
setkey(divipola, cod_mpio)
setkey(s11_2019I, COLE_COD_MCPIO_UBICACION)
s11_2019I <- divipola[s11_2019I]

c5 <- rbindlist(list(s11_2019I, 
                     s11_2019II), use.names = T)
# 6. Seleccionar el identificador del estudiante, 
# el codigo del municipio donde está el colegio y 
# el puntaje en matemáticas.
c6 <- c5[,.(cod_mpio,ESTU_CONSECUTIVO,
             PUNT_MATEMATICAS),]
#edit(names(divipola))
#c("nom_dpto", "cod_dpto", "nom_mpio", "cod_mpio")

c6 <- c5[,c("cod_mpio","ESTU_CONSECUTIVO",
             "PUNT_MATEMATICAS"),with=F]

library(sqldf)
q <- "SELECT COUNT(*) as 'N'
       FROM divipola"
sqldf(q)


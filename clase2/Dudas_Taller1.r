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

# identificación de duplicados

data.frame(ID = c(45, 34, 23, 45, 2), y = c("M", "M", "F", "M", "F")) -> datos
datos

duplicated(datos$ID)
table(duplicated(datos$ID))

# Cuantos registros sin son parte del grupo de duplicados
duplicated(datos$ID) | duplicated(datos$ID, fromLast = T)
table(duplicated(datos$ID) | duplicated(datos$ID, fromLast = T))


datos[!duplicated(datos$ID),]
# Esto es lo mismo que:
unique(datos, by = "ID")

 # revisar por los dos campos simultaneamente
duplicated(datos, by = c("ID", "y"))
duplicated(datos) # Si no se pone by el revisa por todas las columnas

# Revisar duplicados
table(duplicated(saber$ESTU_CONSECUTIVO))

# Revisar en duplicado
methods(duplicated) # duplicated tiene un método para data.table

# Revisa e identificar duplicados
divipola

table(duplicated(divipola$cod_mpio))

df_duplicados <- divipola[duplicated(divipola$cod_mpio) | 
                             duplicated(divipola$cod_mpio, fromLast = T),]

# Eliminamos Sotarra
divipola <- divipola[!duplicated(divipola$cod_mpio),]

# Equivalentemente
divipola <- fread("divipola.txt" , sep = "|", encoding = "UTF-8")
divipola <- unique(divipola, by = "cod_mpio")

set.seed(12345)
datos <- as.data.table(data.frame(ID = c(1,3,4,5,1,2,3,1,2,3,4,1), y = runif(12),
                                  stringsAsFactors = F))
datos2 <- datos[!duplicated(datos$ID),]
class(datos)
datos2a <- unique(datos, by = "ID")


# Dudas taller 


# 6. Use las pruebas saber consolidadas del año 2019 pero limite las columnas
# necesarias para este punto. Lleve a cabo el cálculo del 
# promedio de los estudiantes en matemáticas para las ciudades de Cali, Medellín y Barranquilla 
# de los colegios públicos y de más de 30 estudiantes. 

# No usar table, usar esto:
# table(saber$COLE_NATURALEZA) # NO USAR
saber[,.N, by = .(COLE_NATURALEZA)]
# data.table::uniqueN(x = saber, by = "COLE_NATURALEZA")
unique(saber$COLE_NATURALEZA) # Usa el método de la clase data.table
# methods("unique")
unique(saber$COLE_COD_MCPIO_UBICACION) # Usa el método de la clase data.table

a <- c(5001, 8001, 76001)
stringr::str_pad(a, width = 5, side = "left", pad = "0")

#rm(prue) # Remueve colector
#gc(reset = T)

saber <- saber[,COLE_COD_MCPIO_UBICACION := 
                      stringr::str_pad(COLE_COD_MCPIO_UBICACION, width = 5, 
                                       side = "left", pad = "0"),]

unique(saber$COLE_COD_DANE_ESTABLECIMIENTO) # Usa el método de la clase data.table

# Previo a esto verificar duplicados

# [operaciones por fila, operaciones por columna, agrupaciones]
# Operaciones por fila: filtros y ordenamientos
# Operaciones por columna: Creación de nuevas variables y estadísticas resumenes (promedio, contar, desv, est,..)
# Agrupaciones: una o más variables para los cuales deseo calcular las estadísticas resumenes

c1 <- saber[COLE_NATURALEZA == "OFICIAL"  &
              COLE_COD_MCPIO_UBICACION %in% c("05001", "76001", "08001"),
            .(Num_est = .N, prom_mat = mean(PUNT_MATEMATICAS)), 
            by = COLE_COD_DANE_ESTABLECIMIENTO][Num_est > 30,
          prom_mat := round(prom_mat,1),][order(-prom_mat),,]
c1 <- c1[,ranking := 1:nrow(c1),][ranking <= 5,,]


# Ejemplo dcast
?data.table::dcast
saber$ 
ejemplodcast <-  data.table::dcast(data = saber, COLE_JORNADA ~ COLE_NATURALEZA, 
                                 fun.aggregate = mean,
      value.var = "PUNT_MATEMATICAS")
colnames(ejemplodcast)[c(2,3)] <- paste0("TIPO ", colnames(ejemplodcast)[c(2,3)]) 

cv <- function(x){
 100 * sd(x, na.rm = T) / mean(x, na.rm = T) 
}

ejemplodcast <-  data.table::dcast(data = saber, 
                COLE_NOMBRE_ESTABLECIMIENTO + COLE_JORNADA ~ COLE_NATURALEZA, 
                                   fun.aggregate = cv,
                                   value.var = "PUNT_MATEMATICAS")
colnames(ejemplodcast)[c(3,4)] <- paste0("TIPO ", colnames(ejemplodcast)[c(3,4)]) 


# Ejemplo de  juguete con melt
data(iris)
iris$ID <- 1:nrow(iris)
# edit(names(iris)) # revisar y cerrar al final
iris_larga <- melt(data = iris, id.vars = c("ID", "Species"),
     measure.vars = c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"), 
      variable.name = "Especie", value.name = "Medición")

#Punto 1
#names(saber) %>% edit()df_p1 <- df_p1[order(ESTU_CONSECUTIVO),,]

df_p1 <- data.table::melt(data = saber, id.vars = c("ESTU_CONSECUTIVO"),
                   measure.vars = c('PUNT_LECTURA_CRITICA','PUNT_MATEMATICAS',
                                    'PUNT_C_NATURALES','PUNT_SOCIALES_CIUDADANAS','PUNT_INGLES'), 
                   variable.name = "Asignatura", value.name = "Puntaje")
df_p1 <- df_p1[order(ESTU_CONSECUTIVO),,]

#c1 <- c1[ Num_est > 30,,]


  # Script para aplicar la metodolog�a de homogenizaci�n de 
  # Series de tiempo mensuales de precipitaci�n 
  # Taller Atmoscol2023
  # Armenia, Quind�o, Colombia (Sur Am�rica)

  # Regi�n Alto Cauca 
  # Estaci�n 26075010 
  # Nombre: Palmira ICA 
  # Serie de tiempo precipitaci�n mensual
  # Fuente: IDEAM 
  # Per�odo: 01-1930 a 11-2021

  # Grupo GIIAUD - Ingenier�a Ambiental
  # Universidad Distrital Francisco Jos� de Caldas
  # Profesor N�stor Ricardo Bernal Su�rez (nrbernals@udistrital.edu.co) 
  # Grupo Tiempo, Clima y Sociedad - Departamento de Geograf�a
  # Universidad Nacional de Colombia
  # Profesor Jos� Daniel Pab�n Caicedo (jdpabonc@unal.edu.co)
  # Versi�n R Studio 3.6
  # Octubre de 2023


  # Libreria para tratamiento de series de tiempo
  install.packages("tidyverse",dependencies = TRUE)
  install.packages("lubridate",dependencies = TRUE)
  library(tidyverse)
  library(lubridate)
  install.packages("TSstudio",dependencies = TRUE)
  library(TSstudio)
  
  # Lectura de datos estaci�n 
  
  Esta_26075010 <- read.delim("~/Reg_9_Alto_Cauca/26075010.txt", header=FALSE)
  dimnames(Esta_26075010)[[2]] <- c("fecha", "preci_IDEAM")
  View(Esta_26075010)
  Esta_26075010
  
  # lectura fecha
  
  fecha_1 <- read.delim("~/Reg_9_Alto_Cauca/fecha5.txt", header=FALSE)
  dimnames(fecha_1)[[2]] <- c("fecha", "secuencia", "ano", "mes")
  fecha_1
  
   # unir dos archivos 1981 a 2019
  
  MergedDataset_1 <- merge(fecha_1, Esta_26075010, all=TRUE, by="fecha")
  MergedDataset_1
  
  # ordenar por fecha 1981 a 2019
  
  Esta_26075010_2 <- with(MergedDataset_1, MergedDataset_1[order(secuencia, decreasing=FALSE), ])
  Esta_26075010_2
  
  # subconjunto datos secuencia > 0
  
  Esta_26075010_3 <- subset(Esta_26075010_2, secuencia >= 0)
  Esta_26075010_3
  
  # Exportar datos a csv y xlsx 1981 a 2019
  
  write.csv(Esta_26075010_3,"Esta_26075010_fecha_1.csv")
  library(xlsx)
  write.xlsx(Esta_26075010_3,"Esta_26075010_fecha_1.xlsx")
  
  # Lectura datos GPCC
  
  GPCC_26075010 <- read.delim("~/Reg_9_Alto_Cauca/GPCC/26075050_GPCC_spre.txt", header=FALSE)
  View(GPCC_26075010)
  GPCC_26075010
  
  dimnames(GPCC_26075010)[[2]] <- c("fecha", "preci_GPCC")
  GPCC_26075010
  
  # crear dataframe para datos GPCC
  
  GPCC_26075010_1 = data.frame(GPCC_26075010$fecha, GPCC_26075010$preci_GPCC)
  GPCC_26075010_1 
  
  # crear dataframe para datos IDEAM 
  
  Esta_26075010_1 = data.frame(Esta_26075010_3$fecha, Esta_26075010_3$preci_IDEAM)
  Esta_26075010_1 
  
    # verificaci�n lectura de datos IDEAM 
  
  head(Esta_26075010_3)
  
  # verificaci�n lectura de datos GPCC
  
  head(GPCC_26075010)
  
  # Gr�ficos IDEAM
  
  Precipi_IDEAM = data.frame(Esta_26075010_3$preci_IDEAM)
  
  Precipi_IDEAM
  
  Precipi_IDEAM <- ts(Precipi_IDEAM, freq=12, start=c(1981,1), end=c(2019,12))
  Precipi_IDEAM
  
  plot(Precipi_IDEAM)
  
  # Gr�ficos GPCC
  
  Precipi_GPCC = data.frame(GPCC_26075010$preci_GPCC)
  
  Precipi_GPCC
  
  Precipi_GPCC <- ts(Precipi_GPCC, freq=12, start=c(1981,1))
  Precipi_GPCC
  
  plot(Precipi_GPCC)
  
  
  # gr�ficos precipitaci�n IDEAM y GPCC
  
  plot(Precipi_IDEAM, Precipi_GPCC)
  
  par(mfrow = c(1,2))
  plot(Precipi_IDEAM)
  plot(Precipi_GPCC)
  
  # unir archivos IDEAM y GPCC
  
  MergedDataset_IDEAM_GPCC <- merge(GPCC_26075010, Esta_26075010_3, all=TRUE, by="fecha")
  MergedDataset_IDEAM_GPCC
  
  # ordenar por fecha 
  
  IDEAM_GPCC_26075010 <- with(MergedDataset_IDEAM_GPCC, MergedDataset_IDEAM_GPCC[order(secuencia, decreasing=FALSE), ])
  IDEAM_GPCC_26075010
  
  # correlaci�n series IDEAM vs. GPCC
  
  install.packages("COR", dep = TRUE)
  library(COR)
  cor(x=MergedDataset_IDEAM_GPCC$preci_IDEAM, y=MergedDataset_IDEAM_GPCC$preci_GPCC, use="pairwise.complete.obs",
      method=c("pearson"))
  
  cor(x=MergedDataset_IDEAM_GPCC$preci_IDEAM, y=MergedDataset_IDEAM_GPCC$preci_GPCC, use="pairwise.complete.obs",
      method=c("spearman"))
  
  cor(x=MergedDataset_IDEAM_GPCC$preci_IDEAM, y=MergedDataset_IDEAM_GPCC$preci_GPCC, use="pairwise.complete.obs",
      method=c("kendall"))
  
  
  # identificaci�n de meses con datos faltantes
  
  IDEAM_GPCC_26075010_1 = data.frame(IDEAM_GPCC_26075010$fecha,IDEAM_GPCC_26075010$preci_IDEAM,IDEAM_GPCC_26075010$preci_GPCC)
  IDEAM_GPCC_26075010_1
  
  # emplear union de bases ordenadas
  which(is.na(IDEAM_GPCC_26075010$preci_IDEAM))
  
  
  # identificaci�n de fechas espec�ficas con dato faltante
  IDEAM_GPCC_26075010_1[369,]
  
  
  # modelo de regresi�n 
  
  mod1 <- lm(MergedDataset_IDEAM_GPCC$preci_IDEAM ~ MergedDataset_IDEAM_GPCC$preci_GPCC + MergedDataset_IDEAM_GPCC$mes, data=IDEAM_GPCC_26075010)
  mod1
  summary(mod1)
  
  # condici�n dato faltante 
  
  install.packages("dplyr", dep = TRUE)
  library(dplyr)
  
  IDEAM_GPCC_26075010_1 = data.frame(IDEAM_GPCC_26075010)
  IDEAM_GPCC_26075010_1
  
  
  IDEAM_GPCC_26075010_1$Preci_est_IDEAM_1 = if_else((IDEAM_GPCC_26075010_1$secuencia >= 73 & IDEAM_GPCC_26075010_1$secuencia <= 132), 
                                                  preci_1 <- IDEAM_GPCC_26075010_1$preci_GPCC, preci_1 <- IDEAM_GPCC_26075010_1$preci_IDEAM)
  
  IDEAM_GPCC_26075010_1$Preci_est_IDEAM = if_else(IDEAM_GPCC_26075010_1$fecha == "01/09/2011", 
                                                  preci_1 <- (-0.602) + 0.979*IDEAM_GPCC_26075010_1$preci_GPCC - 0.795*IDEAM_GPCC_26075010_1$mes, preci_1 <- IDEAM_GPCC_26075010_1$Preci_est_IDEAM_1)
  
  
  IDEAM_GPCC_26075010_2 <- data.frame(IDEAM_GPCC_26075010_1, IDEAM_GPCC_26075010_1$Preci_est_IDEAM)
  IDEAM_GPCC_26075010_2
  View( IDEAM_GPCC_26075010_2)
  
  
  # detecci�n de cambio en el promedio
  
  library(trend)
  pettitt.test(IDEAM_GPCC_26075010_2$Preci_est_IDEAM)
  IDEAM_GPCC_26075010_2[295,]
  IDEAM_GPCC_26075010_2[296,]
  IDEAM_GPCC_26075010_2[297,]
  IDEAM_GPCC_26075010_2[298,]
  IDEAM_GPCC_26075010_2[299,]
  
  
  # Standard Normal Homogeinity Test (SNHT) for Change-Point Detection #
  
  out <- snh.test(IDEAM_GPCC_26075010_2$Preci_est_IDEAM)
  out
  plot(out)
  IDEAM_GPCC_26075010_2[295,]
  IDEAM_GPCC_26075010_2[296,]
  IDEAM_GPCC_26075010_2[297,]
  IDEAM_GPCC_26075010_2[298,]
  IDEAM_GPCC_26075010_2[299,]
  
  
  
  # serie de tiempo precipitaci�n IDEAM per�odo 1981 a 2019
  
  Prec_IDEAM = data.frame(IDEAM_GPCC_26075010_2$Preci_est_IDEAM)
  Prec_IDEAM
  Prec_IDEAM_1 <- ts(Prec_IDEAM, freq=12, start=c(1981,1), end=c(2019,12))
  Prec_IDEAM_1
  
  # serie de tiempo precipitaci�n GPCC per�odo 1981 a 2019
  
  Prec_GPCC = data.frame(IDEAM_GPCC_26075010_2$preci_GPCC)
  Prec_GPCC
  Prec_GPCC_1 <- ts(Prec_GPCC, freq=12, start=c(1981,1), end=c(2019,12))
  Prec_GPCC_1
  
  par(mfrow = c(1,2))
  plot(Prec_IDEAM_1)
  plot(Prec_GPCC_1)
  
  
  # Incluir �ndice ONI 
  
  # Lectura de datos estaci�n 
  
  ONI_81_2019_3 <- read.delim("~/Choco/Region_9_Alto_Cauca/ONI_81_2019_3.txt", header=FALSE)
  View(ONI_81_2019_3)
  ONI <- ONI_81_2019_3
  ONI
  
  dimnames(ONI)[[2]] <- c("fecha",  "mes_1", "ONI", "Evento", "Evento_especifico")
  ONI
  
  # unir dos archivos 
  
  IDEAM_GPCC_26075010_2
  MergedDataset_ONI_def <- merge(IDEAM_GPCC_26075010_2, ONI, all=TRUE, by="fecha")
  MergedDataset_ONI_def
  
  # ordenar por fecha 
  
  Esta_26075010_ONI_def <- with(MergedDataset_ONI_def, MergedDataset_ONI_def[order(secuencia, decreasing=FALSE), ])
  Esta_26075010_ONI_def
  
  Esta_26075010_ONI_def$ONI
  
  # identificaci�n de fechas espec�ficas con dato faltante
  Esta_26075010_ONI_def[297,]
  
  # Homogenizaci�n  
  
  install.packages("dplyr", dep = TRUE)
  library(dplyr)
  
  condicion_1 <- Esta_26075010_ONI_def$fecha %in% c("01/09/2005", "01/09/2011")
  condicion_1
 
  # Crear  Esta_26075010_ONI_def_1$Preci_est_IDEAM basado en la condici�n 
  Esta_26075010_ONI_def_1$Preci_est_IDEAM <- ifelse(condicion_1, 
                                                    (-0.602) + 0.979*Esta_26075010_ONI_def_1$preci_GPCC - 0.795*Esta_26075010_ONI_def_1$mes, 
                                                    Esta_26075010_ONI_def_1$Preci_est_IDEAM)
  
  IDEAM_GPCC_26075010_ONI <- data.frame(Esta_26075010_ONI_def_1, Esta_26075010_ONI_def_1$Preci_est_IDEAM)
  IDEAM_GPCC_26075010_ONI
  View( IDEAM_GPCC_26075010_ONI)
  
  
  # exportar datos a csv
  
  write.csv(IDEAM_GPCC_26075010_ONI,"IDEAM_GPCC_26075010_ONI.csv")
  library(xlsx)
  write.xlsx(IDEAM_GPCC_26075010_ONI, "IDEAM_GPCC_26075010_ONI.xlsx")
  
  # serie de tiempo precipitaci�n IDEAM per�odo 1981 a 2019
  
  Prec_IDEAM_def = data.frame(IDEAM_GPCC_26075010_ONI$Preci_est_IDEAM)
  Prec_IDEAM_def
  Prec_IDEAM_1_def <- ts(Prec_IDEAM_def, freq=12, start=c(1981,1), end=c(2019,12))
  Prec_IDEAM_1_def
  
  # serie de tiempo precipitaci�n GPCC per�odo 1981 a 2019
  
  Prec_GPCC_def = data.frame(IDEAM_GPCC_26075010_ONI$preci_GPCC)
  Prec_GPCC_def
  Prec_GPCC_1_def <- ts(Prec_GPCC_def, freq=12, start=c(1981,1), end=c(2019,12))
  Prec_GPCC_1_def
  
  par(mfrow = c(1,2))
  plot(Prec_IDEAM_1_def)
  plot(Prec_GPCC_1_def)
  
  
  # generar los �ndices de precipitaci�n
  
  # seleccionar datos x mes 
  # mes enero
  
  enero_1 <-  IDEAM_GPCC_26075010_ONI[ IDEAM_GPCC_26075010_ONI$mes == 1,]
  enero_1
  
  prome_ene <- mean(enero_1$Preci_est_IDEAM, na.rm = TRUE)
  prome_ene 
  
  median_ene <- median(enero_1$Preci_est_IDEAM, na.rm = TRUE)
  median_ene
  
  desves_ene <- sd(enero_1$Preci_est_IDEAM, na.rm = TRUE)
  desves_ene
  
  enero_2 <- mutate(enero_1,
                    preci.anm_1 = ((enero_1$Preci_est_IDEAM - prome_ene)/prome_ene),
                    preci.anm_2 = ((enero_1$Preci_est_IDEAM - prome_ene)/desves_ene),
                    preci.anm_3 = ((enero_1$Preci_est_IDEAM - median_ene)/median_ene)
  )
  enero_2
  
  # mes febrero
  
  febre_1 <-  IDEAM_GPCC_26075010_ONI[ IDEAM_GPCC_26075010_ONI$mes == 2,]
  febre_1
  
  prome_febre <- mean(febre_1$Preci_est_IDEAM, na.rm = TRUE)
  prome_febre 
  
  median_feb <- median(febre_1$Preci_est_IDEAM, na.rm = TRUE)
  median_feb
  
  desves_feb <- sd(febre_1$Preci_est_IDEAM, na.rm = TRUE)
  desves_feb
  
  febre_2 <- mutate(febre_1,
                    preci.anm_1 = ((febre_1$Preci_est_IDEAM - prome_febre)/prome_febre),
                    preci.anm_2 = ((febre_1$Preci_est_IDEAM - prome_febre )/desves_feb),
                    preci.anm_3 = ((febre_1$Preci_est_IDEAM - median_feb )/median_feb)
  )
  febre_2
  
  ene_feb <- paste (enero_2, febre_2)
  ene_feb
  
  
  
  # mes marzo
  
  marzo_1 <-  IDEAM_GPCC_26075010_ONI[ IDEAM_GPCC_26075010_ONI$mes == 3,]
  marzo_1
  
  prome_marzo <- mean(marzo_1$Preci_est_IDEAM, na.rm = TRUE)
  prome_marzo
  
  median_mar <- median(marzo_1$Preci_est_IDEAM, na.rm = TRUE)
  median_mar
  
  desves_mar <- sd(marzo_1$Preci_est_IDEAM, na.rm = TRUE)
  desves_mar
  
  marzo_2 <- mutate(marzo_1,
                    preci.anm_1 = ((marzo_1$Preci_est_IDEAM - prome_marzo)/prome_marzo),
                    preci.anm_2 = ((marzo_1$Preci_est_IDEAM - prome_marzo)/desves_mar),
                    preci.anm_3 = ((marzo_1$Preci_est_IDEAM - median_mar)/median_mar)
  )
  marzo_2
  
  # mes abril
  
  abril_1 <-  IDEAM_GPCC_26075010_ONI[ IDEAM_GPCC_26075010_ONI$mes == 4,]
  abril_1
  
  prome_abril <- mean(abril_1$Preci_est_IDEAM, na.rm = TRUE)
  prome_abril
  
  median_abr <- median(abril_1$Preci_est_IDEAM, na.rm = TRUE)
  median_abr
  
  desves_abr <- sd(abril_1$Preci_est_IDEAM, na.rm = TRUE)
  desves_abr
  
  abril_2 <- mutate(abril_1,
                    preci.anm_1 = ((abril_1$Preci_est_IDEAM - prome_abril)/prome_abril),
                    preci.anm_2 = ((abril_1$Preci_est_IDEAM - prome_abril)/desves_abr),
                    preci.anm_3 = ((abril_1$Preci_est_IDEAM - median_abr )/median_abr)
  )
  abril_2
  
  # mes mayo
  
  mayo_1 <-  IDEAM_GPCC_26075010_ONI[ IDEAM_GPCC_26075010_ONI$mes == 5,]
  mayo_1
  
  prome_mayo <- mean(mayo_1$Preci_est_IDEAM, na.rm = TRUE)
  prome_mayo
  
  median_may <- median(mayo_1$Preci_est_IDEAM, na.rm = TRUE)
  median_may
  
  desves_may <- sd(mayo_1$Preci_est_IDEAM, na.rm = TRUE)
  desves_may
  
  mayo_2 <- mutate(mayo_1,
                   preci.anm_1 = ((mayo_1$Preci_est_IDEAM - prome_mayo)/prome_mayo),
                   preci.anm_2 = ((mayo_1$Preci_est_IDEAM - prome_mayo)/desves_may),
                   preci.anm_3 = ((mayo_1$Preci_est_IDEAM - median_may )/median_may)
  )
  mayo_2
  
  
  # mes junio
  
  junio_1 <-  IDEAM_GPCC_26075010_ONI[ IDEAM_GPCC_26075010_ONI$mes == 6,]
  junio_1
  
  prome_junio <- mean(junio_1$Preci_est_IDEAM, na.rm = TRUE)
  prome_junio
  
  median_jun <- median(junio_1$Preci_est_IDEAM, na.rm = TRUE)
  median_jun
  
  desves_jun <- sd(junio_1$Preci_est_IDEAM, na.rm = TRUE)
  desves_jun
  
  junio_2 <- mutate(junio_1,
                    preci.anm_1 = ((junio_1$Preci_est_IDEAM - prome_junio)/prome_junio),
                    preci.anm_2 = ((junio_1$Preci_est_IDEAM - prome_junio)/desves_jun),
                    preci.anm_3 = ((junio_1$Preci_est_IDEAM - median_jun)/median_jun)
  )
  junio_2
  
  # mes julio
  
  julio_1 <-  IDEAM_GPCC_26075010_ONI[ IDEAM_GPCC_26075010_ONI$mes == 7,]
  julio_1
  
  prome_julio <- mean(julio_1$Preci_est_IDEAM, na.rm = TRUE)
  prome_julio
  
  median_jul <- median(julio_1$Preci_est_IDEAM, na.rm = TRUE)
  median_jul
  
  desves_jul <- sd(julio_1$Preci_est_IDEAM, na.rm = TRUE)
  desves_jul
  
  julio_2 <- mutate(julio_1,
                    preci.anm_1 = ((julio_1$Preci_est_IDEAM - prome_julio)/prome_julio),
                    preci.anm_2 = ((julio_1$Preci_est_IDEAM - prome_julio)/desves_jul),
                    preci.anm_3 = ((julio_1$Preci_est_IDEAM - median_jul)/median_jul)
  )
  julio_2
  
  
  # mes agosto
  
  agosto_1 <-  IDEAM_GPCC_26075010_ONI[ IDEAM_GPCC_26075010_ONI$mes == 8,]
  agosto_1
  
  prome_agosto<- mean(agosto_1$Preci_est_IDEAM, na.rm = TRUE)
  prome_agosto
  
  median_ago <- median(agosto_1$Preci_est_IDEAM, na.rm = TRUE)
  median_ago
  
  desves_ago <- sd(agosto_1$Preci_est_IDEAM, na.rm = TRUE)
  desves_ago
  
  agosto_2 <- mutate(agosto_1,
                     preci.anm_1 = ((agosto_1$Preci_est_IDEAM - prome_agosto)/prome_agosto),
                     preci.anm_2 = ((agosto_1$Preci_est_IDEAM - prome_agosto)/desves_ago),
                     preci.anm_3 = ((agosto_1$Preci_est_IDEAM - median_ago)/median_ago)
  )
  agosto_2
  
  # mes septiembre
  
  septiembre_1 <-  IDEAM_GPCC_26075010_ONI[ IDEAM_GPCC_26075010_ONI$mes == 9,]
  septiembre_1
  
  prome_septiembre<- mean(septiembre_1$Preci_est_IDEAM, na.rm = TRUE)
  prome_septiembre
  
  median_sep <- median(septiembre_1$Preci_est_IDEAM, na.rm = TRUE)
  median_sep
  
  desves_sep <- sd(septiembre_1$Preci_est_IDEAM, na.rm = TRUE)
  desves_sep
  
  septiembre_2 <- mutate(septiembre_1,
                         preci.anm_1 = ((septiembre_1$Preci_est_IDEAM - prome_septiembre)/prome_septiembre),
                         preci.anm_2 = ((septiembre_1$Preci_est_IDEAM - prome_septiembre)/desves_sep),
                         preci.anm_3 = ((septiembre_1$Preci_est_IDEAM - median_sep)/median_sep)
  )
  septiembre_2
  
  # mes octubre 
  
  octubre_1 <-  IDEAM_GPCC_26075010_ONI[ IDEAM_GPCC_26075010_ONI$mes == 10,]
  octubre_1
  
  prome_octubre<- mean(octubre_1$Preci_est_IDEAM, na.rm = TRUE)
  prome_octubre
  
  median_oct <- median(octubre_1$Preci_est_IDEAM, na.rm = TRUE)
  median_oct
  
  desves_oct <- sd(octubre_1$Preci_est_IDEAM, na.rm = TRUE)
  desves_oct
  
  octubre_2 <- mutate(octubre_1,
                      preci.anm_1 = ((octubre_1$Preci_est_IDEAM - prome_octubre)/prome_octubre),
                      preci.anm_2 = ((octubre_1$Preci_est_IDEAM - prome_octubre)/desves_oct),
                      preci.anm_3 = ((octubre_1$Preci_est_IDEAM - median_oct)/median_oct)
  )
  octubre_2
  
  # mes noviembre
  
  noviembre_1 <-  IDEAM_GPCC_26075010_ONI[ IDEAM_GPCC_26075010_ONI$mes == 11,]
  noviembre_1
  
  prome_noviembre<- mean(noviembre_1$Preci_est_IDEAM, na.rm = TRUE)
  prome_noviembre
  
  median_nov <- median(noviembre_1$Preci_est_IDEAM, na.rm = TRUE)
  median_nov
  
  desves_nov <- sd(noviembre_1$Preci_est_IDEAM, na.rm = TRUE)
  desves_nov
  
  noviembre_2 <- mutate(noviembre_1,
                        preci.anm_1 = ((noviembre_1$Preci_est_IDEAM - prome_noviembre)/prome_noviembre),
                        preci.anm_2 = ((noviembre_1$Preci_est_IDEAM - prome_noviembre)/desves_nov),
                        preci.anm_3 = ((noviembre_1$Preci_est_IDEAM - median_nov)/median_nov)
  )
  noviembre_2
  
  
  # mes diciembre 
  
  diciembre_1 <-  IDEAM_GPCC_26075010_ONI[ IDEAM_GPCC_26075010_ONI$mes == 12,]
  diciembre_1
  
  prome_diciembre<- mean(diciembre_1$Preci_est_IDEAM, na.rm = TRUE)
  prome_diciembre
  
  median_dic <- median(diciembre_1$Preci_est_IDEAM, na.rm = TRUE)
  median_dic
  
  desves_dic <- sd(diciembre_1$Preci_est_IDEAM, na.rm = TRUE)
  desves_dic
  
  diciembre_2 <- mutate(diciembre_1,
                        preci.anm_1 = ((diciembre_1$Preci_est_IDEAM - prome_diciembre)/prome_diciembre),
                        preci.anm_2 = ((diciembre_1$Preci_est_IDEAM - prome_diciembre)/desves_dic),
                        preci.anm_3 = ((diciembre_1$Preci_est_IDEAM - median_dic)/median_dic)
  )
  diciembre_2
  
  
  # Unir todos los meses
  
  library(dplyr)
  
  ene_feb_2 <- enero_2 %>% full_join(febre_2)
  ene_feb_2
  
  ene_feb_mar_2 <- ene_feb_2 %>% full_join(marzo_2)
  ene_feb_mar_2 
  
  ene_feb_mar_ab_2 <- ene_feb_mar_2  %>% full_join(abril_2)
  ene_feb_mar_ab_2 
  
  ene_feb_mar_ab_may_2 <- ene_feb_mar_ab_2   %>% full_join(mayo_2)
  ene_feb_mar_ab_may_2
  
  ene_feb_mar_ab_may_jun_2 <- ene_feb_mar_ab_may_2  %>% full_join(junio_2)
  ene_feb_mar_ab_may_jun_2  
  
  ene_feb_mar_ab_may_jul_2 <- ene_feb_mar_ab_may_jun_2  %>% full_join(julio_2)
  ene_feb_mar_ab_may_jul_2  
  
  ene_feb_mar_ab_may_jul_ago_2 <- ene_feb_mar_ab_may_jul_2  %>% full_join(agosto_2)
  ene_feb_mar_ab_may_jul_ago_2
  
  ene_feb_mar_ab_may_jul_ago_sep_2 <- ene_feb_mar_ab_may_jul_ago_2  %>% full_join(septiembre_2)
  ene_feb_mar_ab_may_jul_ago_sep_2 
  
  ene_feb_mar_ab_may_jul_ago_sep_oct_2 <- ene_feb_mar_ab_may_jul_ago_sep_2 %>% full_join(octubre_2)
  ene_feb_mar_ab_may_jul_ago_sep_oct_2
  
  ene_feb_mar_ab_may_jul_ago_sep_oct_nov_2 <- ene_feb_mar_ab_may_jul_ago_sep_oct_2 %>% full_join(noviembre_2)
  ene_feb_mar_ab_may_jul_ago_sep_oct_nov_2
  
  ene_feb_mar_ab_may_jul_ago_sep_oct_nov_dic_2 <- ene_feb_mar_ab_may_jul_ago_sep_oct_nov_2 %>% full_join(diciembre_2)
  ene_feb_mar_ab_may_jul_ago_sep_oct_nov_dic_2
  
  Indices_clima_26075010_def <- with(ene_feb_mar_ab_may_jul_ago_sep_oct_nov_dic_2, ene_feb_mar_ab_may_jul_ago_sep_oct_nov_dic_2[order(secuencia, decreasing=FALSE), ])
  Indices_clima_26075010_def
  
  write.csv(Indices_clima_26075010_def,"Indices_clima_26075010_def.csv")
  library(xlsx)
  write.xlsx(Indices_clima_26075010_def,"Indices_clima_26075010_def.xlsx")
  View(Indices_clima_26075010_def)
  
  # C�lculo �ndice SPI 
  
  install.packages("SPEI",dependencies = TRUE)
  require(SPEI)
  library(SPEI)
  
  # C�lculo del �ndice estandarizado de precipitaci�n 
  # supuesto de modelo probabil�stico Gamma
  
  SPI3 = spi(Indices_clima_26075010_def$Preci_est_IDEAM, scale = 3, distribution = 'Gamma')
  SPI3
  
  plot(SPI3)
  
 
  # series �ndice 1, �ndice 2 e �ndice 3 preciitaci�n IDEM como objeto de series de tiempo
  
  preci.anm_1_1 <- ts(Indices_clima_26075010_def$preci.anm_1, freq=12, start=c(1981,1), end=c(2019,12))
  preci.anm_1_1
  preci.anm_2_1 <- ts(Indices_clima_26075010_def$preci.anm_2, freq=12, start=c(1981,1), end=c(2019,12))
  preci.anm_2_1
  preci.anm_3_1 <- ts(Indices_clima_26075010_def$preci.anm_3, freq=12, start=c(1981,1), end=c(2019,12))
  preci.anm_3_1
  
  # gr�ficos series de tiempo IDEAM y GPCC y SPI3-supuesto Gamma 
  
  par(mfrow = c(1,3)) 
  plot(Prec_IDEAM_1_def,main="Precipitaci�n IDEAM", xlab="A�o", ylab="Precipitaci�n")
  plot(Prec_GPCC_1_def,main="Precipitaci�n GPCC", xlab="A�o", ylab="Precipitaci�n")
  plot(SPI3,main="Indice estandarizado precipitaci�n, Gamma", xlab="A�o", ylab="SPI3")
  
  # gr�ficos series de �ndice 1, �ndice 2 �ndice 3 y SPI3-Gamma 
  
  par(mfrow = c(1,4))
  plot(preci.anm_1_1,main="Indice 1 precipitaci�n IDEAM", xlab="A�o", ylab="�ndice 1")
  plot(preci.anm_2_1,main="Indice 2 precipitaci�n IDEAM", xlab="A�o", ylab="�ndice 2")
  plot(preci.anm_3_1,main="Indice 3 precipitaci�n IDEAM", xlab="A�o", ylab="�ndice 3")
  plot(SPI3,main="Indice estandarizado precipitaci�n, Gamma", xlab="A�o", ylab="SPI3")
  
  
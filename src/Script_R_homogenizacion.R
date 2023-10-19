  # Región Alto Cauca 
  # Estación 26075010 
  # Nombre: Palmira ICA 
  # Serie de tiempo precipitación mensual
  # Fuente: IDEAM 
  # Período: 01-1930 a 11-2021

  # Grupo GIIAUD - Ingeniería Ambiental
  # Universidad Distrital Francisco José de Caldas
  # Profesor Néstor Ricardo Bernal Suárez (nrbernals@udistrital.edu.co) 
  # Grupo Tiempo, Clima y Sociedad - Departamento de Geografía
  # Universidad Nacional de Colombia
  # Profesor José Daniel Pabón Caicedo (jdpabonc@unal.edu.co)
  # Versión R Studio 3.6
  # Octubre de 2023


  # Libreria para tratamiento de series de tiempo
  install.packages("tidyverse",dependencies = TRUE)
  install.packages("lubridate",dependencies = TRUE)
  library(tidyverse)
  library(lubridate)
  install.packages("TSstudio",dependencies = TRUE)
  library(TSstudio)
  
  # Lectura de datos estación 
  
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
  
    # verificación lectura de datos IDEAM 
  
  head(Esta_26075010_3)
  
  # verificación lectura de datos GPCC
  
  head(GPCC_26075010)
  
  # Gráficos IDEAM
  
  Precipi_IDEAM = data.frame(Esta_26075010_3$preci_IDEAM)
  
  Precipi_IDEAM
  
  Precipi_IDEAM <- ts(Precipi_IDEAM, freq=12, start=c(1981,1), end=c(2019,12))
  Precipi_IDEAM
  
  plot(Precipi_IDEAM)
  
  # Gráficos GPCC
  
  Precipi_GPCC = data.frame(GPCC_26075010$preci_GPCC)
  
  Precipi_GPCC
  
  Precipi_GPCC <- ts(Precipi_GPCC, freq=12, start=c(1981,1))
  Precipi_GPCC
  
  plot(Precipi_GPCC)
  
  
  # gráficos precipitación IDEAM y GPCC
  
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
  
  # correlación series IDEAM vs. GPCC
  
  install.packages("COR", dep = TRUE)
  library(COR)
  cor(x=MergedDataset_IDEAM_GPCC$preci_IDEAM, y=MergedDataset_IDEAM_GPCC$preci_GPCC, use="pairwise.complete.obs",
      method=c("pearson"))
  
  cor(x=MergedDataset_IDEAM_GPCC$preci_IDEAM, y=MergedDataset_IDEAM_GPCC$preci_GPCC, use="pairwise.complete.obs",
      method=c("spearman"))
  
  cor(x=MergedDataset_IDEAM_GPCC$preci_IDEAM, y=MergedDataset_IDEAM_GPCC$preci_GPCC, use="pairwise.complete.obs",
      method=c("kendall"))
  
  
  # identificación de meses con datos faltantes
  
  IDEAM_GPCC_26075010_1 = data.frame(IDEAM_GPCC_26075010$fecha,IDEAM_GPCC_26075010$preci_IDEAM,IDEAM_GPCC_26075010$preci_GPCC)
  IDEAM_GPCC_26075010_1
  
  # emplear union de bases ordenadas
  which(is.na(IDEAM_GPCC_26075010$preci_IDEAM))
  
  
  # identificación de fechas específicas con dato faltante
  IDEAM_GPCC_26075010_1[369,]
  
  
  # modelo de regresión 
  
  mod1 <- lm(MergedDataset_IDEAM_GPCC$preci_IDEAM ~ MergedDataset_IDEAM_GPCC$preci_GPCC + mes, data=IDEAM_GPCC_26075010)
  mod1
  summary(mod1)
  
  # condición dato faltante 
  
  install.packages("dplyr", dep = TRUE)
  library(dplyr)
  
  IDEAM_GPCC_26075010_1 = data.frame(IDEAM_GPCC_26075010)
  IDEAM_GPCC_26075010_1
  
  
  IDEAM_GPCC_26075010_1$Preci_est_IDEAM_1 = if_else((IDEAM_GPCC_26075010_1$secuencia >= 73 & IDEAM_GPCC_26075010_1$secuencia <= 132), 
                                                  preci_1 <- IDEAM_GPCC_26075010_1$preci_GPCC, preci_1 <- IDEAM_GPCC_26075010_1$preci_IDEAM)
  
  IDEAM_GPCC_26075010_1$Preci_est_IDEAM = if_else(IDEAM_GPCC_26075010_1$fecha == "01/09/2011", 
                                                  preci_1 <- (-9.569) + 0.972*IDEAM_GPCC_26075010_1$preci_GPCC + 0.677*IDEAM_GPCC_26075010_1$mes, preci_1 <- IDEAM_GPCC_26075010_1$Preci_est_IDEAM_1)
  
  
  IDEAM_GPCC_26075010_2 <- data.frame(IDEAM_GPCC_26075010_1, IDEAM_GPCC_26075010_1$Preci_est_IDEAM)
  IDEAM_GPCC_26075010_2
  View( IDEAM_GPCC_26075010_2)
  
  
  # detección de cambio en el promedio
  
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
  
  
  # serie de tiempo precipitación IDEAM período 1981 a 2019
  
  Prec_IDEAM = data.frame(IDEAM_GPCC_26075010_2$Preci_est_IDEAM)
  Prec_IDEAM
  Prec_IDEAM_1 <- ts(Prec_IDEAM, freq=12, start=c(1981,1), end=c(2019,12))
  Prec_IDEAM_1
  
  # serie de tiempo precipitación GPCC período 1981 a 2019
  
  Prec_GPCC = data.frame(IDEAM_GPCC_26075010_2$preci_GPCC)
  Prec_GPCC
  Prec_GPCC_1 <- ts(Prec_GPCC, freq=12, start=c(1981,1), end=c(2019,12))
  Prec_GPCC_1
  
  par(mfrow = c(1,2))
  plot(Prec_IDEAM_1)
  plot(Prec_GPCC_1)
  
  # generar los índices de precipitación
  
  # seleccionar datos x mes 
  # mes enero
  
  enero_1 <- IDEAM_GPCC_26075010_2[IDEAM_GPCC_26075010_2$mes == 1,]
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
  
  febre_1 <- IDEAM_GPCC_26075010_2[IDEAM_GPCC_26075010_2$mes == 2,]
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
  
  marzo_1 <- IDEAM_GPCC_26075010_2[IDEAM_GPCC_26075010_2$mes == 3,]
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
  
  abril_1 <- IDEAM_GPCC_26075010_2[IDEAM_GPCC_26075010_2$mes == 4,]
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
  
  mayo_1 <- IDEAM_GPCC_26075010_2[IDEAM_GPCC_26075010_2$mes == 5,]
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
  
  junio_1 <- IDEAM_GPCC_26075010_2[IDEAM_GPCC_26075010_2$mes == 6,]
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
  
  julio_1 <- IDEAM_GPCC_26075010_2[IDEAM_GPCC_26075010_2$mes == 7,]
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
  
  agosto_1 <- IDEAM_GPCC_26075010_2[IDEAM_GPCC_26075010_2$mes == 8,]
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
  
  septiembre_1 <- IDEAM_GPCC_26075010_2[IDEAM_GPCC_26075010_2$mes == 9,]
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
  
  octubre_1 <- IDEAM_GPCC_26075010_2[IDEAM_GPCC_26075010_2$mes == 10,]
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
  
  noviembre_1 <- IDEAM_GPCC_26075010_2[IDEAM_GPCC_26075010_2$mes == 11,]
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
  
  diciembre_1 <- IDEAM_GPCC_26075010_2[IDEAM_GPCC_26075010_2$mes == 12,]
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
  
  Indices_clima_26075010 <- with(ene_feb_mar_ab_may_jul_ago_sep_oct_nov_dic_2, ene_feb_mar_ab_may_jul_ago_sep_oct_nov_dic_2[order(secuencia, decreasing=FALSE), ])
  Indices_clima_26075010
  
  write.csv(Indices_clima_26075010,"Indices_clima_26075010.csv")
  library(xlsx)
  write.xlsx(Indices_clima_26075010,"Indices_clima_26075010.xlsx")
  
  
  # Cálculo índice SPI 
  
  install.packages("SPEI",dependencies = TRUE)
  require(SPEI)
  library(SPEI)
  
  # Cálculo del índice estandarizado de precipitación 
  # supuesto de modelo probabilístico Gamma
  
  SPI3 = spi(Indices_clima_26075010$Preci_est_IDEAM, scale = 3, distribution = 'Gamma')
  SPI3
  
  plot(SPI3)
  
 
  # series índice 1, índice 2 e índice 3 preciitación IDEM como objeto de series de tiempo
  
  preci.anm_1_1 <- ts(Indices_clima_26075010$preci.anm_1, freq=12, start=c(1981,1), end=c(2019,12))
  preci.anm_1_1
  preci.anm_2_1 <- ts(Indices_clima_26075010$preci.anm_2, freq=12, start=c(1981,1), end=c(2019,12))
  preci.anm_2_1
  preci.anm_3_1 <- ts(Indices_clima_26075010$preci.anm_3, freq=12, start=c(1981,1), end=c(2019,12))
  preci.anm_3_1
  
  # gráficos series de tiempo IDEAM y GPCC y SPI3-supuesto Gamma 
  
  par(mfrow = c(1,3))
  plot(Prec_IDEAM_est_1,main="Precipitación IDEAM", xlab="Año", ylab="Precipitación")
  plot(Prec_GPCC_1,main="Precipitación GPCC", xlab="Año", ylab="Precipitación")
  plot(SPI3,main="Indice estandarizado precipitación, Gamma", xlab="Año", ylab="SPI3")
  
  # gráficos series de índice 1, índice 2 índice 3 y SPI3-Gamma 
  
  par(mfrow = c(1,4))
  plot(preci.anm_1_1,main="Indice 1 precipitación IDEAM", xlab="Año", ylab="índice 1")
  plot(preci.anm_2_1,main="Indice 2 precipitación IDEAM", xlab="Año", ylab="índice 2")
  plot(preci.anm_3_1,main="Indice 3 precipitación IDEAM", xlab="Año", ylab="índice 3")
  plot(SPI3,main="Indice estandarizado precipitación, Gamma", xlab="Año", ylab="SPI3")
  
  
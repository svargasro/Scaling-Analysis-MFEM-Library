#!/bin/bash

cd ./escalamientoDebil
# Ejecuta escalamiento débil para los ejemplos indicando: (ejecutable orden #threads #repetciciones)
bash weak_exp.sh ex1p 2 4 3   #Ejemplo 1 version paralela
bash weak_exp.sh ex39p 2 4 3  #Ejemplo 39 version paralela
#/escalamientoDebil/weak_volta.sh

cd ../escalamientoFuerte
# Ejecuta el .sh del escalamiento fuerte del ejemplo 39p
#/escalamientoFuerte/strong_ex39p.sh

# Ejecuta el .sh del escalimiento fuerte de la miniapp volta
#/escalamientoFuerte/strong_volta.sh

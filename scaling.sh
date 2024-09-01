#!/bin/bash

cd ./escalamientoDebil
#Ejecuta el .sh del escalamiento débil: ./weak_exp.sh Ejecutable Orden Máximo#Threads #Repeticiones
./weak_exp.sh ex1p 2 4 5   #Ejemplo 1 version paralela
./weak_exp.sh ex39p 2 4 5  #Ejemplo 39 version paralela
#/escalamientoDebil/weak_volta.sh

#Construir gráfica de uso de memoria RAM
./monitor_memoria.sh ex1p 10 14 0.001
./monitor_memoria.sh ex39p 8 7 0.001

cd ./../escalamientoFuerte/

#Ejecuta el .sh del escalamiento fuerte: ./strong_exp.sh Ejecutable MáximoOrden Threads #Repeticiones
./strong_exp.sh ex1p 2 3 3 #Escalamiento fuerte ex1p
#./strong_exp.sh ex39p 2 3 3 #Escalamiento fuerte ex39p
#././strong_exp.sh ex1p 2 3 3#Escalamiento fuerte miniapp volta.

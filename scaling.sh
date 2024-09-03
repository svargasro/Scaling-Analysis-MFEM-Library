#!/bin/bash

cd ./escalamientoDebil
#Ejecuta el .sh del escalamiento débil:
#./weak_exp.sh Ejecutable Orden Máximo#Threads #Repeticiones // ./weak_volta.sh no recibe el ejecutable.
./weak_exp.sh ex1p 2 4 5   #Ejemplo 1 version paralela
./weak_exp.sh ex39p 2 4 5  #Ejemplo 39 version paralela
./weak_volta.sh 2 2 3 #Miniapp volta version paralela

#Construir gráfica de uso de memoria RAM.
#./monitor_memoria.sh Ejecutable Orden #Threads IntervaloTiempoEntreMedicionesRAM
./monitor_memoria.sh ex1p 10 14 0.001
./monitor_memoria.sh ex39p 8 7 0.001

cd ./../escalamientoFuerte/

#Ejecuta el .sh del escalamiento fuerte:
# ./strong_exp.sh Ejecutable MáximoOrden Threads #Repeticiones // ./strong_volta.sh no recibe el ejecutable.
./strong_exp.sh ex1p 2 3 3 #Escalamiento fuerte ex1p
./strong_exp.sh ex39p 2 3 3 #Escalamiento fuerte ex39p
./strong_volta.sh 2 3 3 #Miniapp volta version paralela

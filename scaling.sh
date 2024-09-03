#!/bin/bash

cd ./escalamientoDebil
#Ejecuta el .sh del escalamiento débil:
#./weak_exp.sh Ejecutable Orden Máximo#Threads #Repeticiones // ./weak_volta.sh no recibe el ejecutable.
./weak_exp.sh ex1p 2 3 2   #Ejemplo 1 version paralela
./weak_exp.sh ex39p 2 3 2  #Ejemplo 39 version paralela
./weak_volta.sh 2 3 2 #Miniapp volta version paralela

cd ./../escalamientoFuerte/

#Ejecuta el .sh del escalamiento fuerte:
# ./strong_exp.sh Ejecutable MáximoOrden Threads #Repeticiones // ./strong_volta.sh no recibe el ejecutable.
./strong_exp.sh ex1p 3 3 2 #Escalamiento fuerte ex1p
./strong_exp.sh ex39p 3 3 2 #Escalamiento fuerte ex39p
./strong_volta.sh 3 3 2 #Miniapp volta version paralela

cd ./../escalamientoDebil/
#Construir gráfica de uso de memoria RAM.
#./monitor_memoria.sh Ejecutable Orden #Threads IntervaloTiempoEntreMedicionesRAM. Descomente las líneas en caso de querer monitorear la RAM.

#./monitor_memoria.sh ex1p 2 3 0.001
#./monitor_memoria.sh ex39p 2 3 0.001

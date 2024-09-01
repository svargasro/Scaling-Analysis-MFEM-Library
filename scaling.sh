#!/bin/bash

cd ./escalamientoDebil
#En las siguientes 3 líneas se ejecuta el escalamiento débil para los ejemplos indicando: (ejecutable #orden #threads #repeticiones)
bash weak_exp.sh ex1p 2 3 3   #Se ejecuta el ejemplo 1 version paralela del escalamiento débil para el orden, thread y repeticiones dadas. 
#bash weak_exp.sh ex39p 2 4 3  #Se ejecuta el ejemplo 39 version paralela del escalamiento débil para el orden, thread y repeticiones dadas. 
#/escalamientoDebil/weak_volta.sh # Se ejecuta el escalamiento débil para la miniapp Volta 

#Construir gráfica de uso de memoria RAM. Aquí se ejecuta el script que extrae el consumo de memoria RAM generado por la ejecución del programa. Indicando: (ejecutable #orden #threads #Intervalo de medición medido en segundos)
#Activar la línea anterior permite generar gráficas de RAM MÁXIMA VS Thread y RAM VS Tiempo
#bash monitor_memoria.sh ex1p 2 1 0.001 
cd ./../escalamientoFuerte/
#Ejecuta el .sh del escalamiento fuerte: ./strong_exp.sh: (Ejecutable #MáximoOrden #Threads #Repeticiones)

./strong_exp.sh ex1p 2 3 3 #Se ejecuta el ejemplo 1 version paralela del escalamiento fuerte para el orden, thread y repeticiones dadas.
#./strong_exp.sh ex39p 2 3 3 #Se ejecuta el ejemplo 39 version paralela del escalamiento fuerte para el orden, thread y repeticiones dadas.
#././strong_exp.sh ex1p 2 3 3#Se ejecuta el escalamiento fuerte para la miniapp Volta 

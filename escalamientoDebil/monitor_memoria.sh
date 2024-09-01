#!/bin/bash

TARGET=$1    #Nombre del ejecutable a utilizar
ORDER=$2     #Parámetro de orden
THREADS=$3   #Número de threads para la ejecución paralela
LAPSE=$4     #Intervalo de tiempo en segundos entre mediciones de memoria.

# Ejecutar el comando con mpirun en segundo plano y obtener su PID
mpirun -np $THREADS --oversubscribe ../cpp_y_ejecutables/$TARGET -o $ORDER >/dev/null 2>&1 &
PID=$!

# Verificar si se obtuvo el PID del proceso mpirun.
if [ -z "$PID" ]; then
  echo "No se pudo obtener el PID del proceso."
  exit 1
fi

# Registrar el tiempo de inicio de la ejecución
start_time=$(date +%s.%N)

# Bucle para monitorear el uso de memoria mientras el proceso esté activo
while kill -0 $PID 2>/dev/null; do
  current_time=$(date +%s.%N)
  elapsed=$(echo "$current_time - $start_time" | bc)

  # Obtener todos los PIDs relacionados, incluyendo threads
  pids=$(pstree -p $PID | grep -o '([0-9]\+)' | grep -o '[0-9]\+' | tr '\n' ',' | sed 's/,$/\n/')

  # Sumar la memoria de todos los procesos e threads  en kilobytes
  mem_kb=$(ps -o rss= -p $pids | awk '{sum+=$1} END {print sum}')

  if [ -n "$mem_kb" ]; then
    mem_gb=$(echo "scale=6; $mem_kb / 1048576" | bc)
    #Convertir los datos de memoria RAM de KB a GB
    echo "$elapsed,$mem_gb">> resultados/memory_${TARGET}_order_${ORDER}.csv;
  fi
  # Esperar el intervalo de tiempo especificado antes de la siguiente medición
  sleep $LAPSE
done

# Generar una gráfica del uso de memoria RAM en función del tiempo
python3 memory_plot.py resultados/memory_${TARGET}_order_${ORDER}.csv

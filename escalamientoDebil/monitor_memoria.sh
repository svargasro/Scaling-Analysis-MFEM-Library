#!/bin/bash

# Configuración de parámetros
TARGET=$1
ORDER=$2
THREADS=$3
LAPSE=$4  # Intervalo de medición en segundos

# Ejecutar el comando y obtener el PID
# mpirun se ejecuta en segundo plano para obtener el PID del proceso principal

mpirun -np $THREADS --oversubscribe ../cpp_y_ejecutables/$TARGET -o $ORDER >/dev/null 2>&1 &
PID=$!

# Verificar si se obtuvo el PID
if [ -z "$PID" ]; then
  echo "No se pudo obtener el PID del proceso."
  exit 1
fi

start_time=$(date +%s.%N)

while kill -0 $PID 2>/dev/null; do
  current_time=$(date +%s.%N)
  elapsed=$(echo "$current_time - $start_time" | bc)

  # Obtener todos los PIDs relacionados, incluyendo hilos
  pids=$(pstree -p $PID | grep -o '([0-9]\+)' | grep -o '[0-9]\+' | tr '\n' ',' | sed 's/,$/\n/')

  # Sumar la memoria de todos los procesos e hilos
  mem_kb=$(ps -o rss= -p $pids | awk '{sum+=$1} END {print sum}')

  if [ -n "$mem_kb" ]; then
    mem_gb=$(echo "scale=6; $mem_kb / 1048576" | bc)
    echo "$elapsed,$mem_gb">> resultados/memory_${TARGET}_order_${ORDER}.csv;
  fi

  sleep $LAPSE
done

python3 memory_plot.py resultados/memory_${TARGET}_order_${ORDER}.csv

#!/bin/bash

PID=$1
INTERVALO=0.01  # Reducimos el intervalo para capturar más puntos

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
    echo "$elapsed,$mem_gb"
  fi

  sleep $INTERVALO
done

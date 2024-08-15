#Archivo para graficar el uso de memoria
import matplotlib.pyplot as plt
import pandas as pd
import glob

# Leer los datos de rendimiento
metrics = pd.read_csv('metrics.txt', sep=' ', header=None, names=['Threads', 'Speedup', 'Efficiency'])

# Crear el gráfico de rendimiento
plt.figure(figsize=(12, 6))
plt.plot(metrics['Threads'], metrics['Speedup'], 'bo-', label='Speedup')
plt.plot(metrics['Threads'], metrics['Efficiency'], 'ro-', label='Efficiency')
plt.xlabel('Número de Threads')
plt.ylabel('Speedup / Efficiency')
plt.title('Rendimiento del Programa')
plt.legend()
plt.grid(True)
plt.savefig('performance_plot.png')
plt.close()

# Leer y graficar los datos de memoria
memory_files = glob.glob('memoria_thread*.csv')

plt.figure(figsize=(12, 6))
for file in memory_files:
    thread = file.split('thread')[1].split('.')[0]
    data = pd.read_csv(file, header=None, names=['Time', 'Memory'])
    plt.plot(data['Time'], data['Memory'], label=f'Thread {thread}')

plt.xlabel('Tiempo Transcurrido (s)')
plt.ylabel('Uso de Memoria (GB)')
plt.title('Uso de Memoria por Número de Threads')
plt.legend()
plt.grid(True)
plt.savefig('memory_usage_plot.png')
plt.close()

# Graficar el uso máximo de memoria por thread
max_memory = [pd.read_csv(file, header=None, names=['Time', 'Memory'])['Memory'].max() for file in memory_files]
threads = range(1, len(max_memory) + 1)

plt.figure(figsize=(12, 6))
plt.plot(threads, max_memory, 'go-')
plt.xlabel('Número de Threads')
plt.ylabel('Uso Máximo de Memoria (GB)')
plt.title('Uso Máximo de Memoria por Número de Threads')
plt.grid(True)
plt.savefig('max_memory_usage_plot.png')
plt.close()

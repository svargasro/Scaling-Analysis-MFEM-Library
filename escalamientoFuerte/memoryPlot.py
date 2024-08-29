#Archivo para graficar el uso de memoria
import matplotlib.pyplot as plt
import pandas as pd
import glob

memory_files = glob.glob('resultados/memoria_orden*.csv')

for file in memory_files:
    order = file.split('orden')[1].split('.')[0]
    data = pd.read_csv(file, header=None, names=['Time', 'Order'])
    plt.plot(data['Time'], data['Order'], label=f'Order {order}')

max_memory = [pd.read_csv(file, header=None, names=['Time', 'Memory'])['Memory'].max() for file in memory_files]
threads = range(1, len(max_memory) + 1)

plt.figure(figsize=(12, 6))
plt.plot(threads, max_memory, 'go-')
plt.xlabel('Orden de ejecución')
plt.ylabel('Uso Máximo de Memoria (GB)')
plt.title('Uso Máximo de Memoria por Orden del problema')
plt.grid(True)
plt.savefig('resultados/graficas/max_memory_usage_plot.pdf')
plt.close()

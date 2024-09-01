import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import argparse
from matplotlib.backends.backend_pdf import PdfPages
from matplotlib.ticker import MaxNLocator
import os

# Configuración de argumentos de línea de comandos
# input_file: Nombre del archivo CSV que contiene los datos de tiempo
parser = argparse.ArgumentParser(description="Generar gráficas de SpeedUp y Eficiencia")
parser.add_argument('input_file', type=str, help='Nombre del archivo de texto con los datos')
args = parser.parse_args()

# Leer los tiempos desde el archivo CSV y eliminar la primera columna (nombres de threads)
time = pd.read_csv(f'{args.input_file}',header=None)
time = time.drop(time.columns[0], axis=1)

nThreads = time.shape[0] # Número de threads (filas en el CSV)

speedup = time.iloc[0,:] /time.iloc[:,:] # Calculo del SpeedUp: T(1 hilo) / T(N hilos)

# Calculo de la Eficiencia: SpeedUp / N hilos
threadsArray = np.arange(1,nThreads+1)
efficiency = speedup/(threadsArray.reshape(-1, 1))

# Calcular medias y desviaciones estándar para SpeedUp y Eficiencia
mean_speedup = speedup.mean(axis=1)
std_speedup = speedup.std(axis=1)
mean_efficiency = efficiency.mean(axis=1)
std_efficiency = efficiency.std(axis=1)

# Obtener el nombre base del archivo sin extensión
file_name = os.path.splitext(os.path.basename(args.input_file))[0]

# Extraer el objetivo (target) y el orden (order) del nombre del archivo
target = file_name.split('_')[1]
order = file_name.split('_')[3]

print('target:', target)
print('order:', order)


# Ruta para el archivo PDF de salida
output='./resultados/graficas/weak_'+ str(target) +'_order_' + str(order) +'.pdf'

# Configurar márgenes de error (tres veces la desviación estándar)
errorbarSpeedUp = 3*std_speedup
errorbarEfficiency = 3*std_efficiency

# Estilo de las gráficas
plt.style.use('ggplot')

# Guardar las gráficas en un archivo PDF
with PdfPages(output) as pdf:
        
    # Gráfica de SpeedUp
    plt.plot([0, len(threadsArray)+0.2], [0, len(threadsArray)+0.2], color='black')  #Ideal SpeedUp
    plt.errorbar(threadsArray, mean_speedup, yerr= errorbarSpeedUp, fmt='go', ecolor='black', markersize=3, label='SpeedUp')
    plt.xlabel('nThreads')
    plt.ylabel('SpeedUp')
    plt.title('SpeedUp de ' + str(target) + ' con orden ' + str(order))
    plt.xlim(0, len(threadsArray)+0.2)
    plt.ylim(0, len(threadsArray)+0.2)
    plt.gca().xaxis.set_major_locator(MaxNLocator(integer=True))
    plt.legend()
    pdf.savefig() # Guardar la gráfica en el PDF
    plt.close()

    # Gráfica de Eficiencia
    plt.plot([0, len(threadsArray)+0.2], [1, 1], color='red') # Línea ideal de Eficiencia
    plt.plot([0, len(threadsArray)+0.2], [0.6, 0.6], color='blue')  # Línea de eficiencia aceptable
    plt.errorbar(threadsArray, mean_efficiency, yerr= errorbarEfficiency, fmt='go', ecolor='black', markersize=3, label='Efficiency')
    plt.xlabel('nThreads')
    plt.ylabel('Efficiency')
    plt.title('Eficiencia de ' + str(target) + ' con orden ' + str(order))
    plt.xlim(0, len(threadsArray)+0.2)
    plt.ylim(0, 1.1)
    plt.gca().xaxis.set_major_locator(MaxNLocator(integer=True))
    plt.legend()
    pdf.savefig() # Guardar la gráfica en la segunda página PDF
    plt.close()


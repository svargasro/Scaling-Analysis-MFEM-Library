import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import argparse
from matplotlib.backends.backend_pdf import PdfPages
from matplotlib.ticker import MaxNLocator
import os
from scipy.optimize import curve_fit
from scipy.stats import pearsonr


#Función para el ajuste lineal.
def model(x, a, b):
    return a*x + b

# Configuración de argumentos de línea de comandos
# input_file: Nombre del archivo CSV que contiene los datos de tiempo
parser = argparse.ArgumentParser(description="Generar gráfica de escalamiento Fuerte")
parser.add_argument('input_file', type=str, help='Nombre del archivo de texto con los datos')
args = parser.parse_args()

# Leer los tiempos desde el archivo CSV
time = pd.read_csv(f'{args.input_file}',header=None)

size= time.iloc[:, -1] # Se extrae la columna correspondiente a los tamaños del sistema.

#Se extraen únicamente los tiempos. Se descartan títulos y tamaños.
time = time.drop(columns=[time.columns[0],time.columns[-1]], axis=1)

meanTimeValue = time.loc[0].mean() #Se extrae el promedio de tiempo para el primero orden.

time = time/meanTimeValue #Se construye un arreglo de tiempos normalizados.
meanTime = time.mean(axis=1) #Se toma el promedio de tiempo para cada órden.
stdTime = time.std(axis=1) #Se toma la desviación estándar de cada arreglo de tiempos normalizados.

#Se toma el logaritmo de tiempos y tamaño, su promedio y desviación estándar para la gráfica loglog.
timeLog = np.log(time)
sizeLog = np.log(size)
meanTimeLog = timeLog.mean(axis=1)
stdTimeLog = timeLog.std(axis=1)

#Se realiza el ajuste lineal de la gráfica loglog.
parameters, covarian_matrix = curve_fit(model,sizeLog,meanTimeLog)
a, b = parameters

timesAdjusted = model(sizeLog, a, b) #Se obtienen los tiempos ajustados.

r2, _ = pearsonr(meanTimeLog,timesAdjusted) #Se calcula el coeficiente de correlación del ajuste.


# print("meanTimeValue:\n", meanTimeValue)
# print("time:\n",time)
# print("mean:\n" , meanTime)
# print("std:\n", stdTime)

#Se extrae el nombre del archivo sin extensión.
file_name = os.path.splitext(os.path.basename(args.input_file))[0]
print('file_name:', file_name)

# Extract the target and order from the file name
target = file_name.split('_')[1]
threads = file_name.split('_')[3]
reps  = file_name.split('_')[5]

print('Target:', target)
print('Threads:', threads)
print('Reps:', reps)

#La dirección donde se guardan las gráficas.
output='./resultados/graficas/strong_scaling_'+ str(target) +'_threads_' + str(threads) +'_reps_'+ str(reps) +'.pdf'
#Las barras de error como 3 veces la desviación estándar.
errorbarTime = 3*stdTime
errorbarTimeLog = 3*stdTimeLog

plt.style.use('ggplot')

with PdfPages(output) as pdf:
    #Gráfica de tiempo promedio normalizado vs tamaño de sistema.
    plt.figure()
    plt.errorbar(size, meanTime, yerr= errorbarTime, fmt='go', ecolor='black', markersize=2, label="errorbar= 3*std")
    plt.xlabel('Número de incógnitas en el sistema de ecuaciones.', fontsize=12)
    plt.ylabel(r'Tiempo de ejecución normalizado [ ]',fontsize=12)
    plt.title('Escalamiento fuerte de ' + str(target) + ' con ' + str(reps) + ' repeticiones.\n Threads: '+str(threads))
    plt.ticklabel_format(style='sci', axis='x', scilimits=(0,0))
    plt.grid(True)
    plt.legend()
    plt.tight_layout()
    pdf.savefig()
    plt.close()

    #Gráfica logarítmica del promedio normalizado vs tamaño de sistema.
    plt.figure()
    plt.errorbar(sizeLog, meanTimeLog, yerr= errorbarTimeLog, fmt='go', ecolor='black', markersize=2, label="errorbar= 3*std")
    #Ajuste lineal:
    plt.plot(sizeLog,timesAdjusted, color='purple',label=r'{} $x$ + {} ($R^2$ ={})'.format(round(a,2),round(b,3),round(r2,4)))
    plt.xlabel('Log(Número de incógnitas en el sistema de ecuaciones)', fontsize=12)
    plt.ylabel(r'Log(Tiempo de ejecución normalizado)',fontsize=12)
    plt.title('Escalamiento fuerte de ' + str(target) + ' con ' + str(reps) + ' repeticiones.\n Threads: '+str(threads)+ '. Escala loglog')
    plt.ticklabel_format(style='sci', axis='x', scilimits=(0,0))
    plt.grid(True)
    plt.legend()
    plt.tight_layout()
    pdf.savefig()
    plt.close()










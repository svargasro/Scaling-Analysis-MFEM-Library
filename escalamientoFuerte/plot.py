import numpy as np
import matplotlib.pyplot as plt
import os

# Ruta del directorio que quieres verificar
directorio = './output/'
# Obtener la lista de archivos en el directorio
archivos = os.listdir(directorio)
# Contar la cantidad de archivos
cantidadArchivos = len(archivos)


time = np.zeros(cantidadArchivos)
timeDesv = np.zeros(cantidadArchivos)
size = np.zeros(cantidadArchivos)


for i, archivo in enumerate(archivos):

    timeArray, sizeArray = np.genfromtxt(f'./output/{archivo}',delimiter=' ', usecols=(0,1),unpack=True)

    meanTime = np.mean(timeArray)

    time[i] = meanTime

    size[i] = sizeArray[0]



#Se normaliza el promedio y desviación estándar dividiendo por el tiempo y desviación estándar que tomó para el índice 0.
time = time/time[0]
timeDesv  = np.std(timeArray)


errorbar= 3.0*timeDesv

plt.style.use('ggplot')

fig, axes = plt.subplots(1, 1, figsize=(7, 6))


#Se grafica el tiempo de ejecución normalizado vs. tamaño de la matriz.
axes.errorbar(size, time, yerr= errorbar, fmt='go', ecolor='black', markersize=6, label="Puntos con barras de error.")

#Se ajustan demás detalles del gráfico.
axes.set_xlabel('Número de incógnitas en el sistema de ecuaciones.', fontsize=12)
axes.set_ylabel(r'Tiempo de ejecución normalizado [ ]',fontsize=12)
axes.legend(loc='upper left')
axes.grid(True)
axes.set_title("Tiempo de ejecución normalizado vs. Número de incógnitas.\n 10 iteraciones", fontsize=14)

axes.ticklabel_format(style='sci', axis='x', scilimits=(0,0))

plt.tight_layout()

plt.savefig(f'EscalamientoFuerte10Iter.png')
#plt.show()

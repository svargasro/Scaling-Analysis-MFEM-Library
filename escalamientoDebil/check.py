#Codigo para verificar los calculos hecho desde bash

import os
import numpy as np
import glob

# Ruta a los archivos time*.txt
path = "."  # Reemplaza con la ruta correcta
files = sorted(glob.glob(os.path.join(path, "time*.txt")))

# Abrir archivo de salida
with open("resultados.txt", "w") as output_file:
    output_file.write("Archivo\tMedia\tDesviacion_Estandar\n")  # Encabezado
    
    # Leer cada archivo y calcular la media y desviación estándar para cada fila
    for file in files:
        data = np.loadtxt(file)  # Carga los datos del archivo como un array de NumPy
        file_means = np.mean(data)  # Calcula la media por archivo
        file_std_devs = np.std(data)  # Calcula la desviación estándar por archivo
        
        # Guardar los resultados en el archivo de salida
        output_file.write(f"{os.path.basename(file)}\t{file_means:.5f}\t{file_std_devs:.5f}\n")

print("Resultados guardados en 'resultados.txt'")

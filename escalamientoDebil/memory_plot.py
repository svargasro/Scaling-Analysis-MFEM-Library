import pandas as pd
import matplotlib.pyplot as plt
import argparse
import os

# Configuración de argumentos de línea de comandos
# input_file: Nombre del archivo CSV que contiene los datos de tiempo y memoria
parser = argparse.ArgumentParser(description="Generar gráficas de SpeedUp y Eficiencia")
parser.add_argument('input_file', type=str, help='Nombre del archivo de texto con los datos')
args = parser.parse_args()

# Leer el archivo CSV y asignar nombres a las columnas
df = pd.read_csv(f'{args.input_file}', header=None, names=['Tiempo', 'Memoria'])

# Obtener el nombre base del archivo sin extensión
file_name = os.path.splitext(os.path.basename(args.input_file))[0]

# Extraer el objetivo (target) y el orden (order) del nombre del archivo
target = file_name.split('_')[1]
order = file_name.split('_')[3]

# Ruta para el archivo PDF de salida
output = 'resultados/graficas/memory_' + str(target) + '_order_' + str(order) + '.pdf'

# Configurar el estilo y tamaño del gráfico
plt.style.use('ggplot')
plt.figure(figsize=(10, 6))

# Graficar los datos de tiempo y memoria
plt.plot(df['Tiempo'], df['Memoria'], marker='.', linestyle='-', color='#195A33',markersize=5)
plt.xlabel('Tiempo (s)')
plt.ylabel('Memoria Utilizada (GB)')
plt.title('Memoria utilizada de ' + str(target) + ' con orden ' + str(order))
plt.grid(True)

# Guardar el gráfico en un archivo PDF
plt.savefig(output)
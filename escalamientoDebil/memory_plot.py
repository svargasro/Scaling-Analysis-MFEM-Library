import pandas as pd
import matplotlib.pyplot as plt
import argparse
import os

parser = argparse.ArgumentParser(description="Generar gráficas de SpeedUp y Eficiencia")
parser.add_argument('input_file', type=str, help='Nombre del archivo de texto con los datos')
args = parser.parse_args()

# Leer el archivo CSV
df = pd.read_csv(f'{args.input_file}', header=None, names=['Tiempo', 'Memoria'])

# Extract the file name without the extension
file_name = os.path.splitext(os.path.basename(args.input_file))[0]

# Extract the target and order from the file name
target = file_name.split('_')[1]
order = file_name.split('_')[3]

output='resultados/memory_'+ str(target) +'_order_' + str(order) +'.pdf'

# Extract the target and order from the file name
target = file_name.split('_')[1]
order = file_name.split('_')[3]

# Configurar el gráfico
plt.style.use('ggplot')
plt.figure(figsize=(10, 6))
plt.plot(df['Tiempo'], df['Memoria'], marker='.', linestyle='-', color='#195A33',markersize=5)

# Etiquetas y título
plt.xlabel('Tiempo (s)')
plt.ylabel('Memoria Utilizada (GB)')
plt.title('Memoria utilizada de ' + str(target) + ' con orden ' + str(order))
plt.grid(True)

# Mostrar el gráfico
plt.savefig(output)


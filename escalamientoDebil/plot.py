import matplotlib.pyplot as plt
import numpy as np
import os
from matplotlib.backends.backend_pdf import PdfPages
from matplotlib.ticker import MaxNLocator
import glob

# Buscar todos los archivos metrics en el directorio actual
metrics_files = glob.glob('metrics_*.txt')


# Leer datos desde todos los archivos metrics
data_list = []
for file in metrics_files:
    base_name = os.path.splitext(os.path.basename(file))[0].replace('metrics_', '')
    data = np.loadtxt(file, dtype={'names': ('nThreads', 'speedup', 'errorspeedup', 'efficiency', 'errorefficiency'),
                                   'formats': ('i4', 'f4', 'f4', 'f4', 'f4')})
    data_list.append({'base_name': base_name, 'data': data})

# Verificar si hay datos cargados
for entry in data_list:
    print(f"Data for {entry['base_name']}:")
    print(entry['data'])

# Configuración de la gráfica
plt.style.use('ggplot')

output_directory = "graficos"
os.makedirs(output_directory, exist_ok=True)  # Crear la carpeta si no existe

# Función para generar un nombre de archivo único
def get_unique_filename(base_name, directory):
    counter = 1
    unique_name = f"{base_name}.pdf"
    while os.path.exists(os.path.join(directory, unique_name)):
        unique_name = f"{base_name}_{counter}.pdf"
        counter += 1
    return os.path.join(directory, unique_name)

# Generar nombres únicos para los archivos PDF
speedup_file = get_unique_filename("weak_scaling_speedup", output_directory)
efficiency_file = get_unique_filename("weak_scaling_efficiency", output_directory)

# Ejemplo de generación de gráficos y guardado en archivos PDF
with PdfPages(speedup_file) as pdf:
    for entry in data_list:
        base_name = entry['base_name']
        data = entry['data']
        plt.figure()
        plt.plot([0, len(data['nThreads'])+0.2], [0, len(data['nThreads'])+0.2], color='black')  #Ideal SpeedUp
        plt.scatter(data['nThreads'], data['speedup'], label=f'{base_name}')
        plt.errorbar(data['nThreads'], data['speedup'], yerr=data['errorspeedup'], fmt='o')
        plt.xlabel('Number of Threads')
        plt.ylabel('Speedup')
        plt.title(f'Speedup for {base_name}')
        plt.legend()
        plt.grid(True)
        pdf.savefig(output_directory)
        plt.close()

with PdfPages(efficiency_file) as pdf:
    for entry in data_list:
        base_name = entry['base_name']
        data = entry['data']
        plt.figure()
        plt.plot([0, len(data['nThreads'])+0.2], [1, 1], color='red')  # Ideal Efficiency
        plt.plot([0, len(data['nThreads'])+0.2], [0.6, 0.6], color='blue')  # Aceptable Efficiency
        plt.scatter(data['nThreads'], data['efficiency'], label=f'{base_name}')
        plt.scatter(data['nThreads'], data['efficiency'], yerr=data['errorefficiency'], fmt='o')
        plt.xlabel('Number of Threads')
        plt.ylabel('Efficiency')
        plt.title(f'Efficiency for {base_name}')
        plt.legend()
        plt.grid(True)
        pdf.savefig(output_directory)
        plt.close()

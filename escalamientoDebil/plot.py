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
	data = np.loadtxt(file, dtype={'names': ('nThreads', 'speedup', 'efficiency'),
                                   'formats': ('i4', 'f4', 'f4')})
	base_name_array = np.full(data.shape, base_name, dtype='<U10')  # Array con el nombre del archivo
	structured_data = np.core.records.fromarrays(data.transpose().tolist() + [base_name_array], names=data.dtype.names + ('base_name',))
	data_list.append(structured_data)

# Verificar si hay datos cargados

print(data_list)
# Combinar todos los datos en un solo array
data = np.concatenate(data_list)

# Verificar el contenido de data
print(data)

# Configuración de la gráfica
plt.style.use('ggplot')
output_directory = "Graficos/"
os.makedirs(output_directory, exist_ok=True)

# Función para generar un nombre de archivo único
def get_unique_filename(base_name, directory):
    counter = 1
    unique_name = f"{base_name}.pdf"
    while os.path.exists(os.path.join(directory, unique_name)):
        unique_name = f"{base_name}_{counter}.pdf"
        counter += 1
    return unique_name

# Generar nombres únicos para los archivos PDF
speedup_file = get_unique_filename("weak_scaling_speedup", output_directory)
efficiency_file = get_unique_filename("weak_scaling_efficiency", output_directory)

# Ejemplo de generación de gráficos y guardado en archivos PDF
with PdfPages(speedup_file) as pdf:
    for exec_id in np.unique(data['execId']):
        subset = data[data['execId'] == exec_id]
        plt.figure()
        plt.plot(subset['nThreads'], subset['speedup'], label=f'Exec {exec_id}')
        plt.xlabel('Number of Threads')
        plt.ylabel('Speedup')
        plt.title(f'Speedup for Execution {exec_id}')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

with PdfPages(efficiency_file) as pdf:
    for exec_id in np.unique(data['execId']):
        subset = data[data['execId'] == exec_id]
        plt.figure()
        plt.plot(subset['nThreads'], subset['efficiency'], label=f'Exec {exec_id}')
        plt.xlabel('Number of Threads')
        plt.ylabel('Efficiency')
        plt.title(f'Efficiency for Execution {exec_id}')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()


"""import matplotlib.pyplot as plt
import numpy as np
from matplotlib.backends.backend_pdf import PdfPages
from matplotlib.ticker import MaxNLocator

# Leer datos desde el archivo metrics.txt
data = np.loadtxt('metrics.txt')

nThreads = data[:, 0]
speedup = data[:, 1]
efficiency = data[:, 2]

plt.style.use('ggplot')
with PdfPages('weak_scaling.pdf') as pdf:
    # SpeedUp Plot
    plt.plot([0, len(nThreads)+0.2], [0, len(nThreads)+0.2], color='black')  #Ideal SpeedUp
    plt.scatter(nThreads, speedup, color='green', label='SpeedUp')
    plt.xlabel('nThreads')
    plt.ylabel('SpeedUp')
    plt.title('SpeedUp')
    plt.xlim(0, len(nThreads)+0.2)
    plt.ylim(0, len(nThreads)+0.2)
    plt.gca().xaxis.set_major_locator(MaxNLocator(integer=True))
    plt.legend()
    pdf.savefig() 
    plt.close()
    
    #Efficiency Plot
    plt.plot([0, len(nThreads)+0.2], [1, 1], color='red')  # Ideal Efficiency
    plt.plot([0, len(nThreads)+0.2], [0.6, 0.6], color='blue')  #Aceptable Efficiency
    plt.scatter(nThreads, efficiency, color='green', label='Efficiency')  
    plt.xlabel('nThreads')
    plt.ylabel('Efficiency')
    plt.title('Efficiency')
    plt.xlim(0, len(nThreads)+0.2)
    plt.ylim(0, 1.1)
    plt.gca().xaxis.set_major_locator(MaxNLocator(integer=True))
    plt.legend()
    pdf.savefig()  
    plt.close()
"""
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.backends.backend_pdf import PdfPages
from matplotlib.ticker import MaxNLocator
import os

# Leer datos desde el archivo metrics.txt
data = np.loadtxt('metrics.txt', dtype={'names': ('executable', 'nThreads', 'speedup', 'efficiency'), 
                                        'formats': ('U10', 'i4', 'f4', 'f4')})

executables = np.unique(data['executable'])

# Configuración de la gráfica
plt.style.use('ggplot')
output_directory = "/home/zbarreto/Documents/IntroHPC_MFEM/escalamientoDebil/Gráficos/"
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

# Calcula la media y la desviación estándar para cada ejecutable y número de hilos
def calculate_mean_and_std(data, execs):
    means = []
    stds = []
    for exe in execs:
        exe_data = data[data['executable'] == exe]
        mean_speedup = np.mean(exe_data['speedup'])
        std_speedup = np.std(exe_data['speedup'])
        mean_efficiency = np.mean(exe_data['efficiency'])
        std_efficiency = np.std(exe_data['efficiency'])
        means.append((exe, mean_speedup, mean_efficiency))
        stds.append((exe, std_speedup, std_efficiency))
    return means, stds

means, stds = calculate_mean_and_std(data, executables)

# Plot de Speedup con barras de error
with PdfPages(os.path.join(output_directory, speedup_file)) as pdf:
    plt.figure()
    plt.plot([0, max(data['nThreads'])+0.2], [0, max(data['nThreads'])+0.2], color='black', label='Ideal SpeedUp')
    
    for mean, std in zip(means, stds):
        exe, mean_speedup, _ = mean
        _, std_speedup, _ = std
        exe_data = data[data['executable'] == exe]
        plt.errorbar(exe_data['nThreads'], exe_data['speedup'], yerr=std_speedup, fmt='o', label=f'SpeedUp {exe}')
    
    plt.xlabel('nThreads')
    plt.ylabel('SpeedUp')
    plt.title('SpeedUp')
    plt.xlim(0, max(data['nThreads'])+0.2)
    plt.ylim(0, max(data['nThreads'])+0.2)
    plt.gca().xaxis.set_major_locator(MaxNLocator(integer=True))
    plt.legend()
    pdf.savefig()
    plt.close()

# Plot de Efficiency con barras de error
with PdfPages(os.path.join(output_directory, efficiency_file)) as pdf:
    plt.figure()
    plt.plot([0, max(data['nThreads'])+0.2], [1, 1], color='red', label='Ideal Efficiency')
    plt.plot([0, max(data['nThreads'])+0.2], [0.6, 0.6], color='blue', label='Acceptable Efficiency')
    
    for mean, std in zip(means, stds):
        exe, _, mean_efficiency = mean
        _, _, std_efficiency = std
        exe_data = data[data['executable'] == exe]
        plt.errorbar(exe_data['nThreads'], exe_data['efficiency'], yerr=std_efficiency, fmt='o', label=f'Efficiency {exe}')
    
    plt.xlabel('nThreads')
    plt.ylabel('Efficiency')
    plt.title('Efficiency')
    plt.xlim(0, max(data['nThreads'])+0.2)
    plt.ylim(0, 1.1)
    plt.gca().xaxis.set_major_locator(MaxNLocator(integer=True))
    plt.legend()
    pdf.savefig()
    plt.close()


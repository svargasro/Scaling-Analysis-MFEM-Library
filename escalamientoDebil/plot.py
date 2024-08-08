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
data = np.loadtxt('metrics.txt')

nThreads = data[:, 0]
speedup = data[:, 1]
efficiency = data[:, 2]

# Función para generar un nombre de archivo único
def get_unique_filename(base_name, directory):
    counter = 1
    unique_name = f"{base_name}.pdf"
    while os.path.exists(os.path.join(directory, unique_name)):
        unique_name = f"{base_name}_{counter}.pdf"
        counter += 1
    return unique_name

# Directorio donde se guardarán los gráficos
output_directory = /home/zbarreto/Documents/IntroHPC_MFEM/escalamientoDebil/Gráficos/

# Asegúrate de que el directorio exista
os.makedirs(output_directory, exist_ok=True)

# Generar nombres únicos para los archivos PDF
speedup_file = get_unique_filename("weak_scaling_speedup", output_directory)
efficiency_file = get_unique_filename("weak_scaling_efficiency", output_directory)

plt.style.use('ggplot')

# Speedup Plot
with PdfPages(os.path.join(output_directory, speedup_file)) as pdf:
    plt.plot([0, len(nThreads)+0.2], [0, len(nThreads)+0.2], color='black')  # Ideal SpeedUp
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

# Efficiency Plot
with PdfPages(os.path.join(output_directory, efficiency_file)) as pdf:
    plt.plot([0, len(nThreads)+0.2], [1, 1], color='red')  # Ideal Efficiency
    plt.plot([0, len(nThreads)+0.2], [0.6, 0.6], color='blue')  # Acceptable Efficiency
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

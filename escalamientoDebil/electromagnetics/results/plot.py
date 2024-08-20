import matplotlib.pyplot as plt
import numpy as np
import argparse
from matplotlib.backends.backend_pdf import PdfPages
from matplotlib.ticker import MaxNLocator
import os


parser = argparse.ArgumentParser(description="Generar gráficas de SpeedUp y Eficiencia")
parser.add_argument('input_file', type=str, help='Nombre del archivo de texto con los datos')
args = parser.parse_args()

time = np.loadtxt(args.input_file)


# Extract the file name without the extension
file_name = os.path.splitext(os.path.basename(args.input_file))[0]
print('file_name:', file_name)

# Extract the target and order from the file name
target = file_name.split('_')[1]
order = file_name.split('_')[3]

print('target:', target)
print('order:', order)


nThreads = time[:, 0]
speedup = time[0, 1] / time[:, 1]
efficiency = speedup / time[:, 0]

mean_speedup = np.mean(speedup)
std_speedup = np.std(speedup)
mean_efficiency = np.mean(efficiency)
std_efficiency = np.std(efficiency)

# Leer datos desde el archivo metrics.txt


'metrics_'
output='/resultados/graficas/weak_scaling_'+ str(target) +'_order_' + str(order) +'.pdf'

nThreads = data[:, 0]
speedup = data[:, 1]
efficiency = data[:, 2]

plt.style.use('ggplot')
with PdfPages(output) as pdf:
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
    plt.title('SpeedUp de ' + str(target) + ' con orden ' + str(order))
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
    plt.title('Eficiencia de ' + str(target) + ' con orden ' + str(order))
    pdf.savefig()  
    plt.close()


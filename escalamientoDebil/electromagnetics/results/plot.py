import matplotlib.pyplot as plt
import numpy as np
import argparse
from matplotlib.backends.backend_pdf import PdfPages
from matplotlib.ticker import MaxNLocator


parser = argparse.ArgumentParser(description="Generar gráficas de SpeedUp y Eficiencia")
parser.add_argument('input_file', type=str, help='Nombre del archivo de texto con los datos')
parser.add_argument('--order', type=str, help='Orden de interpoalcion de la ejecucion')


args = parser.parse_args()


# Leer datos desde el archivo metrics.txt
data = np.loadtxt(args.input_file)
order = args.order

output='results/graficas/weak_scaling_order=' + str(order) +'.pdf'

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


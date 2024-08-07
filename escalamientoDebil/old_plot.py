import matplotlib.pyplot as plt
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


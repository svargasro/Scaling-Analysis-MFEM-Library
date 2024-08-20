import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import argparse
from matplotlib.backends.backend_pdf import PdfPages
from matplotlib.ticker import MaxNLocator
import os

parser = argparse.ArgumentParser(description="Generar gráficas de SpeedUp y Eficiencia")
parser.add_argument('input_file', type=str, help='Nombre del archivo de texto con los datos')
args = parser.parse_args()

time = pd.read_csv(f'{args.input_file}',header=None)

time = time.drop(time.columns[0], axis=1)



nThreads = time.shape[0]
#SpeedUp= T(1Thread)/T(Nthreads)

speedup = time.iloc[0,:] /time.iloc[:,:]

threadsArray = np.arange(1,nThreads+1)
efficiency = speedup/(threadsArray.reshape(-1, 1))

mean_speedup = speedup.mean(axis=1)
std_speedup = speedup.std(axis=1)
mean_efficiency = efficiency.mean(axis=1)
std_efficiency = efficiency.std(axis=1)

# Extract the file name without the extension
file_name = os.path.splitext(os.path.basename(args.input_file))[0]
print('file_name:', file_name)

# Extract the target and order from the file name
target = file_name.split('_')[1]
order = file_name.split('_')[3]

print('target:', target)
print('order:', order)

# Leer datos desde el archivo metrics.txt


output='./resultados/graficas/weak_scaling_'+ str(target) +'order' + str(order) +'.pdf'

errorbarSpeedUp = 10*std_speedup
errorbarEfficiency = 10*std_efficiency
plt.style.use('ggplot')




with PdfPages('weak_scaling.pdf') as pdf:
    # SpeedUp Plot

    plt.plot([0, len(threadsArray)+0.2], [0, len(threadsArray)+0.2], color='black')  #Ideal SpeedUp
    plt.errorbar(threadsArray, mean_speedup, yerr= errorbarSpeedUp, fmt='go', ecolor='black', markersize=3, label='SpeedUp')
    plt.xlabel('nThreads')
    plt.ylabel('SpeedUp')
    plt.title('SpeedUp de ' + str(target) + ' con orden ' + str(order))
    plt.xlim(0, len(threadsArray)+0.2)
    plt.ylim(0, len(threadsArray)+0.2)
    plt.gca().xaxis.set_major_locator(MaxNLocator(integer=True))
    plt.legend()
    pdf.savefig()
    plt.close()

    #Efficiency Plot
    plt.plot([0, len(threadsArray)+0.2], [1, 1], color='red')  # Ideal Efficiency
    plt.plot([0, len(threadsArray)+0.2], [0.6, 0.6], color='blue')  #Aceptable Efficiency
    plt.errorbar(threadsArray, mean_efficiency, yerr= errorbarEfficiency, fmt='go', ecolor='black', markersize=3, label='Efficiency')
    plt.xlabel('nThreads')
    plt.ylabel('Efficiency')
    plt.title('Eficiencia de ' + str(target) + ' con orden ' + str(order))
    plt.xlim(0, len(threadsArray)+0.2)
    plt.ylim(0, 1.1)
    plt.gca().xaxis.set_major_locator(MaxNLocator(integer=True))
    plt.legend()
    pdf.savefig()
    plt.close()

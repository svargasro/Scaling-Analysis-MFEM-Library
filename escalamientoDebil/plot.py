import matplotlib.pyplot as plt
import numpy as np
import os
from matplotlib.backends.backend_pdf import PdfPages
from matplotlib.ticker import MaxNLocator

# Buscar todos los archivos metrics en el directorio actual
file ='metrics.txt'


# Leer datos desde todos los archivos metrics
data = np.loadtxt(file, dtype={'names': ('nThreads', 'speedup', 'errorspeedup', 'efficiency', 'errorefficiency'),
                                   'formats': ('i4', 'f4', 'f4', 'f4', 'f4')})

# Configuración de la gráfica

 # Primer plot: Speedup
plt.figure()
plt.plot([0, len(data['nThreads']) + 0.2], [0, len(data['nThreads']) + 0.2], color='black')  # Ideal SpeedUp
plt.scatter(data['nThreads'], data['speedup'])
plt.errorbar(data['nThreads'], data['speedup'], yerr=data['errorspeedup'], fmt='o')
plt.xlabel('Number of Threads')
plt.ylabel('Speedup')
plt.title(f'Speedup')
#plt.legend()
plt.grid(True)
plt.savefig("Speedup.pdf")

# Segundo plot: Efficiency
plt.figure()
plt.plot([0, len(data['nThreads']) + 0.2], [1, 1], color='red')  # Ideal Efficiency
plt.plot([0, len(data['nThreads']) + 0.2], [0.6, 0.6], color='blue')  # Acceptable Efficiency
plt.scatter(data['nThreads'], data['efficiency'])
plt.errorbar(data['nThreads'], data['efficiency'], yerr=data['errorefficiency'], fmt='o')
plt.xlabel('Number of Threads')
plt.ylabel('Efficiency')
plt.title(f'Efficiency')
#plt.legend()
plt.grid(True)
plt.savefig("Efficiency.pdf")


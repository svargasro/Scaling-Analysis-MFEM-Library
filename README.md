# IntroHPC_MFEM
Repository to develop the final project of Introduction to High Performance Computing at UNAL.

# Instrucciones para correr el escalamiento. 
*Para las siguientes instrucciones, todos los PATHS indicados serán relativos.*

1. Descargar e instalar MFEM siguiendo los pasos del tutorial https://mfem.org/building/ Ignorar la parte de GLVIS.
2. Descargar y descomprimir la carpeta .zip de este proyecto. 
3. Pasar los archivos ex1p.cpp que se encuentran en el directorio cpp_y_ejecutables a la carpeta examples de mfem. 

3. Mover los archivos .cpp del directorio /cpp_y_ejecutables a las carpetas de MFEM:
     *Para ejemplos 1 y 39*
   - Reemplazar los archivos ex1p.cpp y ex39p.cpp en la siguiente dirección:
     /mfem-4.7/examples
     Puede usar el siguiente comando en la terminal:
     cp ex1p.cpp /mfem-4.7/examples
     *Para miniapp volta*
   - Reemplazar el archivo volta.cpp a la siguiente dirección:
     /mfem-4.7/miniapps/electromagnetics
     Puedes usar el siguiente comando en la terminal:
     cp volta.cpp /mfem-4.7/miniapps/electromagnetics

4. Cambiar de directorio:
   - Navega al directorio donde se encuentra el archivo copiado:
     *Para ejemplos 1 y 39*
     cd /mfem-4.7/examples
     *Para miniapp volta*
     cd /mfem-4.7/miniapps/electromagnetics

5. Compilar la miniapp y los ejemplos:
   *Para ejemplos 1 y 39*
    - Ejecute los siguientes comandos para compilar ex1p.cpp y ex39p.cpp:
      make ex1p
      make ex39p
   
   *Para miniapp volta*
   - Ejecuta el siguiente comando para compilar volta.cpp:
     make volta

6. Copiar los ejecutables a la carpeta cpp_y_ejecutables:
   *Para ejemplos 1 y 39*
   - Una vez compilado, copie el ejecutable generado a la carpeta cpp_y_ejecutables:
     cp ex1p /cpp_y_ejecutables
     cp ex39p /cpp_y_ejecutables

    *Para miniapp volta*
    - Una vez compilado, copie el ejecutable generado a la carpeta cpp_y_ejecutables:
     cp volta /cpp_y_ejecutables

7. Otorgar permisos de ejecución a los scripts:
   - Darle permisos de ejecución a los scripts de sh, concediento permisos a la carpeta con el siguiente comando:
     chomd -R +x IntroHPC_MFEM  #IntroHPC_MFEM es el nombre de la carpeta .zip

8. Ejecutar el script:
   - Para ejecutar los escalamientos débil, fuerte y monitoreo de RAM, correr el script scaling.sh:
    ./scaling.sh 
   *Dentro del script scaling.sh se encuentran instrucciones de cómo variar los parámetros para cada escalamiento.*
   *Por defecto se corre para valores bajos de orden, repeticiones y threads*


Notas Adicionales:
- Todos los resultados obtenidos y reportados tienen la palabra "Final" al inicio del nombre del archivo para evitar que se sobreescriba ó se elimine por error al ejecutar. 
- En caso de que quiera cambiar los parámetros para los que corre el escalamiento, dirígase a scaling.sh.


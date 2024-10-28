# IntroHPC_MFEM
Repository for developing the final project of Introduction to High Performance Computing at UNAL.

Link to the repository: https://github.com/AFMartinezF/IntroHPC_MFEM.git

Link to the explanatory video: https://youtu.be/D8S_hBBu0Lo

## Instructions to run the scaling. 
*For the following instructions, all indicated PATHS will be relative.*

1. Download and install MFEM following the steps in the tutorial https://mfem.org/building/. To run the examples, it is necessary to compile the parallel version of MFEM with MPI. You can ignore the GLVIS part as the examples have been modified not to send information to the visualization port.

2. Download and unzip the .zip folder of this project.

3. Move the .cpp files from the /cpp_y_ejecutables directory to the MFEM folders:

    **For examples 1 and 39**
     
   - Replace the files ex1p.cpp and ex39p.cpp in the following directory:
     /mfem-4.7/examples
     You can use the following command in the terminal:
     ```
     cp ex1p.cpp /mfem-4.7/examples
     ```
     
    **For miniapp volta**
     
   - Replace the file volta.cpp in the following directory:
     /mfem-4.7/miniapps/electromagnetics
     You can use the following command in the terminal:
     ```
     cp volta.cpp /mfem-4.7/miniapps/electromagnetics
     ```

4. Change directory:
   - Navigate to the directory where the copied file is located:
     
     **For examples 1 and 39**
     ```
     cd /mfem-4.7/examples
     ```
     
     **For miniapp volta**
     ```
     cd /mfem-4.7/miniapps/electromagnetics
     ```

5. Compile the miniapp and the examples:

   **For examples 1 and 39**
   
    - Execute the following commands to compile ex1p.cpp and ex39p.cpp:

      ```
      make ex1p
      make ex39p
      ```
   
   **For miniapp volta**
   
   - Run the following command to compile volta.cpp:

     ```
     make volta
     ```

6. Copy the executables to the cpp_y_ejecutables folder:
   
   **For examples 1 and 39**
   
   - Once compiled, copy the generated executable to the cpp_y_ejecutables folder:
     ```
     cp ex1p /cpp_y_ejecutables
     cp ex39p /cpp_y_ejecutables
     ```

    **For miniapp volta**
    
    - Once compiled, copy the generated executable to the cpp_y_ejecutables folder:
    ```
    cp volta /cpp_y_ejecutables
    ```

7. Grant execution permissions to the scripts:
   - Grant execution permissions to the .sh scripts, providing permissions to the folder with the following command:
     ```
     chmod -R +x IntroHPC_MFEM
     ```
     IntroHPC_MFEM is the name of the .zip folder.

8. Run the script:
   - To execute weak scaling, strong scaling, and RAM monitoring, run the script scaling.sh:
    ```
    ./scaling.sh
    ```

   *Inside the scaling.sh script, there are instructions on how to vary the parameters for each scaling.*
   *By default, it runs for low values of order, repetitions, and threads.*

Additional Notes:
- All obtained and reported results have the word "Final" at the beginning of the file name to prevent overwriting or accidental deletion when running.
- If you want to change the parameters for the scaling runs, go to scaling.sh.
- Keep in mind that running ./scaling twice with the same parameters will overwrite the generated files.
- For graphs with Python, ensure that Pandas, Matplotlib, and Scipy are installed.
- All generated files and graphs can be found in the /results folder within /weakScaling and /strongScaling.

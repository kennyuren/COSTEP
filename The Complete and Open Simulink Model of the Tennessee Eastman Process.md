## **1. Introduction**

The complete and open Simulink of the Tennessee Eastman process (COSTEP) model is an open and flexible Simulink model designed for generating data to support various process control and fault detection experiments and analyses. Users of the model can configure parameters to their choosing by changing starting value or implement new functions using the base model parameters. This guide will provide detailed instructions on configuring and running the model, as well as explaining the resulting data for better use in specific experimental goals.

---

## **2. Directory Contents

The following directory contains Simulink and MATLAB code as described in the paper  **A complete and open Simulink model of the Tennessee Eastman process, J. Vosloo, K. Uren and G. Van Schoor** 

| Filename          | Description                                                       |
| ----------------- | ----------------------------------------------------------------- |
| COSTEP.slx        | Simulink model of the complete and open Tennessee Eastman process |
| mylib.slx         | The customer library                                              |
| COSTEP_Exergy.slx | COSTEP model with an added exergy analysis function               |
| COSTEP_Cost.slx   |                                                                   |


---

## **3. Configuring the Simulink Model**

### **3.1 Dedicated Experiment Block**

To conduct an experiment, create a dedicated block in Simulink to execute your chosen FSO(s). For example:

- **Exergy Analysis:** Add blocks to calculate and log exergy and energy for process streams.
- **Techno-economic Analysis:** Incorporate blocks to compute and log operational costs.

### **3.2 Simulation Parameters**

#### **3.2.1 Disturbance Off/On Block**

- Navigate to the _Disturbance off/on_ block in Simulink.
- Select the desired disturbance or fault and specify its activation time (e.g., 200 seconds).

#### **3.2.2 Control Loop Block**

Currently the model is setup to be able to run the process using the following control mode selection:
    - **Open loop:** Which has no controller implemented on any of the specified manipulated variables. When using this control mode, please note that the process is open loop unstable and will trigger the shut down procedure when run for long enough. 
    - **Braatz controller:** This controller mode implements the control strategy as described by Lyman et. al., with control parameters as described by Braatz, et. al.
    - **Ricker controller:** This controller mode implements the control strategy as described by Ricker (get the reference)


#### **3.2.3 Mode of Operation**

- Configure feed streams A, C, D, and E to set the operating mode.
- For Mode 1 (base case), use the default values from Downs and Vogel (1993).

#### **3.2.4 Random Number Block**

- Set the seed for noise generation to ensure repeatable simulation results.
- Example:
    
    matlab
    
    Copy code
    
    `set_param('COSTEP/RandomNumber', 'Seed', '12345');`
    

#### **3.2.6 Simulation Time

- Specify the solver and simulation time:
    - Example solver: _ode45_ or _ode15s_ for stiff systems.
    - Example simulation time: 500 seconds.

---

## **4. Running the Simulation**

### **4.1 Running the Simulation Using MATLAB Script**

Run the Simulink model from MATLAB for automation and reproducibility:

1. Load the model:
    
    matlab
    
    Copy code
    
    `load_system('COSTEP');`
    
2. Set parameters programmatically (optional):
    
    matlab
    
    Copy code
    
    `set_param('COSTEP/DisturbanceOffOn', 'Value', '1'); set_param('COSTEP/ControlLoop', 'Value', 'Ricker');`
    
3. Run the simulation:
    
    matlab
    
    Copy code
    
    `simOut = sim('COSTEP', 'SimulationMode', 'normal', ...              'StopTime', '500', ...              'SaveOutput', 'on', ...              'OutputSaveName', 'yout');`
    
4. Access results:
    
    matlab
    
    Copy code
    
    `workspaceVariables = simOut.get('yout');`
    

### **4.2 Accessing and Analyzing Results**

After running the simulation, the workspace will contain:

- **Measured Variables:** Recorded sensor readings during simulation.
- **Manipulated Variables:** Actuator settings during simulation.
- **Experiment-Specific Variables:** Depends on the experiment type:
    - Exergy analysis: Exergy and energy in process streams.
    - Techno-economic analysis: Cost-related variables.

---

## **5. Exporting Results**

Export the simulation results to external files for further analysis:

- **To CSV:**
    
    matlab
    
    Copy code
    
    `writematrix(workspaceVariables, 'results.csv');`
    
- **To Excel:**
    
    matlab
    
    Copy code
    
    `writematrix(workspaceVariables, 'results.xlsx');`
    
- **MATLAB-Specific Files:**
    
    matlab
    
    Copy code
    
    `save('results.mat', 'workspaceVariables');`
    

---

## **6. Troubleshooting and Tips**

- **Issue:** Simulation fails to start.  
    **Solution:** Ensure all required blocks are configured, and parameters are set.
- **Issue:** Noisy results during analysis.  
    **Solution:** Adjust the random seed in the Random Number block for consistency.

### **General Tips**

- Save a backup of the model before making major changes.
- Use version control (e.g., Git) to track model modifications.
- Enable logging in Simulink to debug runtime issues.

---

## **7. References**

*  J. J. Downs, E. F. Vogel, A plant-wide industrial process control problem,
Computers & chemical engineering 17 (3) (1993) 245–255.
* P. R. Lyman, C. Georgakis, Plant-wide control of the tennessee eastman
problem, Computers & chemical engineering 19 (3) (1995) 321–331.
[3] N. Ricker, Tennessee eastman challenge archive (2005).
URL https://depts.washington.edu/control/LARRY/TE/download.
html
[4] A. Bathelt, N. L. Ricker, M. Jelali, Revision of the tennessee eastman
process model, IFAC-PapersOnLine 48 (8) (2015) 309–314.
[5] C. Martin-Villalba, A. Urquia, G. Shao, Implementations of the tennessee
eastman process in modelica, IFAC-PapersOnLine 51 (2) (2018) 619–624.
[6] C. Reinartz, M. Kulahci, O. Ravn, An extended tennessee eastman simu-
lation dataset for fault-detection and decision support systems, Comput-
ers & Chemical Engineering 149 (2021) 107281.
[7] C. Reinartz, T. T. Enevoldsen, pytep: A python package for interactive
simulations of the tennessee eastman process, SoftwareX 18 (2022)
101053. doi:https://doi.org/10.1016/j.softx.2022.101053.
URL https://www.sciencedirect.com/science/article/pii/
S2352711022000449
8
[8] L. Chiang, E. Russell, R. Braatz, Fault Detection and Diagnosis in In-
dustrial Systems, Advanced Textbooks in Control and Signal Processing,
Springer London, 2000.
URL https://books.google.co.za/books?id=G71zWeHzg2QC
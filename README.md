# The Complete and Open Simulink Model of the Tennessee Eastman Process
## **1. Introduction**

The complete and open Simulink of the Tennessee Eastman process (COSTEP) model is an open and flexible Simulink model designed for generating data to support various process control and fault detection experiments and analyses. Users of the model can configure parameters to their choosing by changing starting value or implement new functions using the base model parameters. This guide will provide detailed instructions on configuring and running the model, as well as explaining the resulting data for better use in specific experimental goals.

---

## **2. Directory Contents

This directory contains Simulink and MATLAB code as described in the paper  **A complete and open Simulink model of the Tennessee Eastman process, J. Vosloo, K. Uren and G. Van Schoor** 

| Filename          | Description                                                                            |
| ----------------- | -------------------------------------------------------------------------------------- |
| COSTEP.slx        | Simulink model of the complete and open Tennessee Eastman process                      |
| mylib.slx         | The custom library                                                                     |
| COSTEP_Auto.slx   | Simulink model of the complete and open Tennessee Eastman process                      |
| Auto_run_COSTEP.m | Example of MATLAB code that can be used to automatically generate various sets of data |
| COSTEP_Exergy.slx | COSTEP model with an added exergy analysis function                                    |

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
- **Custom controller:** This is where a user can enable their own control strategy. Currently if picked it would mimic an open loop mode selection. User configuration will be needed to implement their own control mode version. 

The control mode selection can be done by changing the block parameters of the control mode block as can be seen in the figure below. The initial valve positions can also be specified or changed if needed. 

![[Pasted image 20241205070520.png]]
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
    

| COSTEP Result Variable | Description                                                             | Other Name | Unit  |
| ---------------------- | ----------------------------------------------------------------------- | ---------- | ----- |
| SMEAST(1)              | Temperature of feed stream of component A (stream 1)                    |            | &degC |
| SMEASP(1)              | Pressure of feed stream of component A (stream 1)                       |            | kPa   |
| SMEASF(1)              | Mass flow of feed stream of component A (stream 1)                      | XMEAS(1)   | kg/h  |
| SMEASXA(1)             | Composition of component A in feed stream of component A (stream 1)     |            | mol%  |
| SMEASXB(1)             | Composition of component B in feed stream of component A (stream 1)     |            | mol%  |
| SMEAST(2)              | Temperature of feed stream of component D (stream 2)                    |            | &degC |
| SMEASP(2)              | Pressure of feed stream of component D (stream 2)                       |            | kPa   |
| SMEASF(2)              | Mass flow of feed stream of component D (stream 2)                      | XMEAS(2)   | kg/h  |
| SMEASXB(2)             | Composition of component B in feed stream of component D (stream 2)     |            | mol%  |
| SMEASXD(2)             | Composition of component D in feed stream of component D (stream 2)     |            | mol%  |
| SMEAST(3)              | Temperature of feed stream of component E (stream 3)                    |            | &degC |
| SMEASP(3)              | Pressure of feed stream of component E (stream 3)                       |            | kPa   |
| SMEASF(3)              | Mass flow of feed stream of component E (stream 3)                      | XMEAS(3)   | kg/h  |
| SMEASXE(3)             | Composition of component E in feed stream of component E (stream 3)     |            | mol%  |
| SMEASXF(3)             | Composition of component F in feed stream of component E (stream 3)     |            | mol%  |
| SMEAST(4)              | Temperature of feed stream of component A/B/C (stream 4)                |            | &degC |
| SMEASP(4)              | Pressure of feed stream of component A/B/C (stream 4)                   |            | kPa   |
| SMEASF(4)              | Mass flow of feed stream of component A/B/C (stream 4)                  | XMEAS(4)   | kg/h  |
| SMEASXA(4)             | Composition of component A in feed stream of component A/B/C (stream 4) |            | mol%  |
| SMEASXB(4)             | Composition of component B in feed stream of component A/B/C (stream 4) |            | mol%  |
| SMEASXC(4)             | Composition of component C in feed stream of component A/B/C (stream 4) |            | mol%  |
| SMEAST(5)              | Temperature of stripper recycle stream (stream 5)                       |            | &degC |
| SMEASP(5)              | Pressure of stripper recycle stream (stream 5)                          | XMEAS(16)  | kPa   |
| SMEASF(5)              | Mass flow of stripper recycle stream (stream 5)                         |            | kg/h  |
| SMEASXA(5)             | Composition of component A in stripper recycle stream (stream 5)        |            | mol%  |
| SMEASXB(5)             | Composition of component B in stripper recycle stream (stream 5)        |            | mol%  |
| SMEASXC(5)             | Composition of component C in stripper recycle stream (stream 5)        |            | mol%  |
| SMEASXD(5)             | Composition of component D in stripper recycle stream (stream 5)        |            | mol%  |
| SMEASXE(5)             | Composition of component E in stripper recycle stream (stream 5)        |            | mol%  |
| SMEASXF(5)             | Composition of component F in stripper recycle stream (stream 5)        |            | mol%  |
| SMEASXG(5)             | Composition of component G in stripper recycle stream (stream 5)        |            | mol%  |
| SMEASXH(5)             | Composition of component H in stripper recycle stream (stream 5)        |            | mol%  |
| SMEAST(6)              | Temperature of reactor feed stream (stream 6)                           |            | &degC |
| SMEASP(6)              | Pressure of reactor feed stream (stream 6)                              | XMEAS(16)  | kPa   |
| SMEASF(6)              | Mass flow of reactor feed stream (stream 6)                             | XMEAS(6)   | kg/h  |
| SMEASXA(6)             | Composition of component A in reactor feed stream (stream 6)            |            | mol%  |
| SMEASXB(6)             | Composition of component B in reactor feed stream (stream 6)            |            | mol%  |
| SMEASXC(6)             | Composition of component C in reactor feed stream (stream 6)            |            | mol%  |
| SMEASXD(6)             | Composition of component D in reactor feed stream (stream 6)            |            | mol%  |
| SMEASXE(6)             | Composition of component E in reactor feed stream (stream 6)            |            | mol%  |
| SMEASXF(6)             | Composition of component F in reactor feed stream (stream 6)            |            | mol%  |
| SMEASXG(6)             | Composition of component G in reactor feed stream (stream 6)            |            | mol%  |
| SMEASXH(6)             | Composition of component H in reactor feed stream (stream 6)            |            | mol%  |
| SMEAST(7)              | Temperature of reactor feed stream (stream 6)                           |            | &degC |
| SMEASP(7)              | Pressure of reactor feed stream (stream 6)                              | XMEAS(16)  | kPa   |
| SMEASF(7)              | Mass flow of reactor feed stream (stream 6)                             | XMEAS(6)   | kg/h  |
| SMEASXA(7)             | Composition of component A in reactor feed stream (stream 6)            |            | mol%  |
| SMEASXB(7)             | Composition of component B in reactor feed stream (stream 6)            |            | mol%  |
| SMEASXC(7)             | Composition of component C in reactor feed stream (stream 6)            |            | mol%  |
| SMEASXD(7)             | Composition of component D in reactor feed stream (stream 6)            |            | mol%  |
| SMEASXE(7)             | Composition of component E in reactor feed stream (stream 6)            |            | mol%  |
| SMEASXF(7)             | Composition of component F in reactor feed stream (stream 6)            |            | mol%  |
| SMEASXG(7)             | Composition of component G in reactor feed stream (stream 6)            |            | mol%  |
| SMEASXH(7)             | Composition of component H in reactor feed stream (stream 6)            |            | mol%  |
|                        |                                                                         |            |       |
|                        |                                                                         |            |       |
|                        |                                                                         |            |       |

---

## **Troubleshooting and Tips**

- **Issue:** Simulation fails to start.  
    **Solution:** Ensure all required blocks are configured, and parameters are set.
- **Issue:** Noisy results during analysis.  
    **Solution:** Adjust the random seed in the Random Number block for consistency.

### **General Tips**

- Save a backup of the model before making major changes.
- Use version control (e.g., Git) to track model modifications.
- Enable logging in Simulink to debug runtime issues.

---

## **References**

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

___
## **Cite this repository **

To cite the use of this repository, please use the following reference:

Vosloo, J., Uren, K. & Van Schoor, G. Complete and open Simulink model of the Tennessee Eastman process. (2024). URL: https://github.com/kennyuren/COSTEP

---

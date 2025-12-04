% Matlab Script to run TEP Simulink automatically, through all faults

% Ask user which Simulink model to run
prompt = 'Enter the Simulink model name (without .slx extension): ';
modelName = input(prompt, 's');

% Ask user which faults to simulate
prompt = 'Enter fault scenarios to run (e.g., 1, or [1 2 8], or 1:29): ';
faultList = input(prompt);

% First capture simulation times and load constant variables
prompt = 'What is the simulation time for training data in hours? ';
Trainh = input(prompt);

prompt = 'What is the simulation time for testing data in hours? ';
Testh = input(prompt);

prompt = 'After how many hours should the fault be introduced for training data? ';
TrainF = input(prompt);

prompt = 'After how many hours should the fault be introduced for testing data? ';
TestF = input(prompt);

prompt = 'In what mode should the process run? ';
M = input(prompt);

SimTime = {Trainh, Testh};
load('G.mat');
load('IDV.mat');
SimFault = {TrainF, TestF};

SimData = {SimTime; G; IDV; SimFault};
SimData{1,2} = 'Simulation Time in hours';
SimData{2,2} = 'Random numbers';
SimData{3,2} = 'Fault Indicator';
SimData{4,2} = 'Hours after fault is introduced';
SimData{5,2} = 'Process Mode';

% First clear the workspace and keep only SimData
clearvars -except SimData modelName faultList

% Load Simulink model
load_system(modelName);

% Training dataset
Train_Data = cell(29,8);

for i = faultList % user-selected fault scenarios

    % Random number generator G
    G = SimData{2,1}(i,1);
    set_param([modelName '/Random number generator/Constant'], 'Value', 'G');

    % Fault Indicator
    IDV = SimData{3,1}(1:28,i);
    for k = 1:28
        blockPath = sprintf('%s/Disturbances/IDV from check box/Constant%d', modelName, k);
        set_param(blockPath, 'Value', num2str(IDV(k)));
    end

    % Time when fault is introduced
    DD = SimData{4,1}{1,1};
    set_param([modelName '/Disturbances/Constant'], 'Value', 'DD');

    % Run the simulation
    tstart = 0;
    tend = SimData{1,1}{1,1};
    sim(modelName, 'StartTime', 'tstart', 'StopTime', 'tend');

    % Save the results
    Train_Data{i,1} = G;
    Train_Data{i,2} = IDV;
    Train_Data{i,3} = i-1;
    Train_Data{i,4} = ans.XMEAS;
    Train_Data{i,5} = ans.XMV;
    Train_Data{i,6} = ans.SM;
    Train_Data{i,7} = ans.IDV_1;
    Train_Data{i,8} = ans.IDV_13;
    Train_Data{i,9} = ans.IDV_13b;
    Train_Data{i,10} = ans.IDV_14;
    Train_Data{i,8} = ans.IDV_15;
    Train_Data{i,8} = ans.IDV_16;
    Train_Data{i,8} = ans.IDV_17;
    Train_Data{i,8} = ans.IDV_18;
    Train_Data{i,8} = ans.IDV_13;
    Train_Data{i,8} = ans.IDV_13;
    

end

% Testing dataset
Test_Data = cell(29,8);

for j = 1 % user-selected fault scenarios

    % Random number generator G
    G = SimData{2,1}(j,2);
    set_param([modelName '/Random number generator/Constant'], 'Value', 'G');

    % Fault Indicator
    IDV = SimData{3,1}(1:28,j);
    for k = 1:28
        blockPath = sprintf('%s/Disturbances/IDV from check box/Constant%d', modelName, k);
        set_param(blockPath, 'Value', num2str(IDV(k)));
    end

    % Time when fault is introduced
    DD = SimData{4,1}{1,2};
    set_param([modelName '/Disturbances/Constant'], 'Value', 'DD');

    % Run the simulation
    tstart = 0;
    tend = SimData{1,1}{1,2};
    sim(modelName, 'StartTime', 'tstart', 'StopTime', 'tend');

    % Save the results
    Test_Data{j,1} = G;
    Test_Data{j,2} = IDV;
    Test_Data{j,3} = j-1;
    Test_Data{j,4} = ans.XMEAS;
    Test_Data{j,5} = ans.XMV;
    Test_Data{j,6} = ans.SM;

end

% Save the datasets
save("file_location/file_name","SimData","Train_Data","Test_Data","-mat");

%Matlab Script to run TEP Simulink automatically, through all faults

%First capture simulation times and load constant variables for random
%numbers and faults

prompt = 'What is the simulation time for training data in hours';
Trainh = input(prompt); %specify the simulation time

prompt = 'What is the simulation time for testing data in hours';
Testh = input(prompt); %specify the simulation time

prompt = 'After how many hours should the fault be introduced for training data';
TrainF = input(prompt); %specify the fault introduction

prompt = 'After how many hours should the fault be introduced for testing data';
TestF = input(prompt); %specify the fault introduction

SimTime = {Trainh, Testh};
load('G.mat');
load('IDV.mat');
SimFault = {TrainF, TestF};

SimData = {SimTime;G;IDV;SimFault};
SimData{1,2} = 'Simulation Time in hours';
SimData{2,2} = 'Random numbers';
SimData{3,2} = 'Fault Indicator';
SimData{4,2} = 'Hours after fault is introduced';

%First clear the workspace and keep only SimData

clearvars -except SimData

%Assign value to variables for diffirent runs

%First open the simulink model

load_system('TEP_NoisefastTempComp_Script');

%Training dataset

Train_Data=cell(21,8); %assign empty cell to capture the variables

for i=1 %different fault scenarios, 1-NOC, 2-Fault1, ens.

%Random number genereator G

G=SimData{2,1}(i,1); %SimData{2,1}((NOC,Faults),(1-Training, 2-Testing)) G
set_param('TEP_NoisefastTempComp_Script/Random number generator/Gain','Gain','G');

%Fault Indicator

IDV=SimData{3,1}(1:20,i); %SimData{3,1}(Fault1:Fault20,1(NOC, Fault1, ens)) IDV
set_param('TEP_NoisefastTempComp_Script/Disturbances/Constant2','Value','IDV');

%Time when fault is introduced

DD=SimData{4,1}{1,1}; %Distubance Delay
set_param('TEP_NoisefastTempComp_Script/Disturbances/Constant','Value','DD');

%Run the simulation

tstart = 0; %Ensure the simulation begins from time 0
tend = SimData{1,1}{1,1}; %Stipulates how log the current run will be
sim('TEP_NoisefastTempComp_Script','StartTime','tstart','StopTime','tend');

%Save the variables of the simulink run

Train_Data{i,1}=ans.Q;
Train_Data{i,2}=ans.B;
Train_Data{i,3}=G;
Train_Data{i,4}=IDV;
Train_Data{i,5}=i-1;
Train_Data{i,6}=ans.XMEAS0;
Train_Data{i,7}=ans.XMV0;
Train_Data{i,8}=ans.SM;

%save("D:\PhD\Data\TEP\Simulink\Change control\Shutdown corrected\TEPExergyTrainSM","SimData","Train_Data");

end



%Testing Dataset

Test_Data=cell(21,8); %assign empty cell to capture the variables

for j=1:21 %different fault scenarios, 1-NOC, 2-Fault1, ens.

%Random number genereator G

G=SimData{2,1}(j,2); %SimData{2,1}((NOC,Faults),(1-Training, 2-Testing)) G
set_param('TEP_NoisefastTempComp_Script/Random number generator/Gain','Gain','G');

%Fault Indicator

IDV=SimData{3,1}(1:20,j); %SimData{3,1}(Fault1:Fault20,1(NOC, Fault1, ens)) IDV
set_param('TEP_NoisefastTempComp_Script/Disturbances/Constant2','Value','IDV');

%Time when fault is introduced

DD=SimData{4,1}{1,2}; %Distubance Delay
set_param('TEP_NoisefastTempComp_Script/Disturbances/Constant','Value','DD');

%Run the simulation

tstart = 0; %Ensure the simulation begins from time 0
tend = SimData{1,1}{1,2}; %Stipulates how log the current run will be
sim('TEP_NoisefastTempComp_Script','StartTime','tstart','StopTime','tend');

%Save the variables of the simulink run

Test_Data{j,1}=ans.Q;
Test_Data{j,2}=ans.B;
Test_Data{j,3}=G;
Test_Data{j,4}=IDV;
Test_Data{j,5}=j-1;
Test_Data{j,6}=ans.XMEAS0;
Test_Data{j,7}=ans.XMV0;
Test_Data{j,8}=ans.SM;

%save("D:\PhD\Data\TEP\Simulink\Change control\Shutdown corrected\TEPExergyTestSM","SimData","Test_Data");

end

%Save the datasets

save("D:\PhD\Data\TEP\Simulink\Change control\Shutdown corrected\TEP Final\TEPSM","SimData","Train_Data","Test_Data");

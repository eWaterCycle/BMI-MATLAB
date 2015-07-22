%% clean
clear all
close all
clc


%% settings



%Directories:
runDir = '.';
dataDir = [runDir filesep 'data'];
modelDir = [runDir filesep 'models'];
classDir = [runDir filesep '..'];

addpath(modelDir);
addpath(classDir);

%the model in matlab state model format (ie. state_out = model(parameters, state_in, n_timesteps) )
modelHandle = @toyModelMatlabModel;

dimensions = [10 10];
dt = 1;
startTime = 0;
endTime = 20;

%% create model


toyModelObj=stateModelBMI(modelHandle,dimensions,startTime,endTime,dt);


%% run model, save all steps as csv files

%step 1: initialize
toyModelObj.initialize;
%save state to file
csvwrite([dataDir filesep 'toyModelRunStep1.csv'],toyModelObj.get_value('state'));

%step 2: run.
toyModelObj.update;
%save state to file
csvwrite([dataDir filesep 'toyModelRunStep2.csv'],toyModelObj.get_value('state'));

%step 3: change the state
toyModelObj.set_value('state',toyModelObj.get_value('state')+ 0.5 * ones(dimensions)); 
%save state to file
csvwrite([dataDir filesep 'toyModelRunStep3.csv'],toyModelObj.get_value('state'));

%step 4: change the state at indices using String input for indices
toyModelObj.set_value_at_indices('state','(4:5,4:6)',pi);
%save state to file
csvwrite([dataDir filesep 'toyModelRunStep4.csv'],toyModelObj.get_value('state'));

%step 5: change the state at indices using String input for indices, and
%get input var list
varList = toyModelObj.get_input_var_names;
toyModelObj.set_value_at_indices(varList{1},8:12,0);
%save state to file
csvwrite([dataDir filesep 'toyModelRunStep5.csv'],toyModelObj.get_value('state'));

%step 6: run for a certain time.
toyModelObj.update_until(5);
%save state to file
csvwrite([dataDir filesep 'toyModelRunStep6.csv'],toyModelObj.get_value('state'));

%step 7: getting vars
varList = toyModelObj.get_output_var_names;
csvwrite([dataDir filesep 'toyModelRunStep7.csv'],toyModelObj.get_value(varList{1}));





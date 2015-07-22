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


%% model specific stuff

%the model in matlab state model format (ie. state_out = model(parameters, state_in, n_timesteps) )

shape = [3,1];
spacing = [1,1];
origin = [0,0];
dt = 1;
startTime = 0;
endTime = 500;

localization='(1:2)';

%% create model


AR1ModelObj=AR1BMI(dt,shape,spacing,origin,startTime,endTime);

%% run model, save all steps as csv files

%step 1: initialize
AR1ModelObj.initialize;
%save state to file
csvwrite([dataDir filesep 'AR1ModelRunStep1.csv'],AR1ModelObj.get_value('state'));

%step 2: run.
AR1ModelObj.update;
%save state to file
csvwrite([dataDir filesep 'AR1ModelRunStep2.csv'],AR1ModelObj.get_value('state'));

%step 3: simulate an EnKF update step.
%get state from model
selectedState=AR1ModelObj.get_value_at_indices('state',localization);
%change state based on other info. here, just randomize
selectedState=randn(size(selectedState));
%re-set state
AR1ModelObj.set_value_at_indices('state',localization,selectedState);
%save state to file
csvwrite([dataDir filesep 'AR1ModelRunStep3.csv'],AR1ModelObj.get_value('state'));

%step 4: run till end.
AR1ModelObj.update_until(endTime);
csvwrite([dataDir filesep 'AR1ModelRunStep4.csv'],AR1ModelObj.get_value('state'));





%% clean

clear all
close all
clc

%% model specifics

%Directories:
runDir = '.'; %starting point
dataDir = [runDir filesep 'data']; %location of data
modelDir = [runDir filesep 'models']; %location of the models (not the BMI classes of those models
classDir = [runDir filesep 'BMIClasses']; %location of BMI classes implementing the above models
libdir = [runDir filesep '..' filesep 'lib']; %location of the BMI library (classes that he above BMI classes inheret from)

addpath(modelDir);
addpath(classDir);
addpath(libDir);

%constants specific for this model
sigma=10;
rho=28;
beta=8/3;

%constants specific for this run of this model
startTime=0;
endTime=500;
dt=1e-3;


%% create model

%make an instance of the LorenzBMI class, which inherets from the BMI
%class.
LorenzObj=LorenzBMI(startTime,endTime,dt,sigma,rho,beta);


%% run as ensemble

LorenzObj.initialize;

LorenzObj.update_until(10);

LorenzObj.set_value('x',LorenzObj.get_value('x')+randn(1));
LorenzObj.set_value('y',LorenzObj.get_value('y')+randn(1));
LorenzObj.set_value('z',LorenzObj.get_value('z')+randn(1));

LorenzObj.update_until(endTime);

vars=LorenzObj.get_output_var_names;


classdef stateModelBMI < simpleBMI
    %obj=stateModelBMI(modelHandle,dimensions,startTime,endTime,dt,parameters,forcing)
    
    
    
    %properties that are both input and output (ie. can be set and gotten)
    properties (GetAccess = 'public', SetAccess = 'public')
        stateVector
    end
    
    %properties that are input and not output (ie. can only be set).
    %These are either set at creation or initialization, or they change
    %during runTime.
    properties (GetAccess = 'private', SetAccess = 'public')
        forcing
        forcingTimeIndex
    end
    
    %properties that are output and not input (ie. can only be gotten)
    properties (GetAccess = 'public', SetAccess = 'private')
        %none
    end
    
    %properties that are private (ie. cen not be set or gotten, unless at creation)
    properties (GetAccess = 'private', SetAccess = 'private')
        dt
        dimensions
        modelHandle
        timeSteps
        forcingFlag
        parameterFlag
        parameters
    end
    
    %constructor
    methods
        function obj=stateModelBMI(modelHandle,dimensions,startTime,endTime,dt,parameters,forcing)
            obj.name='BMI implemented for state-models';
            obj.var_units=containers.Map({'state'},{'-'});
            obj.input_var_names=containers.Map({'state','forcing'},{'stateVector','forcing'});
            obj.output_var_names=containers.Map({'state'},{'stateVector'});
            
            switch nargin
                case 4
                    %given
                    obj.modelHandle=modelHandle;
                    obj.dimensions=dimensions;
                    obj.startTime=startTime;
                    obj.endTime=endTime;
                    %default
                    obj.dt=1;
                    %derived
                    obj.forcingFlag=0;
                    obj.parameterFlag=0;
                case 5
                    %given
                    obj.modelHandle=modelHandle;
                    obj.dimensions=dimensions;
                    obj.startTime=startTime;
                    obj.endTime=endTime;
                    obj.dt=dt;
                    %derived
                    obj.forcingFlag=0;
                    obj.parameterFlag=0;
                case 6
                    %given
                    obj.modelHandle=modelHandle;
                    obj.dimensions=dimensions;
                    obj.startTime=startTime;
                    obj.endTime=endTime;
                    obj.dt=dt;
                    obj.parameters=parameters;
                    %derived
                    obj.forcingFlag=0;
                    obj.parameterFlag=1;
                case 7
                    %given
                    obj.modelHandle=modelHandle;
                    obj.dimensions=dimensions;
                    obj.startTime=startTime;
                    obj.endTime=endTime;
                    obj.dt=dt;
                    obj.parameters=parameters;
                    obj.forcing=forcing;
                    %derived
                    obj.forcingFlag=0;
                    obj.parameterFlag=1;
                otherwise
                    error('wrong number of inputs for constructor');
            end
            
        end
    end
    
    
    %the following is the heart of the BMI class. Every BMI model needs to
    %implement these methods. For some methods a standard implementation is
    %provided (example: update_until). These can be overwritten by
    %implementing them in the model class file. See the AR1class.m for an
    %example. Methods that are not implemented will throw an error msg
    %declaring they are not implemented.
    methods
        function initialize(obj)
            obj.time=0;
            obj.stateVector=zeros(obj.dimensions);
            obj.timeSteps=floor((obj.endTime-obj.startTime)/obj.dt);
            
            obj.forcingTimeIndex=1;
        end
        
        function update(obj)
            if (obj.time >= obj.endTime)
                error('endTime already reached, model not updated');
            else
                %run the actual model
                if (obj.forcingFlag)
                    if (obj.forcingTimeIndex > size(obj.forcing,2))
                        error('forcing not provided for this timestep');
                    else
                        obj.stateVector=obj.modelHandle(obj.parameters,obj.stateVector,1,obj.forcing(:,obj.forcingTimeIndex));
                        obj.forcingTimeIndex=obj.forcingTimeIndex+1;
                    end
                else
                    obj.stateVector=obj.modelHandle(obj.parameters,obj.stateVector,1);
                end
                %update time
                obj.time=obj.time+obj.dt;
            end
            
        end
        function update_until(obj,time)
            if time >= obj.endTime
                error('endTime already reached, model not updated');
            end
            while obj.time < time
                obj.update;
            end
        end
        
    end
    
end
classdef AR1BMI < simpleBMI
    
    %properties that are both input and output (ie. can be set and gotten)
    properties (GetAccess = 'public', SetAccess = 'public')
        stateVector
    end
    
    %properties that are input and not output (ie. can only be gotten).
    %These are either set at creation or initialization, or they change
    %during runTime.
    properties (GetAccess = 'public', SetAccess = 'private')
        %none
    end
    
    %properties that are output and not input (ie. can only be set)
    properties (GetAccess = 'private', SetAccess = 'public')
        %none
    end
    
    %properties that are private (ie. cen not be set or gotten)
    properties (GetAccess = 'private', SetAccess = 'private')
        dt
        shape
        spacing
        origin
        timeSteps
        forcing
        forcingTimeIndex
        ARcoefMatrix
    end
    
    %constructor
    methods
        function obj=AR1BMI(dt,shape,spacing,origin,startTime,endTime)
            obj.name='example MATLAB AR1 model, BMI';
            obj.var_units=containers.Map({'state'},{'-'});
            obj.input_var_names=containers.Map({'state'},{'stateVector'});
            obj.output_var_names=containers.Map({'state'},{'stateVector'});
            
            if nargin > 0
                obj.dt=dt;
                obj.shape=shape;
                obj.spacing=spacing;
                obj.origin=origin;
                obj.startTime=startTime;
                obj.endTime=endTime;
            else %defaults
                obj.dt=1;
                obj.shape=[3,1];
                obj.spacing=[1, 1];
                obj.origin=[0,0];
                obj.startTime=0;
                obj.endTime=20;
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
            obj.stateVector=zeros(obj.shape);
            obj.timeSteps=floor((obj.endTime-obj.startTime)/obj.dt);
            obj.forcing=randn([obj.shape,obj.timeSteps]);
            obj.forcingTimeIndex=1;
            obj.ARcoefMatrix=[[0.5, 0.2, 0.3];[0.2, 0.5, 0.3];[0.3, 0.3, 0.4]];
        end
        
        function update(obj)
            if (obj.time >= obj.endTime)
                error('endTime already reached, model not updated');
            else
                %run the actual model
                parameters.AR1coefs=obj.ARcoefMatrix;
                obj.stateVector=AR1FilterMatlabModel(parameters,obj.stateVector,1,obj.forcing(:,obj.forcingTimeIndex));
                
                %update time
                obj.forcingTimeIndex=obj.forcingTimeIndex+1;
                obj.time=obj.time+obj.dt;
            end
            
        end
        
        
    end
    
end
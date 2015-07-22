classdef LorenzBMI < BMI
    % a Lorenz model implemented as a BMI model
    
    
    properties
        x
        y
        z
        time
        startTime
        endTime
        dt
        rho
        sigma
        beta
    end
    
    
    %the following is the heart of the BMI class. Every BMI model needs to
    %implement these methods. For some methods a standard implementation is
    %provided (example: update_until). These can be overwritten by
    %implementing them in the model class file. See the AR1class.m for an
    %example. Methods that are not implemented will throw an error msg
    %declaring they are not implemented.
    %See the BMI reference for more details.
    methods
        function obj=LorenzBMI(startTime,endTime,dt,sigma,rho,beta)
            obj.startTime=startTime;
            obj.endTime=endTime;
            obj.dt=dt;
            if (nargin==3)
                obj.sigma=10;
                obj.rho=28;
                obj.beta=8/3;
            else
                obj.sigma=sigma;
                obj.rho=rho;
                obj.beta=beta;
            end
            
        end
        
        function initialize(obj)
                obj.x=randn(1);
                obj.y=randn(1);
                obj.z=randn(1);
                obj.time=obj.startTime;
        end
        
        function update(obj)
            obj.x = obj.x+obj.dt*(obj.sigma * (obj.y - obj.x));
            obj.y = obj.y+obj.dt*(obj.x * (obj.rho -obj.z) - obj.y);
            obj.z = obj.z+obj.dt*(obj.x * obj.y - obj.beta* obj.y);
            obj.time = obj.time + obj.dt;
        end
        
        function update_until(obj,time)
            while (time <= obj.time)
                obj.update;
            end
        end
        
        function output = get_var_units(obj,long_var_name)
            output='-';
        end
        
        function output = get_var_type(obj,long_var_name)
            output='-';
        end
        function output = get_var_rank(obj,long_var_name)
            output=1;
        end
        function output = get_value(obj,long_var_name)
            switch long_var_name
                case 'x'
                    output=obj.x;
                case 'y'
                    output=obj.y;
                case 'z'
                    output=obj.z;
                otherwise
                    error('unkown variable');
            end
        end
        
        function output = get_value_at_indices(obj,long_var_name, inds)
            error(['This method is not defined in class ' mfilename('class')]);
        end
        
        function set_value(obj,long_var_name, src)
            switch long_var_name
                case 'x'
                    obj.x=src;
                case 'y'
                    obj.y=src;
                case 'z'
                    obj.z=src;
                otherwise
                    error('unkown variable');
            end
        end
        
        function set_value_at_indices(obj,long_var_name, inds, src)
            error(['This method is not defined in class ' mfilename('class')]);
        end
        
        function output = get_component_name(obj)
            output='BMI implemented for Lorenz model';
        end
        function output = get_input_var_names(obj)
            output={'x','y','z'};
        end
        function output = get_output_var_names(obj)
            output={'x','y','z'};
        end
        function output = get_start_time(obj)
            output=obj.startTime;
        end
        function output = get_end_time(obj)
            output=obj.endTime;
        end
        function output = get_current_time(obj)
            output=obj.time;
        end
    end
end


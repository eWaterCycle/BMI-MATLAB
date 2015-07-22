classdef simpleBMI < BMI
    % a superclass for models that want to implement the Basic Model
    % Interface (BMI, see http://csdms.colorado.edu/wiki/BMI_Description).
    % to construct a model, use: classdef myModel < BMI.
    % in the constructor of your class, the properties defined below should
    % be given values. Note that the name, var_units, input_var_units and
    % output_var_units need all be map containers. See the AR1BMI.m file
    % for an example.
    
    
    %These properties are shared by all BMI models. they need to be set in
    %the constructor of the model class.
    properties
        time
        startTime
        endTime
        name % a string containing the model name
        var_units % a containers map linking variable names to units
        input_var_names % a containers map linking interface variable names to model variable names
        output_var_names % a containers map linking interface variable names to model variable names
    end
    
    
    %the following is the heart of the BMI class. Every BMI model needs to
    %implement these methods. For some methods a standard implementation is
    %provided (example: update_until). These can be overwritten by
    %implementing them in the model class file. See the AR1class.m for an
    %example. Methods that are not implemented will throw an error msg
    %declaring they are not implemented.
    %See the BMI reference for more details.
    methods
        
        function output = get_var_units(obj,long_var_name)
            try
                output=obj.var_units(long_var_name);
            catch
                error('unknown variable')
            end
        end
        
        function output = get_var_type(obj,long_var_name)
            try
                output=class(get(obj,obj.input_var_names(long_var_name)));
            catch
                try
                    output=class(get(obj,obj.output_var_names(long_var_name)));
                catch
                    error('unknown variable')
                end
            end
        end
        function output = get_var_rank(obj,long_var_name)
            try
                output=size(get(obj,obj.input_var_names(long_var_name)));
            catch
                try
                    output=size(get(obj,obj.output_var_names(long_var_name)));
                catch
                    error('unknown variable')
                end
            end
        end
        function output = get_value(obj,long_var_name)
            try
                output=get(obj,obj.output_var_names(long_var_name));
            catch
                error('unknown variable')
            end
        end
        function output = get_value_at_indices(obj,long_var_name, inds)
            if ischar(inds) %indices are provided as matlab string, including brackets!
                try
                    output=eval(['obj.' obj.output_var_names(long_var_name) inds]);
                catch
                    error('unknown variable or wrong indices. Indices need to be a string!')
                end
            else %indices are numbers
                try
                    output=get(obj,obj.output_var_names(long_var_name));
                    output=output(inds);
                catch
                    error('unknown variable or wrong indices. Indices need to be a string!')
                end
            end
        end
        
        function set_value(obj,long_var_name, src)
            
            try
                set(obj,obj.input_var_names(long_var_name),src);
            catch
                error('unknown variable')
            end
        end
        
        function set_value_at_indices(obj,long_var_name, inds, src)
            try
                toBeSet=get(obj,obj.input_var_names(long_var_name));
            catch
                error('unknown variable or wrong indices')
            end
            
            if ischar(inds) %indices are provided as matlab string, including brackets!
                eval(['toBeSet' inds '=src;']);
            else %indices are numbers
                toBeSet(inds)=src;
            end
            set(obj,obj.input_var_names(long_var_name),toBeSet);
        end
        
        function output = get_component_name(obj)
            output = obj.name;
        end
        function output = get_input_var_names(obj)
            output=keys(obj.input_var_names);
        end
        function output = get_output_var_names(obj)
            output=keys(obj.output_var_names);
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


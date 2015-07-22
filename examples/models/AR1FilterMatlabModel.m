function state_out=AR1Filter(parameters,state_in,n_timesteps,forcing)


forcingCoef=eye(length(forcing(:,1)));

state_out=state_in;

for timestep=1:n_timesteps
    state_out=[parameters.AR1coefs forcingCoef]*[state_out;forcing(:,timestep)];
end %for timestep=1:n_timesteps
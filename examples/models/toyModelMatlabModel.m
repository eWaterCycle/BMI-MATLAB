function state_out=toyModelMatlabModel(parameters,state_in,n_timesteps)


state_out=state_in + n_timesteps * ones(size(state_in));

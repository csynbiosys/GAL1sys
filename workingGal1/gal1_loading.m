load ./Data_Menolascina_yeast_160718.mat

inputs.exps.n_exp=1;                                  %Number of experiments                                                                            
for iexp=1:inputs.exps.n_exp
    inputs.exps.exp_y0{iexp}=ones(1,inputs.model.n_st);  %Initial conditions for each experiment
    inputs.exps.t_f{iexp}=S.Data(iexp).time_min(end);                            %Experiments duration
    
    % OBSEVABLES DEFINITION
    inputs.exps.n_obs{iexp}=1;                            % Number of observed quantities per experiment
    inputs.exps.obs_names{iexp}=char('GFP');      % Name of the observed quantities per experiment
    inputs.exps.obs{iexp}=char('GFP=Gal1');   % Observation function
    

    inputs.exps.u_interp{iexp}='linear';                  %Stimuli definition for experiment 1:
    %OPTIONS:u_interp: 'sustained' |'step'|'linear'(default)|'pulse-up'|'pulse-down'
%    inputs.exps.t_con{iexp}=[0 S.Data(iexp).time_input'];                         % Input swithching times: Initial and final time
     inputs.exps.u_min{iexp}=0;inputs.exps.u_max{iexp}=1;        %Minimum and maximum value for the input
    
    inputs.exps.t_con{iexp}=S.Data(iexp).time_input;                         % Input swithching times: Initial and final time
    inputs.exps.u{iexp}=S.Data(iexp).input;                               % Values of the inputs
    inputs.exps.exp_data{iexp}=S.Data(iexp).output;
    inputs.exps.error_data{iexp}=S.Data(iexp).output_std; 
    inputs.exps.t_s{iexp}=linspace(0,inputs.exps.t_f{iexp},length(S.Data(iexp).input))';
end
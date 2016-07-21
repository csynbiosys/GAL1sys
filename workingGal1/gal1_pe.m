%======================
% PATHS RELATED DATA
%======================

inputs.pathd.results_folder='gal1_test';         % Folder to keep results (in Results) for a given problem          
inputs.pathd.short_name='gal1';                      % To identify figures and reports for a given problem   

%======================
% MODEL RELATED DATA
%======================

inputs.model.input_model_type='blackboxmodel';                % Model introduction: 'charmodelC'|'c_model'|'charmodelM'|'matlabmodel'|'sbmlmodel'|                        
                                                           %                     'blackboxmodel'|'blackboxcost                             
inputs.model.blackboxmodel_file='gal1bbmodel'; % File including the simulation of the given model
inputs.model.n_st=1;
inputs.model.n_par=7;
inputs.model.n_stimulus=1;
inputs.model.names_type='custom';

inputs.model.st_names=char('Gal1');     % Names of the states
inputs.model.par_names=char('a','v','H','K','D','IC','delta');             % Names of the parameters
inputs.model.stimulus_names=char('galactose');
inputs.model.par=[0.00175985449291231,0.0800887345690361,2.22548971250921,3.35948035905386,0.0100614569676223,1.90860267661432,72.1324389675838];

%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================

gal1_loading

%  inputs.exps.n_exp=2;                                  %Number of experiments                                                                            
%  for iexp=1:inputs.exps.n_exp   
%      inputs.exps.exp_y0{iexp}=zeros(1,inputs.model.n_st);  %Initial conditions for each experiment          
%      inputs.exps.t_f{iexp}=1200;                            %Experiments duration
% 
%     % OBSEVABLES DEFINITION  
%      inputs.exps.n_obs{iexp}=1;                            % Number of observed quantities per experiment  
%      inputs.exps.obs_names{iexp}=char('GFP');      % Name of the observed quantities per experiment    
%      inputs.exps.obs{iexp}=char('GFP=Gal1');   % Observation function
%  end 
%  
%  inputs.exps.u_interp{1}='sustained';                  %Stimuli definition for experiment 1:
%                                                        %OPTIONS:u_interp: 'sustained' |'step'|'linear'(default)|'pulse-up'|'pulse-down' 
%  inputs.exps.t_con{1}=[0 1000];                         % Input swithching times: Initial and final time    
%  inputs.exps.u{1}=[1];                                 % Values of the inputs 
%  
%  inputs.exps.u_interp{2}='pulse-down';                 %Stimuli definition for experiment 2
%  inputs.exps.n_pulses{2}=25;                            %Number of pulses |-|_|-|_|-|_|-|_|-|_    
%  inputs.exps.u_min{2}=0;
%  inputs.exps.u_max{2}=1;        %Minimum and maximum value for the input
%  inputs.exps.t_con{2}=[0 linspace(50,1200,50)];                       %Times of switching: Initial time, Intermediate times, Final time
                  
 
inputs.PEsol.id_global_theta='all';                     %  'all'|User selected 
inputs.PEsol.global_theta_max=5.*inputs.model.par; %100.*[7.5038 0.6801 1.4992 10.0982 2.3422 7.2482 1.8981 1.2 3.8045 ...
                                 %2.5356 1.4420 4.8600 1.2 9.4440 0.5 0.4364 7.3021 4.5703 1.0];    % Maximum allowed values for the paramters
inputs.PEsol.global_theta_min=0.2.*inputs.model.par;%(1/100).*[7.5038 0.6801 1.4992 10.0982 2.3422 7.2482 1.8981 1.2 3.8045 ...
                                 %2.5356 1.4420 4.8600 1.2 9.4440 0.5 0.4364 7.3021 4.5703 1.0];   % Minimum allowed values for the parameters
inputs.PEsol.global_theta_guess=[1.7599e-03, 8.0089e-02, 2.2255e+00, 3.3595e+00, 1.0061e-02, 1.9086e+00, 7.2132e+01]; 

%inputs.model.par;      % [] Initial guess
                            
                             
% GLOBAL INITIAL CONDITIONS
%inputs.PEsol.id_global_theta_y0='none';               % [] 'all'|User selected| 'none' (default)
% inputs.PEsol.global_theta_y0_max=[];                % Maximum allowed values for the initial conditions
% inputs.PEsol.global_theta_y0_min=[];                % Minimum allowed values for the initial conditions
% inputs.PEsol.global_theta_y0_guess=[];              % [] Initial guess

% LOCAL UNKNOWNS (DIFFERENT VALUES FOR DIFFERENT EXPERIMENTS)

%inputs.PEsol.id_local_theta{1}='none';                % [] 'all'|User selected| 'none' (default)
% inputs.PEsol.local_theta_max{iexp}=[];              % Maximum allowed values for the paramters
% inputs.PEsol.local_theta_min{iexp}=[];              % Minimum allowed values for the parameters
% inputs.PEsol.local_theta_guess{iexp}=[];            % [] Initial guess
%inputs.PEsol.id_local_theta_y0{1}='none';             % [] 'all'|User selected| 'none' (default)
% inputs.PEsol.local_theta_y0_max{iexp}=[];           % Maximum allowed values for the initial conditions
% inputs.PEsol.local_theta_y0_min{iexp}=[];           % Minimum allowed values for the initial conditions
% inputs.PEsol.local_theta_y0_guess{iexp}=[];         % [] Initial guess

inputs.rank.gr_samples = 100;
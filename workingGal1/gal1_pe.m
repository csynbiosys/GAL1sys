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
inputs.model.par_names=char('alpha','vv','H','K','D','IC','delta');             % Names of the parameters defining parameter order
inputs.model.stimulus_names=char('galactose');
inputs.model.par=[0.00175985449291231,0.0800887345690361,2.22548971250921,3.35948035905386,0.0100614569676223,1.90860267661432,72.1324389675838];

%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================

gal1_loading

% <<<<<<< HEAD
% %  inputs.exps.n_exp=2;                                  %Number of experiments                                                                            
% %  for iexp=1:inputs.exps.n_exp   
% %      inputs.exps.exp_y0{iexp}=zeros(1,inputs.model.n_st);  %Initial conditions for each experiment          
% %      inputs.exps.t_f{iexp}=1200;                            %Experiments duration
% % 
% %     % OBSEVABLES DEFINITION  
% %      inputs.exps.n_obs{iexp}=1;                            % Number of observed quantities per experiment  
% %      inputs.exps.obs_names{iexp}=char('GFP');      % Name of the observed quantities per experiment    
% %      inputs.exps.obs{iexp}=char('GFP=Gal1');   % Observation function
% %  end 
% %  
% %  inputs.exps.u_interp{1}='sustained';                  %Stimuli definition for experiment 1:
% %                                                        %OPTIONS:u_interp: 'sustained' |'step'|'linear'(default)|'pulse-up'|'pulse-down' 
% %  inputs.exps.t_con{1}=[0 1000];                         % Input swithching times: Initial and final time    
% %  inputs.exps.u{1}=[1];                                 % Values of the inputs 
% %  
% %  inputs.exps.u_interp{2}='pulse-down';                 %Stimuli definition for experiment 2
% %  inputs.exps.n_pulses{2}=25;                            %Number of pulses |-|_|-|_|-|_|-|_|-|_    
% %  inputs.exps.u_min{2}=0;
% %  inputs.exps.u_max{2}=1;        %Minimum and maximum value for the input
% %  inputs.exps.t_con{2}=[0 linspace(50,1200,50)];                       %Times of switching: Initial time, Intermediate times, Final time
% =======

% 
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
%  inputs.exps.n_pulses{2}=3;                            %Number of pulses |-|_|-|_|-|_|-|_|-|_    
%  inputs.exps.u_min{2}=0;
%  inputs.exps.u_max{2}=1;        %Minimum and maximum value for the input
<<<<<<< HEAD
%  inputs.exps.t_con{2}=[0 linspace(50,1200,6)];                       %Times of switching: Initial time, Intermediate times, Final time
% % >>>>>>> parent of cf85d41... Solving the issue with vector dimensions
                  
=======
%  inputs.exps.t_con{2}=[0 linspace(50,1200,50)];                       %Times of switching: Initial time, Intermediate times, Final time
load ./Data_Menolascina_yeast_160718.mat

inputs.exps.n_exp=2;                                  %Number of experiments                                                                            
for iexp=1:inputs.exps.n_exp
    inputs.exps.exp_y0{iexp}=ones(1,inputs.model.n_st);  %Initial conditions for each experiment
    inputs.exps.t_f{iexp}=S.Data(iexp).time_min(end);                            %Experiments duration
    
    % OBSEVABLES DEFINITION
    inputs.exps.n_obs{iexp}=1;                            % Number of observed quantities per experiment
    inputs.exps.obs_names{iexp}=char('GFP');      % Name of the observed quantities per experiment
    inputs.exps.obs{iexp}=char('GFP=Gal1');   % Observation function
    
    inputs.exps.u_interp{iexp}='step';                  %Stimuli definition for experiment 1:
    %OPTIONS:u_interp: 'sustained' |'step'|'linear'(default)|'pulse-up'|'pulse-down'
    inputs.exps.t_con{iexp}=[0 S.Data(iexp).time_input'];                         % Input swithching times: Initial and final time
    inputs.exps.u{iexp}= S.Data(iexp).input';                                 % Values of the inputs
    inputs.exps.exp_data{iexp}=S.Data(iexp).output;
    inputs.exps.error_data{iexp}=S.Data(iexp).output_std;
    inputs.exps.t_s{iexp}=S.Data(iexp).time_min';
    inputs.exps.n_steps{iexp}=numel(inputs.exps.u{iexp});
end                  
>>>>>>> origin/master
 
inputs.PEsol.id_global_theta=char('alpha','vv','K','D','delta');                     %  'all'|User selected 
inputs.PEsol.global_theta_max=25*ones(1,5); %100.*[7.5038 0.6801 1.4992 10.0982 2.3422 7.2482 1.8981 1.2 3.8045 ...
                                 %2.5356 1.4420 4.8600 1.2 9.4440 0.5 0.4364 7.3021 4.5703 1.0];    % Maximum allowed values for the paramters
inputs.PEsol.global_theta_min=1e-6*ones(1,5);%(1/100).*[7.5038 0.6801 1.4992 10.0982 2.3422 7.2482 1.8981 1.2 3.8045 ...
                                 %2.5356 1.4420 4.8600 1.2 9.4440 0.5 0.4364 7.3021 4.5703 1.0];   % Minimum allowed values for the parameters
inputs.PEsol.global_theta_guess=[0.000001000001316
   0.700494596152119
   1.291131863683036
   0.004124545481924
  22.979072707253621]'; 

inputs.PEsol.global_theta_min=0.1*inputs.PEsol.global_theta_guess;
inputs.PEsol.global_theta_max=1.1*inputs.PEsol.global_theta_guess;
%inputs.model.par;      % [] Initial guess
<<<<<<< HEAD
                            
inputs.rank.gr_samples = 100;
=======

%==================================
% COST FUNCTION RELATED DATA
%==================================
         
inputs.PEsol.PEcost_type='llk';                       % 'lsq' (weighted least squares default) | 'llk' (log likelihood) | 'user_PEcost' 
inputs.PEsol.llk_type='homo_var';                     % [] To be defined for llk function, 'homo' | 'homo_var' | 'hetero' 

       
inputs.rank.gr_samples = 100;

%
% OPTIMIZATION
%
inputs.nlpsol.nlpsolver='eSS';                        % [] NLP solver: 
%                                                       % LOCAL: 'local_fmincon'|'local_n2fb'|'local_dn2fb'|'local_dhc'|
%                                                       %        'local_ipopt'|'local_solnp'|'local_nomad'||'local_nl2sol'
%                                                       %        'local_lsqnonlin'
%                                                       % MULTISTART:'multi_fmincon'|'multi_n2fb'|'multi_dn2fb'|'multi_dhc'|
%                                                       %            'multi_ipopt'|'multi_solnp'|'multi_nomad'|'multi_nl2sol'
%                                                       %            'multi_lsqnonlin'
%                                                       % GLOBAL: 'de'|'sres'
%                                                       % HYBRID: 'hyb_de_fmincon'|'hyb_de_n2fb'|'hyb_de_dn2fb'|'hyb_de_dhc'|'hyp_de_ipopt'|
%                                                       %         'hyb_de_solnp'|'hyb_de_nomad'|
%                                                       %         'hyb_sres_fmincon'|'hyb_sres_n2fb'|'hyb_sres_dn2fb'|'hyb_sres_dhc'|
%                                                       %         'hyp_sres_ipopt'|'hyb_sres_solnp'|'hyb_sres_nomad'
%                                                       % METAHEURISTICS:
%                                                       % 'ess' or 'eSS' (default)
%                                                       % Note that the corresponding defaults are in files: 
%                                                       % OPT_solvers\DE\de_options.m; OPT_solvers\SRES\sres_options.m; 
%                                                       % OPT_solvers\eSS_**\ess_options.m
%                                                       
                                                       
inputs.nlpsol.eSS.log_var = 1:5;    %The number of the parameters
inputs.nlpsol.eSS.maxeval = 100000;
inputs.nlpsol.eSS.maxtime = 120;

inputs.nlpsol.eSS.local.solver = 'lsqnonlin';
inputs.nlpsol.eSS.local.finish = 'fminsearch';

% inputs.nlpsol.multi_starts=500;                       % [] Number of different initial guesses to run local methods in the multistart approach
% inputs.nlpsol.multistart.maxeval = 100000;            % Maximum number of function evaluations for the multistart
% inputs.nlpsol.multistart.maxtime = 300;               % Maximum allowed time for the optimization
% 
% inputs.nlpsol.DE.NP = 9*10;                           % Initial population size (around 10*npar)
% inputs.nlpsol.DE.itermax = 2000;                      % Maximum number of iteratios in DE
% inputs.nlpsol.DE.F = 1; %0.75;  %1                    % F: DE-stepsize F ex [0, 2]
% inputs.nlpsol.DE.CR =0.85;                            %CR: crossover probabililty constant ex [0, 1]
% inputs.nlpsol.DE.strategy =2;                         % strategy       1 --> DE/best/1/exp                                            
%                                                       %                2 --> DE/rand/1/exp           
%                                                       %                3 --> DE/rand-to-best/1/exp   
%                                                       %                4 --> DE/best/2/exp          
%                                                       %                5 --> DE/rand/2/exp           
 
>>>>>>> origin/master

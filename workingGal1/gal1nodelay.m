% FM 11/08/2016: Gal1 regulation model implementing protein folding and
% maturation

%======================
% PATHS RELATED DATA
%======================

inputs.pathd.results_folder='gal1-noDelay';         % Folder to keep results (in Results) for a given problem          
inputs.pathd.short_name='gal1noD';                      % To identify figures and reports for a given problem   

%======================
% MODEL RELATED DATA
%======================

inputs.model.input_model_type='charmodelC';                % Model introduction: 'charmodelC'|'c_model'|'charmodelM'|'matlabmodel'|'sbmlmodel'|                        
                                                           %                     'blackboxmodel'|'blackboxcost                             
inputs.model.n_st=3;                                       % Number of states      
inputs.model.n_par=9;                                      % Number of model parameters 
inputs.model.n_stimulus=1;                                 % Number of inputs, stimuli or control variables   
inputs.model.st_names=char('gal1_mrna','gal1_foldedP','gal1_fluo');     % Names of the states                                              
inputs.model.par_names=char('alpha1','Vm1','h1','Km1','d1',...
                            'alpha2','d2','Kf','Kb');           % Names of the parameters                     
inputs.model.stimulus_names=char('gal');                                        % Names of the stimuli, inputs or controls                      
inputs.model.eqns=...                                      % Equations describing system dynamics. Time derivatives are regarded 'd'st_name''
               char('dgal1_mrna=alpha1+Vm1*(gal^h1/(Km1^h1+gal^h1))-d1*gal1_mrna',...
                    'dgal1_foldedP=alpha2*gal1_mrna-(d2+Kf)*gal1_foldedP',...
                    'dgal1_fluo=Kf*gal1_foldedP-Kb*gal1_fluo');           
                
inputs.model.par=[0.00175985449291231,0.0800887345690361,2.22548971250921,3.35948035905386,0.0100614569676223,1,1,1,1] 


%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================


% 
inputs.exps.n_exp=1;                                  %Number of experiments  
inputs.exps.exp_y0{1}=zeros(1,inputs.model.n_st)+eps;
inputs.exps.t_f{1}=1000; 
inputs.exps.n_obs{1}=3;  
inputs.exps.obs_names{1}=char('gal1_mrna','gal1_foldedP', 'gal1_fluo');
inputs.exps.obs{1}=char('mRNA=gal1_mrna','FoldedProtein=gal1_foldedP', 'Fluorescence=gal1_fluo');

inputs.exps.u_interp{1}='pulse-down'; 
inputs.exps.n_pulses{1}=5;                            %Number of pulses |-|_|-|_|-|_|-|_|-|_    
inputs.exps.u_min{1}=0;         %
inputs.exps.u_max{1}=2;         %Maximum value for the input
inputs.exps.t_con{1}=linspace(0,1000,inputs.exps.n_pulses{1}*2+1);  

inputs.exps.n_s{1}=100;  
inputs.exps.data_type='pseudo';
inputs.exps.noise_type='homo';

%  for iexp=1:inputs.exps.n_exp   
%      inputs.exps.exp_y0{iexp}=zeros(1,inputs.model.n_st)+eps;  %Initial conditions for each experiment          
%      inputs.exps.t_f{iexp}=120;                            %Experiments duration
% 
%     % OBSEVABLES DEFINITION  
%      inputs.exps.n_obs{iexp}=3;                            % Number of observed quantities per experiment  
%      inputs.exps.obs_names{iexp}=char('gal1_mrna','gal1_foldedP', 'gal1_fluo');      % Name of the observed quantities per experiment    
%      %inputs.exps.obs{iexp}=char('Lum=CL_m','mRNAa=CT_m');   % Observation function
%  end 
%  
%  
%  
%  inputs.exps.u_interp{1}='sustained';                  %Stimuli definition for experiment 1:
%                                                        %OPTIONS:u_interp: 'sustained' |'step'|'linear'(default)|'pulse-up'|'pulse-down' 
%  inputs.exps.t_con{1}=[0 120];                         % Input swithching times: Initial and final time    
%  inputs.exps.u{1}=[1];                                 % Values of the inputs 
 
%  inputs.exps.u_interp{2}='pulse-up';                 %Stimuli definition for experiment 2
%  inputs.exps.n_pulses{2}=5;                            %Number of pulses |-|_|-|_|-|_|-|_|-|_    
%  inputs.exps.u_min{2}=0;inputs.exps.u_max{2}=1;        %Minimum and maximum value for the input
%  inputs.exps.t_con{2}=[0 :12: 120];                    %Times of switching: Initial time, Intermediate times, Final time
                           
% %==================================
% % EXPERIMENTAL DATA RELATED INFO
% %==================================                                                            
%  inputs.exps.n_s{1}=15;                                % [] Number of sampling times for each experiment.
%  inputs.exps.n_s{2}=25;                                %    Optative input. By default "continuous" measurements are assumed.
% % inputs.exps.t_s{1}=[1 2 3 ...];                      % [] Sampling times for each experiment, by default equidistant
% % inputs.exps.t_s{2}=[0 5 7 ...];                      % [] Sampling times for each experiment, by default equidistant
% 
%  inputs.exps.data_type='real';                         % Type of experimental data: 'real'|'pseudo'|'pseudo_pos'(>=0)  
%  inputs.exps.noise_type='homo_var';                    % Type of experimental noise: Gaussian with zero mean and 
                                                       %                             Homoscedastic with constant variance: 'homo'
                                                       %                             Homoscedastic with varying variance:'homo_var'
                                                       %                             Heteroscedastic: 'hetero' 

% inputs.exps.exp_data{1}=[                              % Experimental data per experiment n_s{iexp}x n_obs{iexp}
% 		0.037642  0.059832
% 		1.398618  0.983442
% 		1.606762  0.433379
% 		0.265345  0.628819
% 		1.417288  0.858973
% 		1.381613  0.496637
% 		0.504584  0.717923
% 		1.240249  0.862584
% 		1.180193  0.634508
% 		0.775945  0.679648
% 		1.514514  0.735783
% 		0.904653  0.593644
% 		0.753736  0.759013
% 		1.389312  0.678665
% 		0.833228  0.574736
% 		];
% 
% inputs.exps.error_data{1}=[                            % Experimental noise, n_s{iexp}x n_obs{iexp}
% 		0.037642  0.059832
% 		0.072461  0.013999
% 		0.002877  0.020809
% 		0.050324  0.002705
% 		0.042936  0.017832
% 		0.044338  0.022538
% 		0.016335  0.017981
% 		0.164745  0.035301
% 		0.010631  0.102381
% 		0.127745  0.065791
% 		0.081671  0.049568
% 		0.126739  0.050306
% 		0.006308  0.018894
% 		0.054665  0.066953
% 		0.082163  0.015295
% 		];
% 
% 
% 
% inputs.exps.exp_data{2}=[
% 		0.146016  0.018152
% 		0.831813  1.002499
% 		1.874870  0.816779
% 		1.927580  0.544111
% 		1.139536  0.354476
% 		0.876938  0.520424
% 		0.559600  0.802322
% 		1.273548  0.939453
% 		1.696482  0.687495
% 		1.065496  0.577896
% 		0.847460  0.524076
% 		0.517520  0.738095
% 		1.162232  0.826737
% 		1.421504  0.779833
% 		1.340639  0.550493
% 		0.563822  0.515605
% 		0.402755  0.714877
% 		1.029856  0.871118
% 		1.490741  0.840174
% 		1.580873  0.692047
% 		0.696610  0.459481
% 		0.141546  0.646803
% 		0.804194  0.925806
% 		1.622378  0.824711
% 		1.525194  0.537398
% 		];
% 
% 
% inputs.exps.error_data{2}=[
% 		0.146016  0.018152
% 		0.066547  0.045194
% 		0.184009  0.101495
% 		0.047431  0.030858
% 		0.175280  0.033712
% 		0.031945  0.048733
% 		0.107148  0.008715
% 		0.019847  0.072804
% 		0.111892  0.001840
% 		0.104932  0.058752
% 		0.059721  0.033324
% 		0.056537  0.000360
% 		0.051815  0.037473
% 		0.103393  0.028094
% 		0.008084  0.012024
% 		0.188444  0.022982
% 		0.046354  0.031981
% 		0.043436  0.003749
% 		0.030177  0.042560
% 		0.116245  0.110535
% 		0.059345  0.025112
% 		0.218587  0.000564
% 		0.115783  0.043708
% 		0.099239  0.002678
% 		0.010644  0.052990
% 		];



%==================================
% UNKNOWNS RELATED DATA
%==================================

% GLOBAL UNKNOWNS (SAME VALUE FOR ALL EXPERIMENTS)


% inputs.PEsol.id_global_theta=char('n1','n2','m1','m4','m6','m7','k1','k4','p3');  %  'all'|User selected  
% inputs.PEsol.global_theta_max=10*ones(1,9);  % Maximum allowed values for the paramters
% inputs.PEsol.global_theta_min=0*ones(1,9); % Minimum allowed values for the paramters

%        
% % inputs.PEsol.global_theta_guess=[   5.082824695230836
% %    0.745885509439732
% %    7.750612254239743
% %    3.167859540291811
% %    2.476253863567990
% %    6.008054327045663
% %    4.696372709251819
% %    3.346472917415490
% %    3.185933721977777]';
% % inputs.PEsol.global_theta_max=2.*inputs.PEsol.global_theta_guess;  % Maximum allowed values for the paramters
% % inputs.PEsol.global_theta_min=0*ones(1,9); % Minimum allowed values for the paramters
% 
% 
% 
% 
% 
% 
% % GLOBAL INITIAL CONDITIONS
% %inputs.PEsol.id_global_theta_y0='none';               % [] 'all'|User selected| 'none' (default)
% % inputs.PEsol.global_theta_y0_max=[];                % Maximum allowed values for the initial conditions
% % inputs.PEsol.global_theta_y0_min=[];                % Minimum allowed values for the initial conditions
% % inputs.PEsol.global_theta_y0_guess=[];              % [] Initial guess
% 
% % LOCAL UNKNOWNS (DIFFERENT VALUES FOR DIFFERENT EXPERIMENTS)
% 
% %inputs.PEsol.id_local_theta{1}='none';                % [] 'all'|User selected| 'none' (default)
% % inputs.PEsol.local_theta_max{iexp}=[];              % Maximum allowed values for the paramters
% % inputs.PEsol.local_theta_min{iexp}=[];              % Minimum allowed values for the parameters
% % inputs.PEsol.local_theta_guess{iexp}=[];            % [] Initial guess
% %inputs.PEsol.id_local_theta_y0{1}='none';             % [] 'all'|User selected| 'none' (default)
% % inputs.PEsol.local_theta_y0_max{iexp}=[];           % Maximum allowed values for the initial conditions
% % inputs.PEsol.local_theta_y0_min{iexp}=[];           % Minimum allowed values for the initial conditions
% % inputs.PEsol.local_theta_y0_guess{iexp}=[];         % [] Initial guess
% 
% 
% %==================================
% % COST FUNCTION RELATED DATA
% %==================================
%          
% inputs.PEsol.PEcost_type='llk';                       % 'lsq' (weighted least squares default) | 'llk' (log likelihood) | 'user_PEcost' 
% inputs.PEsol.llk_type='homo_var';                     % [] To be defined for llk function, 'homo' | 'homo_var' | 'hetero' 
% 
% 
% 
% %==================================
% % NUMERICAL METHODS
% %==================================
% 
% %
% % SIMULATION
% %
%  inputs.ivpsol.ivpsolver='cvodes';                     % [] IVP solver: 'radau5'(default, fortran)|'rkf45'|'lsodes'|
% 
% 
%  inputs.ivpsol.senssolver='cvodes';                    % [] Sensitivities solver: 'cvodes' (C)
% 
% 
%  inputs.ivpsol.rtol=1.0D-7;                            % [] IVP solver integration tolerances
%  inputs.ivpsol.atol=1.0D-7; 
%  
% %
% % OPTIMIZATION
% %
% inputs.nlpsol.nlpsolver='eSS';                        % [] NLP solver: 
% %                                                       % LOCAL: 'local_fmincon'|'local_n2fb'|'local_dn2fb'|'local_dhc'|
% %                                                       %        'local_ipopt'|'local_solnp'|'local_nomad'||'local_nl2sol'
% %                                                       %        'local_lsqnonlin'
% %                                                       % MULTISTART:'multi_fmincon'|'multi_n2fb'|'multi_dn2fb'|'multi_dhc'|
% %                                                       %            'multi_ipopt'|'multi_solnp'|'multi_nomad'|'multi_nl2sol'
% %                                                       %            'multi_lsqnonlin'
% %                                                       % GLOBAL: 'de'|'sres'
% %                                                       % HYBRID: 'hyb_de_fmincon'|'hyb_de_n2fb'|'hyb_de_dn2fb'|'hyb_de_dhc'|'hyp_de_ipopt'|
% %                                                       %         'hyb_de_solnp'|'hyb_de_nomad'|
% %                                                       %         'hyb_sres_fmincon'|'hyb_sres_n2fb'|'hyb_sres_dn2fb'|'hyb_sres_dhc'|
% %                                                       %         'hyp_sres_ipopt'|'hyb_sres_solnp'|'hyb_sres_nomad'
% %                                                       % METAHEURISTICS:
% %                                                       % 'ess' or 'eSS' (default)
% %                                                       % Note that the corresponding defaults are in files: 
% %                                                       % OPT_solvers\DE\de_options.m; OPT_solvers\SRES\sres_options.m; 
% %                                                       % OPT_solvers\eSS_**\ess_options.m
% %                                                       
%                                                        
% %inputs.nlpsol.eSS.log_var = 1:9;
% inputs.nlpsol.eSS.maxeval = 100000;
% inputs.nlpsol.eSS.maxtime = 120;
% 
% inputs.nlpsol.eSS.local.solver = 'nl2sol';
% inputs.nlpsol.eSS.local.finish = 'nl2sol';
% 
% % inputs.nlpsol.multi_starts=500;                       % [] Number of different initial guesses to run local methods in the multistart approach
% % inputs.nlpsol.multistart.maxeval = 100000;            % Maximum number of function evaluations for the multistart
% % inputs.nlpsol.multistart.maxtime = 300;               % Maximum allowed time for the optimization
% % 
% % inputs.nlpsol.DE.NP = 9*10;                           % Initial population size (around 10*npar)
% % inputs.nlpsol.DE.itermax = 2000;                      % Maximum number of iteratios in DE
% % inputs.nlpsol.DE.F = 1; %0.75;  %1                    % F: DE-stepsize F ex [0, 2]
% % inputs.nlpsol.DE.CR =0.85;                            %CR: crossover probabililty constant ex [0, 1]
% % inputs.nlpsol.DE.strategy =2;                         % strategy       1 --> DE/best/1/exp                                            
% %                                                       %                2 --> DE/rand/1/exp           
% %                                                       %                3 --> DE/rand-to-best/1/exp   
% %                                                       %                4 --> DE/best/2/exp          
% %                                                       %                5 --> DE/rand/2/exp           
%  
% 
% % 
% % %==================================
% % % RIdent or GRank DATA
% % %==================================
% % %
% % 
% % inputs.rid.conf_ntrials=500;                          % [] Number of trials for the robust confidence computation (default: 500)
% % inputs.rank.gr_samples=10000;                         % [] Number of samples for global sensitivities and global rank within LHS (default: 10000)    
% % 
% % 
% % %==================================
% % % DISPLAY OF RESULTS
% % %==================================
% % 
% % 
% inputs.plotd.plotlevel='full';                        % [] Display of figures: 'full'|'medium'(default)|'min' |'noplot' 
% %inputs.plotd.figsave=1;
% % inputs.plotd.epssave=0;                              % [] Figures may be saved in .eps (1) or only in .fig format (0) (default)
% % inputs.plotd.number_max_states=8;                    % [] Maximum number of states per figure
% % inputs.plotd.number_max_obs=8;                       % [] Maximum number of observables per figure
% % inputs.plotd.n_t_plot=100;                           % [] Number of times to be used for observables and states plots
% % inputs.plotd.number_max_hist=8;                      % [] Maximum number of unknowns histograms per figure (multistart)
% %inputs.plotd.nx_contour=100;                          % Number of points for plotting the contours x and y direction
% %inputs.plotd.ny_contour=100;                          % ADVISE: >50

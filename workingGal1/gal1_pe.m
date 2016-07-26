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
inputs.model.blackboxmodel_file='gal1bbmodelF'; % File including the simulation of the given model
inputs.model.n_st=1;
inputs.model.n_par=8;
inputs.model.n_stimulus=1;
inputs.model.names_type='custom';

inputs.model.st_names=char('Gal1');     % Names of the states
inputs.model.par_names=char('alpha','vv','H','K','D','IC','delta','delta2');             % Names of the parameters defining parameter order
inputs.model.stimulus_names=char('galactose');
inputs.model.par=[0.00175985449291231,0.0800887345690361,2.22548971250921,3.35948035905386,0.0100614569676223,1.90860267661432,72.1324389675838,10];

%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================

load Data_Menolascina_yeast_160718.mat

inputs.exps.n_exp=5;                                  %Number of experiments                                                                            
for iexp=1:inputs.exps.n_exp
    index=iexp;
    %index=4;
    inputs.exps.exp_y0{iexp}=ones(1,inputs.model.n_st);  %Initial conditions for each experiment
    inputs.exps.t_f{iexp}=S.Data(index).time_min(end);                            %Experiments duration
    
    % OBSEVABLES DEFINITION
    inputs.exps.n_obs{iexp}=1;                            % Number of observed quantities per experiment
    inputs.exps.obs_names{iexp}=char('GFP');      % Name of the observed quantities per experiment
    inputs.exps.obs{iexp}=char('GFP=Gal1');   % Observation function
    
    inputs.exps.u_interp{iexp}='step';                  %Stimuli definition for experiment 1:
    %OPTIONS:u_interp: 'sustained' |'step'|'linear'(default)|'pulse-up'|'pulse-down'
    t_con{iexp}=[0 S.Data(index).time_input'];                         % Input swithching times: Initial and final time
    u{iexp}= S.Data(index).input';                                 % Values of the inputs
    inputs.exps.exp_data{iexp}=S.Data(index).output;
    inputs.exps.error_data{iexp}=S.Data(index).output_std;
    inputs.exps.t_s{iexp}=S.Data(index).time_min';
    
    
    % TRANSFORM INPUT VECTORS FOR MINIMUM DIMENSIONS
    i_con=1;
    for i=1:numel(u{iexp})-1
        if u{iexp}(i+1)~=u{iexp}(i)
            i_con=[i_con i+1];
        end
    end    
    inputs.exps.u{iexp}=u{iexp}(i_con);
    inputs.exps.t_con{iexp}=[t_con{iexp}(i_con) t_con{iexp}(end)];
    inputs.exps.n_steps{iexp}=numel(inputs.exps.u{iexp});
    i_con=[];
%      figure
%      plot(t_con{iexp}(1:end-1),u{iexp},'r')
%      hold on
%      stairs(inputs.exps.t_con{iexp}(1:end-1),inputs.exps.u{iexp},'b')
     
end                  
 



 inputs.PEsol.id_global_theta=char('alpha','vv','K','D','delta','delta2');                    %  'all'|User selected 
 inputs.PEsol.global_theta_max=[1e-4 0.01 0.25 0.01 25 25];
 inputs.PEsol.global_theta_min=[1e-8*ones(1,4) 1 1 ];   % Minimum allowed values for the parameters
  inputs.PEsol.global_theta_guess=[ 
   0.000008965839965
   0.004159100680866
   0.010156301735711
   0.002088516184136
   6.450699067022990
  39.085748536045536
       ]'; 
    inputs.PEsol.global_theta_max=2*inputs.PEsol.global_theta_guess;
    inputs.PEsol.global_theta_min=0.5*inputs.PEsol.global_theta_guess; 
   
%  for iexp=1:5
%      inputs.PEsol.id_local_theta{iexp}=char('alpha','vv','K','D','delta');
%      inputs.PEsol.local_theta_max{iexp}=[1e-4 0.1 0.25 0.1 25];
%      inputs.PEsol.local_theta_min{iexp}=1e-8*ones(1,5);
%  end
% inputs.PEsol.global_theta_min=0.0*inputs.PEsol.global_theta_guess;
% inputs.PEsol.global_theta_max=1.1*inputs.PEsol.global_theta_guess;
% %inputs.model.par;      % [] Initial guess

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
                                                       
inputs.nlpsol.eSS.log_var = 1:4;    %The number of the parameters
inputs.nlpsol.eSS.maxeval = 100000;
inputs.nlpsol.eSS.maxtime = 600;

inputs.nlpsol.eSS.local.solver = 0;
inputs.nlpsol.eSS.local.finish = 'nomad';

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

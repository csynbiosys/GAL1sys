function [yteor,iflag]=gal1bbmodelF(t0,tf,ts,y_0,par,u,pend,tu,iexp)

    options = odeset('RelTol',1e-7,'AbsTol',1e-7);
%  
%figure
%stairs(tu(1:end-1),u,'b')

    dtu=0;
    tudelay(1)=0;
    for i=1:numel(u)-1
        dtu=(tu(i+1)-tu(i));
        if u(i+1)<u(i) % --|__
           tudelay(i+1)=tu(i)+dtu+par(7); end;
        if u(i+1)>u(i) % __|--
           tudelay(i+1)=tu(i)+dtu+par(8); end
    end
    
    if u(end)==max(u)
    tudelay=[ tudelay tu(end)+par(7)];
    else
    tudelay=[ tudelay tu(end)+par(8)];
    end
    
   % tudelay=[0 tu]; % Takes into account the delay in u
    
    u1=u(1)/max(u);%ones(1,length(1:int8(par(7))));  
    udelay=[ u(1:end)/max(u)]; 

    vtout=union(ts,tudelay);
%      hold on
%      stairs(tudelay(1:end-1),udelay(1:end),'r')

      % Filter using delay
%     j=0;
%     for i=2:numel(u)
%        % if j<=1
%         if(tudelay(i)-tudelay(i-1))< 5 % par(7) % delta
%             udelay(i)=udelay(i-1);
%             j=j+1;
%         end
%         %end
%     j=0;
%     end
%     hold on
%   stairs(tudelay(1:end-1),udelay,'r')
%   pause
 % vtout=union(ts,tu);
    if vtout(1)==t0
        yteor(1,:)=y_0;
        i_int=2;
    else
        i_int=1;
    end
    i_con=1;
    % INTEGRATION LOOP 
    t_old=tudelay(1);



%     u=[u1, u(1:(end-length(u1)))];
%     tu=[0 tu+double(int8(par(7)))]
%     t_old=tu(1);
%     u=[1 u];

    for i_out=1:size(vtout,2)-1 
        tin=vtout(i_out);
        tout=vtout(i_out+1);  
        
%         fprintf('Initial time: %5.2f --- Final time: %5.2f\n',tin, tout);
%         u(:,i_con)
        [t,yout] = ode45(@odes_gal1bb,[tin tout],y_0,options,flag,par',udelay(:,i_con),pend,t_old, tudelay,i_con);
        % Keep values to next integration step
        y_0=yout(size(t,1),:);

        % If t out= t measurement, keep information 
        if tout==ts(i_int) 
            yteor(i_int,:)=yout(size(t,1),:);
            if i_int < numel(ts)
            i_int=i_int+1;
            end
        end 
        % If t out= t control, update control value
        %    [tout  inputs.exps.t_con{iexp}(i_con)]

        if (size(udelay,2)>1)               
            if (tout>=tudelay(i_con+1)) && ((i_con+1)<size(udelay,2)+1)
                i_con=i_con+1;
            end 
        end
        t_old=tu(i_con); 
    end % END INTEGRATION LOOP
    iflag=1;
return
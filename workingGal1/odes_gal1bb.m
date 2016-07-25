function ydot= odes_gal1bb(t,y,flag,par,v,pend,tlast,t_con, i_con) 

    % Parameters 'alpha','v','H','K','D','IC','delta'
    alpha = par(1);
    vv = par(2);
    K = par(4);
    D =  par(5);
    IC = par(6);
    delta = par(7);
    H = (log(vv-D+alpha)-log(D-alpha))/log(K); % par(3)

    u(1)=v(1)+(t-tlast)*pend(1);
%     u = v(1);
%      if t-delta<=t_con(1)
%        u(1)=v(1);
%      else
%   %     for iu=2:i_con
%         %   if t-delta<t_con(iu) & t-delta>t_con(iu-1)
%         iu=max(find(t-delta>=t_con));% & t-delta>t_con(iu-1))
%                u(1)=v(iu-1);
%                %disp(['Something is wrong in odes_gal1: iu ' num2str(iu) ' t_con(ui) ' num2str(t_con(iu)) ' t_con(iu-1) ' num2str(t_con(iu-1)) ' t-tau ' num2str(t-tau) ' size(t_con) ' num2str(size(t_con))]);
%          %  end
%        end
  %   end

    ydot(1,1) = alpha + vv*((u.^H)./((K^H)+(u.^H))) - D*y;

return

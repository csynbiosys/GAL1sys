function ydot= odes_gal1(t,y,flag,par,v,pend,tlast,t_con, i_con) 

    % Parameters
    alpha = par(1);
    V = par(2);
    K = par(4);
    D =  par(5);
    H = (log(V-D+alpha)-log(D-alpha))/log(K);
    tau = par(6);

  %  U(1)=v(1)+(t-tlast)*pend(1);
    u = v(1);
    if t-tau<=t_con(1)
      u(1)=v(1);
    else
      for iu=2:i_con
          if t-tau<t_con(iu) & t-tau>t_con(iu-1)
              u(1)=v(iu-1);
          else
              error('Something is wrong in odes_gal1');
              disp(['iu ' num2str(ui) ' t_con(ui) ' num2str(t_con(iu)) ' t_con(iu-1) ' num2str(t_con(iu-1)) ' t-tau ' num2str(t-tau)]);
          end
      end
    end

    ydot(1,1) = alpha + V*((u.^H)./((K^H)+(u.^H))) - D*y;

return

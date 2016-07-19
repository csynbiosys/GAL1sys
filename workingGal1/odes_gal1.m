function ydot= odes_gal1(t,y,flag,par,v,pend,tlast,t_con, i_con) 

  %  U(1)=v(1)+(t-tlast)*pend(1);
  
  if t-par(7)<=t_con(1)
      u(1)=v(1);
  else
      for iu=2:i_con
          if t-par(7)<t_con(iu) & t-par(7)>t_con(iu-1)
              u(1)=v(iu-1);
          end
      end
  end
  
    alpha = par(1);
    V = par(2);
    H =  par(3);
    K = par(4);
    D =  par(5);

    ydot(1,1) = alpha + V*((u.^H)./((K^H)+(u.^H))) - D*y;
return

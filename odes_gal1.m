function ydot= odes_circadian(t,y,flag,par,v,pend,tlast) 

    U(1)=v(1)+(t-tlast)*pend(1);

    alpha = par(1);
    V = par(2);
    H =  par(3);
    K = par(4);
    D =  par(5);

    ydot(1,1) = alpha + V*((U.^H)./((K^H)+(U.^H))) - D*y;

return

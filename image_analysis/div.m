% Divergence of (u1, u2) on domain [-Lx, Lx]*[-Ly, Ly]
function uu = div(u1, u2, dx, dy)    
    [u1x, ~]  = grad(u1,dx,dy);
    [~, u2y]  = grad(u2,dx,dy);

    uu = u1x + u2y;
end

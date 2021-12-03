% Derivative of u = u(x,y) on domain [-Lx, Lx]*[-Ly, Ly]
function [ux, uy] = grad(u, dx, dy)    
    
    ur = circshift(u,[0,-1]);
    ul = circshift(u,[0, 1]);
    ud = circshift(u,[-1,0]);
    uu = circshift(u,[ 1,0]);  
  
    u_x_CONV   = 0.5*(ur-ul)/dx;
    u_y_CONV   = 0.5*(ud-uu)/dy;
  
    u_x_CONV(:,1) = 0; u_x_CONV(:,end) = 0;
    u_y_CONV(1,:) = 0; u_y_CONV(end,:) = 0;
  
                                    
    ux = 2/3*u_x_CONV + 1/6*u_x_CONV([2:end 1],:)...
                         + 1/6*u_x_CONV([end 1:end-1],:);
                     
    uy = 2/3*u_y_CONV + 1/6*u_y_CONV(:,[2:end 1])...
                         + 1/6*u_y_CONV(:,[end 1:end-1]);
end
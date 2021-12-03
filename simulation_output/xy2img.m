function I = xy2img(xc,yc, R_CELL, L_BOX, N_PIXEL)

[X,Y] = meshgrid( linspace(-L_BOX/2,L_BOX/2,N_PIXEL),...
                  linspace(-L_BOX/2,L_BOX/2,N_PIXEL) );
              
I = zeros(size(X));

for i = 1:numel(xc)
    I = I + ( (X-xc(i)).^2 + (Y-yc(i)).^2 <= R_CELL^2);
end
I = (I > 0.5);



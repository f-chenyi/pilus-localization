function D = xyz2dist(x,y,z,L_BOX, H_BOX)

dx2 = dx_pbc(x, L_BOX);
dy2 = dx_pbc(y, L_BOX);
dz2 = dx_pbc(z, H_BOX);
D   = sqrt(dx2+dy2+dz2);

[N, re] = histcounts(D(D>0));
r = 0.5*(re(1:end-1) + re(2:end));
plot(r,N./r);

pas_var = 1;



function dx2 = dx_pbc(x, L)
dx2  = (x-x').^2;
dx2_ = (L - abs(x-x')).^2;
dx2(dx2>dx2_) = dx2_(dx2>dx2_);
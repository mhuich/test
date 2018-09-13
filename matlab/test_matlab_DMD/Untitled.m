x = linspace(-3,3,100);
f = 25;
L = 141;
gamma_0 = 40;

oa = f - x;
oa_p = f*oa./(f-oa);

plot(x, oa_p);
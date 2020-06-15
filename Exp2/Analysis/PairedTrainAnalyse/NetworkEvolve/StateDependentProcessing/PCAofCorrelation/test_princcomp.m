

t = 0:pi/12:2*pi;

a1 = sin(t);
a2 = sin(2*t);

x1 = 5*a1 + 3*a2;
x2 = 2*a1 + 7*a2;
x3 = 2.5*a1 + 9*a2;
x4 = 2*a1 + a2;


X = [x1' x2' x3' x4'];

[COEFF1,SCORE1,latent] = princomp(X);
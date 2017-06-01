bound = max(max(abs(dx)));
% x_min = min(x) - 2*accuracy_x;
% x_max = max(x) + 2*accuracy_x;
% 
% SizeParticles = ceil((x_max - x_min)./accuracy_x); NParticles = prod(SizeParticles);

SizeParticles = ceil([sqrt(NP) sqrt(NP)]); NParticles = prod(SizeParticles);
x_min = min(x) - 10*bound;
x_max = max(x) + 10*bound;
accuracy_x = ceil(x_max - x_min)./SizeParticles;

particles_x1 = x_min(1)+rand(NParticles,1)*(x_max(1)-x_min(1));
particles_x2 = x_min(2)+rand(NParticles,1)*(x_max(2)-x_min(2));
particles = cell(N,1);
particles{1} = [particles_x1,particles_x2];
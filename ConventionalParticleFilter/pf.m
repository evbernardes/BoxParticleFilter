
function [ xe, particles ] = pf(fstate,x,hmeas,z,Q,R)

[~,m] = size(x);
l = length(z);

emeasest = zeros(l,m);


for q = 1:m
    %emeasest(:,q) = z-hmeas(x(:,q));
    
    % small change: using the transpose inside hmeas function
    emeasest(:,q) = z-hmeas(x(:,q)'); 
end

w = exp(-.5*sum(emeasest.*(R\emeasest),1));
w = w/sum(w);

ind = rsmp(w);
particles=x(:,ind);

xe = mean(particles,2);

for q = 1:m
    particles(:,q) = mvnrnd(fstate(particles(:,q))', Q)';
end

    function ind=rsmp(w)
        
        N = length(w);
        
        if isrow(w)
            w = w';
        end
        
        u = rand(N,1);
        wc = cumsum(w);
        [~,ind] = sort([u;wc]);
        ind=find(ind<=N)-(0:N-1)';
    end
end

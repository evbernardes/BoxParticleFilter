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
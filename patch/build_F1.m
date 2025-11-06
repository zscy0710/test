function F1 = build_F1(parent,nln)
M = numel(nln); F1 = ones(M);
par = @(u) parent(u);
for a=1:M
    ua = nln(a);
    for b=1:M
        ub = nln(b);
        if par(ua)==ub || par(ub)==ua
            F1(a,b)=exp(1);
        elseif par(ua)==par(ub) && par(ua)~=0
            F1(a,b)=1/exp(1);
        end
    end
end
end
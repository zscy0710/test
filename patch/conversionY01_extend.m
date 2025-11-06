function Yh = conversionY01_extend(y,maxm)
cls = unique(y); cls(cls==0)=[];
Yh  = zeros(numel(y), maxm);
for i = 1:numel(cls)
    Yh(y==cls(i), i) = 1;
end
end
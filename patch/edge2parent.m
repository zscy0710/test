function [parent,nodes] = edge2parent(E)
E = double(E); child = E(:,1); par = E(:,2);
nodes = unique([child;par]); nodes(nodes==0)=[];
N = numel(nodes); parent=zeros(N,1);
[~,cidx]=ismember(child,nodes);
[~,pidx]=ismember(par  ,nodes);
for k=1:numel(child)
    if cidx(k)==0, continue; end
    parent(cidx(k)) = pidx(k);      % pidx 可 0
end
end
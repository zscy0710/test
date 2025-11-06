function sib = DAG_Sibling(parent,u)
p = parent(u);
if p==0, sib=[]; return; end
sib = find(parent==p); sib(sib==u)=[];
end
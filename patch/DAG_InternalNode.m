function nodes = DAG_InternalNode(parent,~)
childSet = find(parent~=0);
parentSet= unique(parent(parent~=0));
nodes    = setdiff(parentSet, 0);
nodes    = nodes(:);
end
function leaves = DAG_LeafNode(parent,~)
childSet  = find(parent~=0);
parentSet = unique(parent(parent~=0));
leaves    = setdiff(childSet,parentSet);
leaves    = leaves(:);
end
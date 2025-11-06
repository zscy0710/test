function [noLeafNode,F1]=SubDAGRelationMatrix_Fs(DAG,Y)
indexRoot = DAG_Root(DAG);% The root of the tree
leafNode = DAG_LeafNode(DAG,indexRoot);
indexRoot = DAG_Root(DAG);
internalNodes = DAG_InternalNode(DAG, indexRoot);
noLeafNode =[indexRoot; internalNodes];


F1=zeros(length(noLeafNode),length(noLeafNode));
for i=1:length(noLeafNode)
    for j=1:length(noLeafNode)     
        nonlinkNodes = [];
        nonlinkNodes =DAG_Sibling(DAG,noLeafNode(j));  % 兄弟结点
        nonlinkNodes = setdiff(nonlinkNodes,leafNode);         

      if ismember(1,find(DAG(noLeafNode(i),:)==1)== noLeafNode(j))
             F1(i,j)=exp(1);
      elseif ismember(1,find(DAG(noLeafNode(j),:)==1)== noLeafNode(i))
             F1(i,j)=exp(1);
      elseif ismember(noLeafNode(i),nonlinkNodes)  %|| noLeafNode(j)==siblingNodes
             F1(i,j)=1/exp(1);
      else
            F1(i,j)=1;
       end
    end
end


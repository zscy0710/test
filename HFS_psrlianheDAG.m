%% Function局部（父子和兄弟）流行结构保持+标签冗余
function [feature_slct,obj] = HFS_psrlianheDAG(X, Y, numSelected, DAG, alpha1, beta,lambda,noLeafNode,F1,flag)
%rand('seed',9);% When seed is timed, it ensures that the random number generated at random is the same
eps = 1e-8; % set your own tolerance
maxIte = 10;
indexRoot = DAG_Root(DAG);
% internalNodes = DAG_InternalNode(DAG, indexRoot);
% noLeafNode =[internalNodes;indexRoot];
% 
% noi_nl = [];
% for noi = 1:length(noLeafNode)
%     if isempty(Y{noLeafNode(noi)})
%         noi_nl = [noi_nl, noi];
%     else 
%         continue
%     end
% end 
% noLeafNode(noi_nl) = [];

for i = 1:length(noLeafNode)
    ClassLabel = unique(Y{noLeafNode(i)});
    m(noLeafNode(i)) = length(ClassLabel );
end
maxm=max(m);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k=1;
[~,d] = size(X{indexRoot}); % get the number of features

%% initialize
for j = 1:length(noLeafNode)
    R{noLeafNode(j)} = EuDist2(X{noLeafNode(j)}',X{noLeafNode(j)}',0);
end
for j = 1:length(noLeafNode)
    Y{noLeafNode(j)}=conversionY01_extend(Y{noLeafNode(j)},maxm);  %extend 2 to [1 0]
    W{noLeafNode(j)} = rand(d, maxm); % initialize W
    %%
    XX{noLeafNode(j)} = X{noLeafNode(j)}' * X{noLeafNode(j)};
    XY{noLeafNode(j)} = X{noLeafNode(j)}' * Y{noLeafNode(j)};
 end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M1=sum(F1,2);%W是F的列和
for i = 1:maxIte
    for j = 1:length(noLeafNode)
        %% initialization
        D{noLeafNode(j)} = diag(0.5./max(sqrt(sum(W{noLeafNode(j)}.*W{noLeafNode(j)},2)),eps));%Here eps is the smallest positive number, and its setting avoids the appearance of infinite values
        L1(j)=M1(j)- F1(j);
        %XAX =X{noLeafNode(j)}'*(L1(j)+L1(j)')* X{noLeafNode(j)};
        XAX =X{noLeafNode(j)}'*(L1(j))* X{noLeafNode(j)};
        %B=R{noLeafNode(j)}+R{noLeafNode(j)}';
        W{noLeafNode(j)}=inv(XX{noLeafNode(j)}+ lambda* D{noLeafNode(j)}+ alpha1*XAX + beta*R{noLeafNode(j)})*(XY{noLeafNode(j)});
    end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The value of object function
    if (flag ==1)
       for j = 1:length(noLeafNode)
        M1=sum(F1,2);
        L1(j)=M1(j)- F1(j);
        obj(i)=(norm(X{noLeafNode(j)}*W{noLeafNode(j)}-Y{noLeafNode(j)}))^2+alpha1*trace(W{noLeafNode(j)}'*X{noLeafNode(j)}'*L1(j)* X{noLeafNode(j)}*W{noLeafNode(j)})+beta*trace(W{noLeafNode(j)}'*R{noLeafNode(j)}*W{noLeafNode(j)}) +lambda*L21(W{noLeafNode(j)}) ;  
       end
    end
end

%obj
for i = 1: length(noLeafNode)
    W1=W{noLeafNode(i)};
    W{noLeafNode(i)} = W1(:,1:m(noLeafNode(i)));
    %tempVector{i} = sum(W{noLeafNode(i)}.^2, 2);
end

clear W1;
for j = 1: length(noLeafNode)
    tempVector = sum(W{noLeafNode(j)}.^2, 2);
    [atemp, value] = sort(tempVector, 'descend'); % sort tempVecror (W) in a descend order
    %clear tempVector;
    %feature{noLeafNode(j)} = value(1:numSelected);
    feature_slct{noLeafNode(j)} = value(1:numSelected);
end
if (flag == 1)
    figure;
    set(gcf,'color','w');
    plot(obj,'LineWidth',4,'Color',[0 0 1]);
    set(gca,'FontName','Times New Roman','FontSize',11);
    xlabel('Iteration number');
    ylabel('Objective function value');
end
end


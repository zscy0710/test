% Demonstration of hierarchical feature selection on synthetic data.
%
% The script constructs a simple three-node hierarchy with a root node (1)
% and two leaf nodes (2 and 3). Each leaf contains samples belonging to a
% single class, and the root stacks the samples so that the feature space
% size is shared across the hierarchy. The hierarchical feature selection
% routine is then invoked to select informative features for each leaf.

addpath('patch');

rng(42); % reproducibility

% Define the hierarchy as a parent vector: node 1 is the root, nodes 2 and
% 3 are its children.
DAG = [0 1 1];

num_features = 5;
samples_per_leaf = 50;

% Synthetic features for the two leaf classes. The class means are offset
% so that some features are more discriminative than others.
X{2} = randn(samples_per_leaf, num_features) + [1, 1, 0, 0, 0];
X{3} = randn(samples_per_leaf, num_features) + [0, 0, 1, 1, 0];

% Root node collects all samples to provide the feature dimensionality used
% inside HFS_psrlianheDAG.
X{1} = [X{2}; X{3}];

% Labels for the two leaf nodes. Each leaf only carries a single class
% label so that we can observe which features the method prefers per node.
Y{2} = ones(samples_per_leaf, 1);
Y{3} = 2 * ones(samples_per_leaf, 1);

% Define the subset of nodes that will be processed and their interaction
% weights. Here we only process the two leaves, encouraging them to share
% features equally via an all-ones F1 matrix.
noLeafNode = [2, 3];
F1 = ones(numel(noLeafNode));

numSelected = 3;
alpha1 = 0.1;  % inter-class structure weight
beta = 0.01;   % intra-class redundancy weight
lambda = 0.05; % sparsity weight
flag = 0;      % set to 1 to plot objective values

[feature_slct, obj] = HFS_psrlianheDAG(X, Y, numSelected, DAG, alpha1, beta, lambda, noLeafNode, F1, flag);

fprintf('Selected features for node 2: %s\n', mat2str(feature_slct{2}));
fprintf('Selected features for node 3: %s\n', mat2str(feature_slct{3}));

if flag == 1
    disp('Objective values per iteration:');
    disp(obj);
end

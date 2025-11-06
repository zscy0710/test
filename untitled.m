% run_full_hierarchy.m
% ------------------------------------------------------------
% 一键：特征选择 -> 全层级五折交叉验证 -> 生成 pred_cache.mat
% ------------------------------------------------------------
clear; clc;
addpath(genpath('../FS-MGKC'));  % 论文仓代码
addpath(genpath('.'));          % patch 辅助函数

%% 1) 读数据 + 建 parent 向量
S = load('DDTrain.mat');           % data_array, tree (32×2 [child parent])
[parent,~] = edge2parent(S.tree);
if nnz(parent==0) > 1                 % 多根 => 虚根
    vr = numel(parent)+1;
    parent(parent==0)=vr; parent(end+1)=0;
end

%% 2) 特征选择 (如已有则直接加载)
if ~exist('feature_slct.mat','file')
    [Dmod,Lmod] = creatSubTablezh(S.data_array,parent);
    nln = [tree_Root(parent); tree_InternalNodes(parent)];
    F1  = build_F1(parent,nln);

    [feat,~] = HFS_psrlianheDAG(Dmod,Lmod,50, ...   % numSelected = 50
                parent,0.01,0,0.1,nln,F1,0);       % alpha=0.01, beta=0, lambda=0.1
    save feature_slct.mat feat
else
    load feature_slct.mat
end
keep_root = feat{tree_Root(parent)};      % 根节点挑出的特征列

%% 3) 按树拆数据表，并统一裁到 keep_root 列
[Xc,Yc] = creatSubTablezh(S.data_array,parent);
for i = 1:numel(Xc)
    if ~isempty(Xc{i}), Xc{i} = Xc{i}(:, keep_root); end
end

%% 4) 五折 Top-Down SVM（仓库自带函数，层级递归）
%% --- 使用仓库自带全层级交叉验证 ---
%% 4) 五折 Top-Down SVM（仓库自带函数，层级递归）
foldN   = 5;
root    = tree_Root(parent);

Xall = S.data_array(:, 1:end-1);   % 全部特征（去掉最后一列标签）
y    = S.data_array(:, end);       % N×1 标签列（列向量）
data = [Xall(:, keep_root), y];    % 选中特征 + 标签，行数一致

feature   = cell(numel(parent),1);          % 每个内部节点同一套特征
feature(:)= {keep_root};
indices = crossvalind('Kfold', y, foldN);

% FS_Kflod_TopDownSVMClassifier 返回 5 个指标，
% 若只关心预测可改内部函数；这里直接复用并拿走它的输出矩阵
% 你已经有 keep_root（长度=50）并把 X 裁成了 50 列
numberSel = numel(keep_root);              % 50
feature   = repmat({1:numberSel}, numel(parent), 1);  % 每个节点只在 1..50 里选
[accMean, accStd, F_LCAMean, FHMean, TIEmean] = ...
    FS_Kflod_TopDownSVMClassifier(data, foldN, parent, feature, numberSel, indices);
%% 5) 保存预测缓存
tree = parent(:);                 % 列向量
save pred_cache.mat y_true y_pred tree
fprintf('\n✅  pred_cache.mat 已生成（%d × %d 标签矩阵）\n', size(y_true));
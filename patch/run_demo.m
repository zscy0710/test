% patch/run_demo.m
% 一句 F5，全流程：读 DD → 把多根树挂虚根 → 生成 F1 → 跑 HFS_psrlianheDAG
clear; clc;
addpath(genpath('../FS-MGKC'));   % 仓库
addpath(genpath('.'));           % 当前 patch 目录

S = load('DDTrain.mat');      % 3020×474 + tree 32×2
[parent,nodes] = edge2parent(S.tree);

% 多根 => 虚根
if nnz(parent==0) > 1
    vr = numel(parent)+1;
    parent(parent==0) = vr; parent(end+1) = 0;
end

% 切子任务
[DataMod,LabelMod] = creatSubTablezh(S.data_array, parent);

% noLeafNode & F1
nln = [tree_Root(parent); tree_InternalNodes(parent)];
F1  = build_F1(parent,nln);

% 跑
numSelected=50; alpha1=10; beta=0.3; lambda=0.1; flag=1;
[feat,obj] = HFS_psrlianheDAG(DataMod,LabelMod,...
    numSelected,parent,alpha1,beta,lambda,nln,F1,flag);

fprintf('\nROOT 前 10 个特征:\n');
disp(feat{tree_Root(parent)}(1:10).');
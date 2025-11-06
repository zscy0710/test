function evaluate_fs_mgkc
% 评估层级预测：HierAcc / LCA / TIE
% pred_cache.mat 必须包含 y_true y_pred tree (parent 向量)

clc;
addpath(genpath('FS-MGKC'));
addpath(genpath('patch'));

load('pred_cache.mat','y_true','y_pred','tree');
parent = tree(:);                                   % 列向量

assert(all(size(y_true)==size(y_pred)), 'y_true / y_pred 尺寸不一致');
fprintf('Samples = %d   Labels = %d\n', size(y_true,1), size(y_true,2));

metrics.HAcc  = EvaHier_HierarchicalAccuracy(y_true,y_pred,parent);

[P_h,R_h]     = EvaHier_HierarchicalPrecisionAndRecall(y_true,y_pred,parent);
metrics.HPre  = P_h; metrics.HRec = R_h; metrics.HF1 = fscore(P_h,R_h);

[P_l,R_l]     = EvaHier_HierarchicalLCAPrecisionAndRecall(y_true,y_pred,parent);
metrics.LCAPre= P_l; metrics.LCARec = R_l; metrics.LCAF1 = fscore(P_l,R_l);

metrics.TIE   = EvaHier_TreeInducedError(y_true,y_pred,parent);
metrics.TIE_N = EvaHier_TreeInducedErrorNormalize(y_true,y_pred,parent);

fprintf('\n=== FS-MGKC Evaluation ===\n'); disp(metrics);

fid = fopen(sprintf('eval_results_%s.txt',datestr(now,'yyyymmdd_HHMMSS')),'w');
fprintf(fid,'FS-MGKC Evaluation  (%s)\n\n',datestr(now));
fn = fieldnames(metrics);
for k=1:numel(fn), fprintf(fid,'%-10s : %.6f\n',fn{k},metrics.(fn{k})); end
fclose(fid); fprintf('结果已写入 eval_results_*.txt\n');
end

function f=fscore(p,r), f=(p+r==0).*0 + 2*p.*r ./ max(p+r,eps); end
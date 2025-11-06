function [pred, acc, dec] = svmpredict(~, Xte, model, ~)
% 兼容旧版 LIBSVM 接口：svmpredict(~, X, model, '-q')
% 输出:
%   pred : N×1 预测标签
%   acc  : []（占位，不计算）
%   dec  : N×K 决策分数/概率（如可得）

mdl = model.mdl;

try
    [pred, score] = predict(mdl, Xte);
catch
    % 极端情况下的兜底
    pred  = predict(mdl, Xte);
    score = [];
end

% 统一输出形状
pred = pred(:);
acc  = [];
dec  = score;
end
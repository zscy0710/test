function [Yhat, Ytrue] = topdown_svm_cv(Xcell, Ycell, parent, kfold)
% TOPDOWN_SVM_CV  ── 五折交叉验证顶层 SVM
% 仅对根节点做多类分类，输出列向量标签
% -------------------------------------------------------------
% Xcell{root} : N × d  特征
% Ycell{root} : N × 1  标签（整数）
% parent      : parent 向量（根=0）
% kfold       : 折数
% 返回：
%   Yhat  : N × 1  预测标签
%   Ytrue : N × 1  真值标签
% -------------------------------------------------------------

root  = tree_Root(parent);
N     = size(Xcell{root}, 1);

Ytrue = Ycell{root};         % 列向量
Yhat  = zeros(N, 1);

cvp = cvpartition(N, 'KFold', kfold);

for f = 1:kfold
    idxTr = training(cvp, f);
    idxTe = test(cvp, f);

    mdl = train_node(Xcell{root}(idxTr, :), Ycell{root}(idxTr));
    Yhat(idxTe) = predict_node(mdl, Xcell{root}(idxTe, :));
end
end

% ---------- helper: 训练 ----------
function mdl = train_node(X, y)
try
    mdl = libsvmtrain(double(y), X, '-s 0 -t 0 -q');      % libsvm
catch
    tmpl = templateSVM('KernelFunction', 'linear', ...
                       'Standardize',    true);
    mdl  = fitcecoc(X, y, 'Learners', tmpl, 'Coding', 'onevsall');
end
end

% ---------- helper: 预测（列向量标签） ----------
function yhat = predict_node(mdl, Xte)
try
    yhat = libsvmpredict(zeros(size(Xte, 1), 1), Xte, mdl, '-q');
catch
    yhat = predict(mdl, Xte);
end
yhat = yhat(:);        % 保证列向量
end
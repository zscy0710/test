function [pred, acc, dec] = svmpredict_compat(~, Xte, model, ~)
% 兼容 LIBSVM: [pred, acc, dec] = svmpredict(~, Xte, model, '-q')
mdl = model.mdl;
try
    [pred, score] = predict(mdl, Xte);
catch
    pred  = predict(mdl, Xte);
    score = [];
end
pred = pred(:);
acc  = [];
dec  = score;
end
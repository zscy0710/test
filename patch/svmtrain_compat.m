function model = svmtrain_compat(y, X, opts)
% 兼容 LIBSVM: svmtrain(y, X, '-c 1 -t 0 -q') -> fitcsvm/fitcecoc
if nargin < 3, opts = ''; end
C = 1; tok = regexp(opts,'-c\s+([0-9.]+)','tokens','once');
if ~isempty(tok), C = str2double(tok{1}); end

y = y(:);
classes = unique(y(~isnan(y)));
isMulti = numel(classes) > 2;

tmpl = templateSVM('KernelFunction','linear','Standardize',true,'BoxConstraint',C);

if isMulti
    mdl = fitcecoc(X, y, 'Learners', tmpl, 'Coding','onevsone');
else
    mdl = fitcsvm(X, y, 'KernelFunction','linear','Standardize',true,'BoxConstraint',C);
end

model.mdl     = mdl;
model.isECOC  = isMulti;
model.classes = classes;
end
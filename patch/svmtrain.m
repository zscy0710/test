function model = svmtrain(y, X, opts)
% 兼容旧版 LIBSVM 接口：svmtrain(y, X, '-c 1 -t 0 -q')
% 转发到 fitcsvm / fitcecoc（线性核，标准化）
%
% y : N×1 标签（整数或逻辑）
% X : N×d 特征
% opts: 仅解析 -c (BoxConstraint)，-t 只支持 0(线性)
%
% 返回:
%   model.mdl  : MATLAB 分类器对象
%   model.isECOC: 是否多类 ECOC
%   model.classes: 类别取值

if nargin < 3, opts = ''; end
C = 1;                                 % 默认 C
cTok = regexp(opts, '-c\s+([0-9.]+)', 'tokens', 'once');
if ~isempty(cTok), C = str2double(cTok{1}); end

% 线性核 + 标准化
tmpl = templateSVM('KernelFunction','linear', ...
                   'Standardize',true, ...
                   'BoxConstraint',C);

y = y(:);
classes = unique(y(~isnan(y)));
isMulti = numel(classes) > 2;

if isMulti
    mdl = fitcecoc(X, y, 'Learners', tmpl, 'Coding', 'onevsone');
else
    mdl = fitcsvm(X, y, 'KernelFunction','linear', ...
                       'Standardize',true, ...
                       'BoxConstraint',C);
end

model.mdl      = mdl;
model.isECOC   = isMulti;
model.classes  = classes;
end
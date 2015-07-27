function [Mw, Mb] = myLSDA(gnd, X1,eta, k)

% if (~exist('options','var'))  
%    options = [];
% end
if(nargin<3)
    eta=0.1;
    k=0;
end

if nargin<4
    k=0;
end

[nSmp,nFea] = size(X1);
if length(gnd) ~= nSmp
    error('gnd and data mismatch!');
end
% 
% if isfield(options,'eta') && (options.eta > 0) && (options.eta < 1)
%     eta = options.eta;
% end
Label = unique(gnd);
nLabel = length(Label);

Mw = zeros(nSmp,nSmp);
Mb = ones(nSmp,nSmp);
for idx=1:nLabel
    classIdx = find(gnd==Label(idx));
    Mw(classIdx,classIdx) = 1;
    Mb(classIdx,classIdx) = 0;
end
Mw=Mw-diag(ones(size(Mw,1),1));

if k > 0
    D = EuDist2(X1,[],0);
    [dump idx] = sort(D,2); % sort each row
    clear D dump
    idx = idx(:,[1:k+1]);
   % G = repmat([1:nSmp]',[k+1,1]),idx(:),ones(prod(size(idx)),1),nSmp,nSmp;
    G = sparse(repmat([1:nSmp]',[k+1,1]) , idx(:) , ones(prod(size(idx)),1) , nSmp , nSmp);
    G = max(G,G');
    Mw = Mw.*G;
    Mb = Mb.*G;
    clear G
end



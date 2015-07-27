   function CC=f_lapMatrixV2(X,gnd,eta,knn) 
        % lapMatrix.
        % 2X(D-M)X'   X=[x1,x2,...,xn];
        % K: the no. of task.
        if nargin<2
            t=1;           
        end      
        %K=length(X);
        K=length(gnd);
        CC = cell(K,1);
        L=cell(K,1);
%         ld=length(gnd{1});
%         tmpD=diag(ones(ld,1));
        for k=1:K           
           [Mw,Mb]=myLSDA(gnd{k}, X{k},eta,knn);
           Lw=diag(sum(Mw,1))-Mw;  
           Lb=diag(sum(Mb,1))-Mb;
           L{k}=eta*Lw-(1-eta)*Lb;  
           CC{k}=2*X{k}'*L{k}*X{k};
        end
    end
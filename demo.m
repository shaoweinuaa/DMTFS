
clear all
clc
task.num=2;%length(DATA.task);
task.DT=cell(task.num,1);
task.target=cell(task.num,1);
for i=1:task.num
    task.DT{i}=rand(200,90);%200,90: the number and dimension of subjects, respectively;
    task.target{i}=[ones(100,1);-1*ones(100,1)];%DATA.target{i};
end

kc=1;
kerpara.typeKer='linear';
kerpara.sigma=1;
eta_t=0.8;
knn_t=5;
rng('default');     % reset random generator.
opts.init = 0;      % guess start point from data. 
opts.tFlag = 1;     % terminate after relative objective value does not changes much.
opts.tol = 10^-5;   % tolerance.  
opts.maxIter = 1000; % maximum iteration number of optimization.
myzero=1e-6;

paraset=[500 50 1];
opts.rho1=paraset(1); % for L2,1
opts.rho_L3=paraset(2); % for manifold
heat_t=paraset(3); % for heat kernel, 
kfold=10;

              %% begin to 10-fold.
                res_kfold=zeros(kfold,task.num);
                for cc=1:1%kfold % here, we only demo one time cross-validation
%                     teLab=[1:200];
%                     trLab=[21:200];%1fcv{cc}';
                    tridx=[[1:(cc-1)*20] [cc*20+1:200]];
                    teidx=[(cc-1)*20+1:cc*20];
                    task.X = cell(task.num,1);
                    task.Y = cell(task.num,1);
                    for i=1:task.num % generate the task.                                                     
                        task.X{i}=task.DT{i}(tridx,:);               
                        task.Y{i}=task.target{i}(tridx);
                    end
                    opts.init = 1;
                    task.MC=f_lapMatrixV2(task.X,task.Y,eta_t,knn_t);    
                    [W, epsvalue] = jb_MTM_APG(task.X,task.Y,opts,task.MC);% m2tfs                 
                    temW=W;
                    temW(abs(temW)>myzero)=1;
                    temW(abs(temW)<=myzero)=0;
                    ind=find(sum(temW,2)~=0); % get the index of selected features.                     
                    %...  
                  
                    %mkl learning
                    opts.W0 = W;
                end






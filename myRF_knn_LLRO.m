function results = myRF_knn_LLRO(X_all2,Y2)
rng(1)

X_all2=knnimpute(X_all2');
X_all2=X_all2.';

idx_test=find(X_all2(:,2)>3);
idx_train=find(X_all2(:,2)<=3);

ntree=[50 100 150 200 250];

%total time start
total_time=tic;

train_ext=X_all2(idx_train,:);
test_ext=X_all2(idx_test,:);

labtest_ext=Y2(idx_test);
labtrain_ext=Y2(idx_train);

%start validation time
val_time=tic;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% crossvalind over subjects stratified
Tyg_mean=[];
count=0;
for i=1:length(test_ext)
    if i ~= 1 || i== length(test_ext)
        if test_ext(i,1)==test_ext(i-1,1)
        count=count+1;
        else
        Tyg_mean(i-1-count:i-1)=mean(labtest_ext(i-1-count:i-1));
        count=0;
        end
    else
    Tyg_mean(i)=labtest_ext(i);  
    end   
end

Tyg_mean=Tyg_mean';
Tyg_mean=[Tyg_mean;labtest_ext(length(test_ext))];
[C,ia,~] = unique(test_ext(:,1),'legacy');
Tyg_mean_id=Tyg_mean(ia);
idx_cluster = kmeans(Tyg_mean_id,4);
index_id=crossvalind('Kfold',idx_cluster,2);
id_mat=[C index_id];

new=[];
for i=1:length(test_ext(:,1))
    for j=1:length(id_mat)
    if test_ext(i,1)==id_mat(j,1)
        new(i,1)= test_ext(i,1);
        new(i,2)= id_mat(j,2);
    end
    end
end
IDX = new(:,2);

IDX_test_val=find(IDX==2);
IDX_test_ext=find(IDX==1);
    
train_int=train_ext;
test_int=test_ext(IDX_test_val,:);

labtest_int=labtest_ext(IDX_test_val);
labtrain_int=labtrain_ext;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
mu_int=nanmean(train_int,1);
sigma_int=nanstd(train_int,[],1);
C = bsxfun(@minus,train_int,mu_int);
train_int_norm = bsxfun(@rdivide,C,sigma_int);

C = bsxfun(@minus, test_int, mu_int);
test_int_norm = bsxfun(@rdivide, C, sigma_int);
        
for j=1:length(ntree)
    AA_opt{j}=TreeBagger(ntree(j),train_int_norm,labtrain_int,'NumPredictorsToSample','all','Method','regression');
    [yp_opt]=predict(AA_opt{j},test_int_norm);
    
    Pearson_rf_opt(j)=corr(yp_opt,labtest_int,'Type','Pearson');
    Spearman_rf_opt(j)=corr(yp_opt,labtest_int,'Type','Spearman');
    MSE_rf_opt(j)=immse(yp_opt,labtest_int);
    MAE_rf_opt(j)=sum(abs(yp_opt-labtest_int))/length(yp_opt);      
end
      
[v,l]=min(MSE_rf_opt);
[optntree]=ind2sub(size(MSE_rf_opt),l);
    
indice_opt_ntree=optntree;
validation_time=toc(val_time);
%end validation time
    
%train time start
tr_time=tic;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

test_ext=test_ext(IDX_test_ext,:);
labtest_ext=labtest_ext(IDX_test_ext);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mu_ext=nanmean(train_ext,1);
sigma_ext=nanstd(train_ext,[],1);
C = bsxfun(@minus,train_ext,mu_ext);
train_ext_norm = bsxfun(@rdivide,C,sigma_ext);

C = bsxfun(@minus, test_ext, mu_ext);
test_ext_norm = bsxfun(@rdivide, C, sigma_ext);

AA_ext=TreeBagger(ntree(optntree),train_ext_norm,labtrain_ext,'NumPredictorsToSample','all','Method','regression','OOBPredictorImportance','on');
train_time=toc(tr_time);
%train time end
    
%test time start
te_time=tic;
[yp_ext]=predict(AA_ext,test_ext_norm);
    
imp=abs(AA_ext.OOBPermutedPredictorDeltaError)';
    
[Pearson_rf_ext,p1]=corr(yp_ext,labtest_ext,'Type','Pearson');
[Spearman_rf_ext,p2]=corr(yp_ext,labtest_ext,'Type','Spearman');
MSE_rf_ext=immse(yp_ext,labtest_ext);
MAE_rf_ext=sum(abs(yp_ext-labtest_ext))/length(yp_ext);
   
test_time=toc(te_time);
%test time end
tot_time=toc(total_time);
%total time end

results.modelVal=AA_opt;
results.PearsonVal=Pearson_rf_opt;
results.SpearmanVal=Spearman_rf_opt;
results.MSEVal=MSE_rf_opt;
results.MAEVal=MAE_rf_opt;

results.modelTest=AA_ext;
results.PearsonTest=Pearson_rf_ext;
results.SpearmanTest=Spearman_rf_ext;
results.MSETest=MSE_rf_ext;
results.MAETest=MAE_rf_ext;

results.validation_time=validation_time;
results.train_time=train_time;
results.test_time=test_time;
results.total_time=tot_time;

results.pp=p1;
results.ps=p2;
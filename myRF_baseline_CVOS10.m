function results = myRF_baseline_CVOS10(X_all2,Y2)
rng(1)

in=5; % internal fold
out=10; % external fold

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%crossvalind over subjects
IDsingle=unique(X_all2(:,1));
idx_ID=crossvalind('Kfold',IDsingle,out);

ID_mat=[IDsingle idx_ID];
new=[];
for i=1:length(X_all2(:,1))
    for j=1:length(ID_mat)
    if X_all2(i,1)==ID_mat(j,1)
        new(i,1)= X_all2(i,1);
        new(i,2)= ID_mat(j,2);
    end
    end
end

idx_ext = new(:,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ntree=[50 100 150 200 250];

%total time start
total_time=tic;
for i=1:out
    disp(i)
    
    train_ext=X_all2(idx_ext~=i,:);

    mu_ext=nanmean(train_ext,1);
    sigma_ext=nanstd(train_ext,[],1);
    C = bsxfun(@minus,train_ext,mu_ext);
    train_ext_norm = bsxfun(@rdivide,C,sigma_ext);
    
    test_ext=X_all2(idx_ext==i,:);
    C = bsxfun(@minus, test_ext, mu_ext);
    test_ext_norm = bsxfun(@rdivide, C, sigma_ext);
    
    labtest_ext=Y2(idx_ext==i);
    labtrain_ext=Y2(idx_ext~=i);
    %start validation time
    val_time=tic;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IDsingle_int=unique(train_ext(:,1));
idx_ID_int=crossvalind('Kfold',IDsingle_int,in);

ID_mat_int=[IDsingle_int idx_ID_int];
new_int=[];
for ii=1:length(train_ext(:,1))
    for jj=1:length(ID_mat_int)
    if train_ext(ii,1)==ID_mat_int(jj,1)
        new_int(ii,1)= train_ext(ii,1);
        new_int(ii,2)= ID_mat_int(jj,2);
    end
    end
end

idx_int = new_int(:,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for h=1:in
        disp(h)
        train_int=train_ext_norm(idx_int~=h,:);

        mu_int=nanmean(train_int,1);
        sigma_int=nanstd(train_int,[],1);
        C = bsxfun(@minus,train_int,mu_int);
        train_int_norm = bsxfun(@rdivide,C,sigma_int);

        test_int=train_ext(idx_int==h,:);
        C = bsxfun(@minus, test_int, mu_int);
        test_int_norm = bsxfun(@rdivide, C, sigma_int);
        
        labtest_int=labtrain_ext(idx_int==h);
        labtrain_int=labtrain_ext(idx_int~=h);
        
        for j=1:length(ntree)
            AA_opt{h,j}=TreeBagger(ntree(j),train_int_norm,labtrain_int,'NumPredictorsToSample','all','Method','regression');
            
           [yp_opt]=predict(AA_opt{h,j},test_int_norm);
            
            Pearson_rf_opt(h,j)=corr(yp_opt,labtest_int,'Type','Pearson');
            Spearman_rf_opt(h,j)=corr(yp_opt,labtest_int,'Type','Spearman');
            MSE_rf_opt(h,j)=immse(yp_opt,labtest_int);
            MAE_rf_opt(h,j)=sum(abs(yp_opt-labtest_int))/length(yp_opt);      
       end
    end
      
    MSE_rf_opt_mean=squeeze(mean(MSE_rf_opt));
    
    [v,l]=min(MSE_rf_opt_mean(:));
    [optntree]=ind2sub(size(MSE_rf_opt_mean),l);
    
    indice_opt_ntree(i)=optntree;
    validation_time(i)=toc(val_time);
    %end validation time
    
    %train time start
    tr_time=tic;
    AA_ext{i}=TreeBagger(ntree(optntree),train_ext_norm,labtrain_ext,'NumPredictorsToSample','all','Method','regression','OOBPredictorImportance','on');
    train_time(i)=toc(tr_time);
    %train time end
    
    %test time start
    te_time=tic;
    [yp_ext]=predict(AA_ext{i},test_ext_norm);
    
    imp(:,i)=abs(AA_ext{i}.OOBPermutedPredictorDeltaError)';
    
    Pearson_rf_ext(i)=corr(yp_ext,labtest_ext,'Type','Pearson');
    Spearman_rf_ext(i)=corr(yp_ext,labtest_ext,'Type','Spearman');
    MSE_rf_ext(i)=immse(yp_ext,labtest_ext);
    MAE_rf_ext(i)=sum(abs(yp_ext-labtest_ext))/length(yp_ext);
   
    test_time(i)=toc(te_time);
    %test time end
end
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



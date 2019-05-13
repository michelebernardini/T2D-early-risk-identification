clc;close all; clear;
load('Data_CVOS10.mat')

%RF baseline
clc
disp('RFbaseline...')
resultsRFbaseline = myRF_baseline_CVOS10(pred,Tyg_index);
save('resultsRFbaseline','resultsRFbaseline')

%RF extravalues
clc
disp('RF999...')
resultsRF999 = myRF_extravalues_CVOS10(pred,Tyg_index);
save('resultsRFextravalues','resultsRF999')

%RF median
clc
disp('RFmedian...')
resultsRFmedian = myRF_median_CVOS10(pred,Tyg_index);
save('resultsRFmedianImputation','resultsRFmedian')


%RF knn
clc
disp('RFknn...')
pred2=knnimpute(pred');
pred2=pred2.';
resultsRFknn = myRF_knn_CVOS10(pred2,Tyg_index_mat);
save('resultsRFknnImputation','resultsRFknn')
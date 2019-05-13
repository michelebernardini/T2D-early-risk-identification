clc;close all; clear;
load('Data_CV10.mat')

%RF baseline
clc
disp('RFbaseline...')
resultsRFbaseline = myRF_baseline_CV10(pred,Tyg_index);
save('resultsRFbaseline','resultsRFbaseline')

%RF extravalues
clc
disp('RF999...')
resultsRF999 = myRF_extravalues_CV10(pred,Tyg_index);
save('resultsRFextravalues','resultsRF999')

%RF median
clc
disp('RFmedian...')
resultsRFmedian = myRF_median_CV10(pred,Tyg_index);
save('resultsRFmedianImputation','resultsRFmedian')


%RF knn
clc
disp('RFknn...')
pred2=knnimpute(pred');
pred2=pred2.';
resultsRFknn = myRF_knn_CV10(pred2,Tyg_index);
save('resultsRFknnImputation','resultsRFknn')
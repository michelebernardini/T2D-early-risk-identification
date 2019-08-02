# TyG-er: an Ensemble Regression Forest Approach for Identification of Clinical Factors related to Insulin Resistance Condition using Electronic Health Records
published in Computers in Biology and Medicine by M. Bernardini, M. Morettini, L. Romeo, E. Frontoni and L. Burattini 

The aim of this work was to propose a high-interpretable ensemble Regression Forest model combined with data imputation strategies, able to extract clinical factors from EHR data for providing early-preventive knowledge of glucose tolerance deterioration representing risk condition for type 2 diabetes.

We tested the reliability of the proposed approach, named TyG-er, on the Italian Federation of General Practitioners dataset, named FIMMG_obs dataset, publicly available at the following link: http://vrai.dii.univpm.it/content/fimmgobs-dataset

We tested the TyG-er appraoch in 3 different experimental procedures:

1) Tenfold cross validation (CV-10);
2) Tenfold cross validation over subjects (CVOS-10);
3) Leave Last Records Out (LLRO).

Each experimental procedure consists of 4 different experiments:

a) Baseline;
b) Extra values imputation;
c) Median imputation;
d) KNN imputation.

Matlab code to replicate all the experiments is provided by the authors.

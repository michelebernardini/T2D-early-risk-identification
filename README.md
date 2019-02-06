# Identification of Early Risk Conditions for Type 2 Diabetes from Electronic Health Records using a Machine Learning Approach
submitted to Journal of Biomedical Informatics by M. Bernardini, M. Morettini, L. Romeo, S. Moccia, E. Frontoni and L. Burattini 

The aim of this work was to propose a high-interpretable ensemble Regression Forest model combined with data imputation strategies, able to extract potentially unknown patterns from EHR data for providing early-preventive knowledge of glucose tolerance deterioration representing risk condition for type 2 diabetes.

We tested the reliability of the proposed approach on the Italian Federation of General Practitioners dataset, named FIMMG_obs dataset, publicly available at the following link: http://vrai.dii.univpm.it/content/fimmg-dataset

We tested the proposed Regression Forest model in three different experimental procedures:

1. Time-invariant risk factor prediction with 10-fold cross validation (CV-10)
2. Temporal risk factor prediction with 10-fold cross validation over subjects (CVOS-10)
3. Temporal risk factor prediction with leave last records out (LLRO)

Each experimental procedure consists of five different experiments:

a) Baseline;
b) Surrogate tree-based;
c) Extra values imputation;
d) Median imputation;
e) KNN imputation;

The matlab code to replicate all the experiments is provided by the authors.

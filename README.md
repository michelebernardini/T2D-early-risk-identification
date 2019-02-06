# Identification-of-early-risk-conditions-for-T2D-from-EHRs-using-a-Machine-Learning-approach
M. Bernardini, M. Morettini, L. Romeo, S. Moccia, E. Frontoni and L. Burattini, submitted to Journal of Biomedical Informatics

The aim of this work was to propose a high-interpretable ensemble Regression Forest model combined with data imputation strategies, able to extract potentially unknown patterns from EHR data for providing early-preventive knowledge of glucose tolerance deterioration representing risk condition for type 2 diabetes.

We tested the reliability of the proposed approach on the Italian Federation of General Practitioners dataset, named FIMMG_obs dataset, publicly available at the following link: http://vrai.dii.univpm.it/content/fimmg-dataset

We tested the proposed Regression Forest model in three different experimental procedures:

1. Time-invariant risk factor prediction with 10-fold cross validation (CV-10)
2. Temporal risk factor prediction with 10-fold cross validation over subjects (CVOS-10)
3. Temporal risk factor prediction with leave last records out (LLRO)

The matlab code to replicate all the experimental procedures is provided by the authors.


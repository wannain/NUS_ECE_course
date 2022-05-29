## Introduction

This `Readme.md` is to instruct how to use the codes of CA1. 

## How to run this CA1 code

The total CA1 is code by Matlab. No any extensional software libraries need to install this project. So if you update the correct path location of `spamData.mat`, it is very easy to get the final result.

#### Q1 Beta-binomial Naive Bayes

In code file, you will find this matlab file.

- `Q1_Beta_binomial.m` is the main function. It contains a sub-function named `binarization` that is used to binarize the original data as the processing step.

If you want to run this main file, the only thing to do is that you should update the correct path of `spamData.mat`. The location is in the **fifth line** of this code. After loading data well, you will get the final result within seconds by running this code. The command window will show the error rates when alpha = 1,10,100.

More detailed comment is in the code, so you can check it.

#### Q2 Gaussian Naive Bayes

In code file, you will find this matlab file.

- `Q2_Gaussian_Naive_Bayes.m` is the main function

If you want to run this main file, the only thing to do is that you should update the correct path of `spamData.mat`. The location is in the **fifth line** of this code. After loading data well, you will get the final result within seconds by running this code. The command window will show the error rates.

More detailed comment is in the code, so you can check it.

#### Q3 Logistic regression

In code file, you will find this matlab file. 

- `Q3_Logistic_regression.m` is the main function. It contains three sub-functions named `get_NLL_reg` , `get_vector_mu`, `get_diagonal_matrix`.
- `get_NLL_reg` is the function to compute the negative log likelihood with l2 regularization given the *w*
- `get_vector_mu` is the function to compute vector mu
- `get_diagonal_matrix` is the function to compute its corresponding diagonal matrix S.

If you want to run this main file, the only thing to do is that you should update the correct path of `spamData.mat`. The location is in the **fifth line** of this code. After loading data well, you will get the final result within seconds by running this code. The command window will show the error rates when lambda = 1,10,100.

More detailed comment is in the code, so you can check it.

#### Q4 K-Nearest Neighbors

In code file, you will find this matlab file.

- `Q4_K_Nearest_Neighbors.m` is the main function. It contains a sub-function named `binarization` that is used to binarize the original data as the processing step.

If you want to run this main file, the only thing to do is that you should update the correct path of `spamData.mat`. The location is in the **seventh line** of this code. After loading data well, you will get the final result by running this code. The command window will show the error rates when K = 1,10,100.

**You may need to wait for minutes before seeing the result, as it needs more time to finish running this code. Sorry about that.**

More detailed comment is in the code, so you can check it.

## Introduction

This `Readme.md` is to instruct how to use the codes of CA2. 

## How to run this CA2 code

The total CA1 is code by Matlab2021a in windows. You need to install these extensional software libraries before.

- For SVM, you need to download the **libsvm** toolkit. And follow these  commands in matlab to compile well this toolkit

  ```
  >> cd libsvm-3.22\matlab
  >> mex -setup
  >> make
  ```

  If you see four .mexw64 file are generated, you are ready to use **libsvm**

- For CNN, you need to download the **matconvnet** toolkit. And follow these  commands in matlab to download and compile well this toolkit

  ```
  >> untar(['http://www.vlfeat.org/matconvnet/download/' ...
  'matconvnet−1.0−beta25.tar.gz']) ;
  >> cd matconvnet−1.0−beta25
  >> run matlab/vl_compilenn
  ```

  If you see the result of compiling result is successful, you are ready to use **matconvnet**

#### Prepare data

in **processing_data** file, you will see `data_processing.m` and `self_data_processing.m`

I choose the 25 subjects from CMU PIE dataset randomly and store them in the `data.mat`, by running `data_processing.m`. I also take 10 selfie photos in selfdata file, convert to gray-scale images, resize them into the same resolution as the CMU PIE images and store them in the `self_data.mat`, by running `self_data_processing.m`. At the same time, I generate and save these ten gray-scale images into selfdata_new file.

And I put `data.mat` and `self_data.mat` in each algorithm files, so you can just run each algorithm directly. I also put the `data_processing.m` and `self_data_processing.m` in the **processing_data** file, and you can run it to generate new data with the CMU PIE dataset.

So if you update the correct path location of `spamData.mat`, it is very easy to get the final result.

#### PCA

In PCA file, you will find this matlab file.

- `PCA.m` is the main function. It contains a sub-function named `NNclassifier` that is used as a nearest neighbor classifier

If you want to run this main file, the only thing to do is that you should update the correct path of `data.mat` and `self_data.mat` .After loading data well, you will get the final result by running it.

More detailed comment is in the code, so you can check it.

#### LDA

In LDA file, you will find this matlab file.

- `LDA.m` is the main function. It contains a sub-function named `NNclassifier` that is used as a nearest neighbor classifier

If you want to run this main file, the only thing to do is that you should update the correct path of `data.mat` and `self_data.mat` .After loading data well, you will get the final result by running it.

More detailed comment is in the code, so you can check it.

#### GMM

In GMM file, you will find this matlab file.

- `GMM.m` is the main function. 

If you want to run this main file, the only thing to do is that you should update the correct path of `data.mat` and `self_data.mat` .After loading data well, you will get the final result by running it.

More detailed comment is in the code, so you can check it.

#### SVM

In SVM file, you will find this matlab file.

- `SVM.m` is the main function.

If you want to run this main file, you must make sure you have installed **libsvm** well. And next thing to do is that you should update the correct path of `data.mat` and `self_data.mat` . After loading data well, you will get the final result by running it.

More detailed comment is in the code, so you can check it.

#### CNN

In CNN file, you will find these matlab files.

- `CNN_with_padding.m` is the main function to run a CNN model with padding.
- `CNN_without_padding.m` is the main function to run a CNN model without padding.
- params_2021_11_11__04_18_22.mat is the data I prepare for the CNN with padding.
- params_2021_11_12__06_08_18.mat is the data I prepare for the CNN without padding.
- prepare_data file is the data file I choose 20 subjects from PIE and one subject from my selfie in this CNN part. 

If you want to run these main file, you must make sure you have installed matconvnet well. And next thing to do is that you should update the correct path of `params_2021_11_11__04_18_22.mat` and `params_2021_11_12__06_08_18.mat` . After loading data well, you will get the final result by running it.

If you want to use your data, you can type these commands in matlab.

```
>> deepNetworkDesigner
```

And then you can change the data in the setting steps if you want to verify this model.

More detailed comment is in the code, so you can check it.


Applied Data Science
========================================================
author: Modeling
date: 02.07.2019
autosize: false
width: 1920
height: 1080
font-family: 'Arial'
css: mySlideTemplate.css

Credits
======
* http://www.rebeccabarter.com/blog/2019-06-06_pre_processing/


Predictive modeling has many pitfalls
=======

* In principle pre-processing data in R for predictive modeling is fairly straightforward: However, simple things such as factor variables having different levels in the training data and test data, or a variable having missing values in the test data but not in the training data can seriously mess up this apparent simplicity

* Also - similar functions have greatly varying syntax complicating comparison and benchmarking

* Thanks to the `tidymodels` package ecosystem many problems are directly adressed
    * `recipes` is a general data preprocessor with a modern interface. It can create model matrices that incorporate feature engineering, imputation, and other help tools.
    * `rsample` has infrastructure for resampling data so that models can be assessed and empirically validated.
    * `yardstick` contains tools for evaluating models (e.g. accuracy, RMSE, etc.)
    * `parsnip` separates the definition of a model from its evaluation
    * `infer` is a modern approach to statistical inference


The fundamentals of pre-processing your data using recipes
========================================================
Creating a `recipe` has three steps:

* Get the ingredients (`recipe()`): specify the response variable and predictor variables

* Write the recipe (`step_zzz()`): define the pre-processing steps, such as imputation, creating dummy variables, scaling, and more

* Prepare the recipe (`prep()`): provide a dataset to base each step on (e.g. if one of the steps is to remove variables that only have one unique value, then you need to give it a dataset so it can decide which variables satisfy this criteria to ensure that it is doing the same thing to every dataset you apply it to)

* Bake the recipe (`bake()`): apply the pre-processing steps to your datasets

A credit default example
=====

* Our goal will be to classify whether or not credit card customers will default on their debt


```r
library(tidyverse)
credit = read.csv2("../Lecture Code/UCI_Credit_Card.csv", sep=",", dec=".")
```

* The variables and data look as follows


```r
names(credit)
```

```
 [1] "ID"                         "LIMIT_BAL"                 
 [3] "SEX"                        "EDUCATION"                 
 [5] "MARRIAGE"                   "AGE"                       
 [7] "PAY_0"                      "PAY_2"                     
 [9] "PAY_3"                      "PAY_4"                     
[11] "PAY_5"                      "PAY_6"                     
[13] "BILL_AMT1"                  "BILL_AMT2"                 
[15] "BILL_AMT3"                  "BILL_AMT4"                 
[17] "BILL_AMT5"                  "BILL_AMT6"                 
[19] "PAY_AMT1"                   "PAY_AMT2"                  
[21] "PAY_AMT3"                   "PAY_AMT4"                  
[23] "PAY_AMT5"                   "PAY_AMT6"                  
[25] "default.payment.next.month"
```


Some data from Credit
======


```r
glimpse(credit)
```

```
Observations: 30,000
Variables: 25
$ ID                         <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, ...
$ LIMIT_BAL                  <dbl> 20000, 120000, 90000, 50000, 50000,...
$ SEX                        <int> 2, 2, 2, 2, 1, 1, 1, 2, 2, 1, 2, 2,...
$ EDUCATION                  <int> 2, 2, 2, 2, 2, 1, 1, 2, 3, 3, 3, 1,...
$ MARRIAGE                   <int> 1, 2, 2, 1, 1, 2, 2, 2, 1, 2, 2, 2,...
$ AGE                        <int> 24, 26, 34, 37, 57, 37, 29, 23, 28,...
$ PAY_0                      <int> 2, -1, 0, 0, -1, 0, 0, 0, 0, -2, 0,...
$ PAY_2                      <int> 2, 2, 0, 0, 0, 0, 0, -1, 0, -2, 0, ...
$ PAY_3                      <int> -1, 0, 0, 0, -1, 0, 0, -1, 2, -2, 2...
$ PAY_4                      <int> -1, 0, 0, 0, 0, 0, 0, 0, 0, -2, 0, ...
$ PAY_5                      <int> -2, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, ...
$ PAY_6                      <int> -2, 2, 0, 0, 0, 0, 0, -1, 0, -1, -1...
$ BILL_AMT1                  <dbl> 3913, 2682, 29239, 46990, 8617, 644...
$ BILL_AMT2                  <dbl> 3102, 1725, 14027, 48233, 5670, 570...
$ BILL_AMT3                  <dbl> 689, 2682, 13559, 49291, 35835, 576...
$ BILL_AMT4                  <dbl> 0, 3272, 14331, 28314, 20940, 19394...
$ BILL_AMT5                  <dbl> 0, 3455, 14948, 28959, 19146, 19619...
$ BILL_AMT6                  <dbl> 0, 3261, 15549, 29547, 19131, 20024...
$ PAY_AMT1                   <dbl> 0, 0, 1518, 2000, 2000, 2500, 55000...
$ PAY_AMT2                   <dbl> 689, 1000, 1500, 2019, 36681, 1815,...
$ PAY_AMT3                   <dbl> 0, 1000, 1000, 1200, 10000, 657, 38...
$ PAY_AMT4                   <dbl> 0, 1000, 1000, 1100, 9000, 1000, 20...
$ PAY_AMT5                   <dbl> 0, 0, 1000, 1069, 689, 1000, 13750,...
$ PAY_AMT6                   <dbl> 0, 2000, 5000, 1000, 679, 800, 1377...
$ default.payment.next.month <int> 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...
```

Some data from Credit
======


```r
summary(credit[,1:13])
```

```
       ID          LIMIT_BAL            SEX          EDUCATION    
 Min.   :    1   Min.   :  10000   Min.   :1.000   Min.   :0.000  
 1st Qu.: 7501   1st Qu.:  50000   1st Qu.:1.000   1st Qu.:1.000  
 Median :15000   Median : 140000   Median :2.000   Median :2.000  
 Mean   :15000   Mean   : 167484   Mean   :1.604   Mean   :1.853  
 3rd Qu.:22500   3rd Qu.: 240000   3rd Qu.:2.000   3rd Qu.:2.000  
 Max.   :30000   Max.   :1000000   Max.   :2.000   Max.   :6.000  
    MARRIAGE          AGE            PAY_0             PAY_2        
 Min.   :0.000   Min.   :21.00   Min.   :-2.0000   Min.   :-2.0000  
 1st Qu.:1.000   1st Qu.:28.00   1st Qu.:-1.0000   1st Qu.:-1.0000  
 Median :2.000   Median :34.00   Median : 0.0000   Median : 0.0000  
 Mean   :1.552   Mean   :35.49   Mean   :-0.0167   Mean   :-0.1338  
 3rd Qu.:2.000   3rd Qu.:41.00   3rd Qu.: 0.0000   3rd Qu.: 0.0000  
 Max.   :3.000   Max.   :79.00   Max.   : 8.0000   Max.   : 8.0000  
     PAY_3             PAY_4             PAY_5             PAY_6        
 Min.   :-2.0000   Min.   :-2.0000   Min.   :-2.0000   Min.   :-2.0000  
 1st Qu.:-1.0000   1st Qu.:-1.0000   1st Qu.:-1.0000   1st Qu.:-1.0000  
 Median : 0.0000   Median : 0.0000   Median : 0.0000   Median : 0.0000  
 Mean   :-0.1662   Mean   :-0.2207   Mean   :-0.2662   Mean   :-0.2911  
 3rd Qu.: 0.0000   3rd Qu.: 0.0000   3rd Qu.: 0.0000   3rd Qu.: 0.0000  
 Max.   : 8.0000   Max.   : 8.0000   Max.   : 8.0000   Max.   : 8.0000  
   BILL_AMT1      
 Min.   :-165580  
 1st Qu.:   3559  
 Median :  22382  
 Mean   :  51223  
 3rd Qu.:  67091  
 Max.   : 964511  
```

Some data from Credit
======


```r
summary(credit[,12:25])
```

```
     PAY_6           BILL_AMT1         BILL_AMT2        BILL_AMT3      
 Min.   :-2.0000   Min.   :-165580   Min.   :-69777   Min.   :-157264  
 1st Qu.:-1.0000   1st Qu.:   3559   1st Qu.:  2985   1st Qu.:   2666  
 Median : 0.0000   Median :  22382   Median : 21200   Median :  20089  
 Mean   :-0.2911   Mean   :  51223   Mean   : 49179   Mean   :  47013  
 3rd Qu.: 0.0000   3rd Qu.:  67091   3rd Qu.: 64006   3rd Qu.:  60165  
 Max.   : 8.0000   Max.   : 964511   Max.   :983931   Max.   :1664089  
   BILL_AMT4         BILL_AMT5        BILL_AMT6          PAY_AMT1     
 Min.   :-170000   Min.   :-81334   Min.   :-339603   Min.   :     0  
 1st Qu.:   2327   1st Qu.:  1763   1st Qu.:   1256   1st Qu.:  1000  
 Median :  19052   Median : 18105   Median :  17071   Median :  2100  
 Mean   :  43263   Mean   : 40311   Mean   :  38872   Mean   :  5664  
 3rd Qu.:  54506   3rd Qu.: 50191   3rd Qu.:  49198   3rd Qu.:  5006  
 Max.   : 891586   Max.   :927171   Max.   : 961664   Max.   :873552  
    PAY_AMT2          PAY_AMT3         PAY_AMT4         PAY_AMT5       
 Min.   :      0   Min.   :     0   Min.   :     0   Min.   :     0.0  
 1st Qu.:    833   1st Qu.:   390   1st Qu.:   296   1st Qu.:   252.5  
 Median :   2009   Median :  1800   Median :  1500   Median :  1500.0  
 Mean   :   5921   Mean   :  5226   Mean   :  4826   Mean   :  4799.4  
 3rd Qu.:   5000   3rd Qu.:  4505   3rd Qu.:  4013   3rd Qu.:  4031.5  
 Max.   :1684259   Max.   :896040   Max.   :621000   Max.   :426529.0  
    PAY_AMT6        default.payment.next.month
 Min.   :     0.0   Min.   :0.0000            
 1st Qu.:   117.8   1st Qu.:0.0000            
 Median :  1500.0   Median :0.0000            
 Mean   :  5215.5   Mean   :0.2212            
 3rd Qu.:  4000.0   3rd Qu.:0.0000            
 Max.   :528666.0   Max.   :1.0000            
```

Train-test split for predictive modeling
=====

* We do some cleaning and renaming and then split the data 80%-20%.


```r
library(rsample)
credit %>% 
  rename(default = default.payment.next.month) %>%
  mutate(MARRIAGE = as.factor(MARRIAGE),
         SEX = as.factor(SEX),
         EDUCATION = as.factor(EDUCATION)) %>%
  dplyr::select(-ID) -> credit
credit_split <- initial_split(credit, prop = 0.8, strata = "default")
credit_train <- training(credit_split)
credit_test <- testing(credit_split)
```

* Training Data: 

```r
nrow(credit_train)
```

```
[1] 24001
```

* Test Data:

```r
nrow(credit_test)
```

```
[1] 5999
```


Writing and applying the recipe
=====
* Now that the data is ready we can write some recipes and do some baking!
* The first thing we need to do is get the ingredients. We can use formula notation within the `recipe()` function to do this * the thing we’re trying to predict is the variable to the left of the `~`, and the predictor variables are the things to the right of it
    * When including all variables we can write `default ~ .`
    

```r
library(tidymodels)
# define the recipe (it looks a lot like applying the lm function)
model_recipe <- recipe(default ~ ., 
                       data = credit_train)

summary(model_recipe)
```

```
# A tibble: 24 x 4
   variable  type    role      source  
   <chr>     <chr>   <chr>     <chr>   
 1 LIMIT_BAL numeric predictor original
 2 SEX       nominal predictor original
 3 EDUCATION nominal predictor original
 4 MARRIAGE  nominal predictor original
 5 AGE       numeric predictor original
 6 PAY_0     numeric predictor original
 7 PAY_2     numeric predictor original
 8 PAY_3     numeric predictor original
 9 PAY_4     numeric predictor original
10 PAY_5     numeric predictor original
# ... with 14 more rows
```
    
Writing the recipe steps
====

So now we have our ingredients, we are ready to write the recipe (i.e. describe our pre-processing steps). We write the recipe one step at a time. We have many steps to choose from, including:

* `step_dummy()` creating dummy variables from categorical variables.

* `step_zzzimpute()` where instead of "zzz" it is the name of a method, such as `step_knnimpute()`, `step_meanimpute()`, `step_modeimpute()`

* `step_scale()`: normalize to have a standard deviation of 1

* `step_center()`: center to have a mean of 0

* `step_range()`: normalize numeric data to be within a pre-defined range of values

* `step_pca()`: create principal component variables from your data

* `step_nzv()`: remove variables that have (or almost have) the same value for every data point 

You can also create your own step (https://tidymodels.github.io/recipes/articles/Custom_Steps.html)

Writing the recipe steps (2)
=====

In each step, you need to specify which variables you want to apply it to. There are many ways to do this:

* Specifying the variable name(s) as the first argument

* Standard dplyr selectors: `everything()` applies the step to all columns, `contains()` allows you to specify column names that contain a specific string, `starts_with()` allows you to specify column names that start with a sepcific string,

Functions that specify the role of the variables:

* `all_predictors()` applies the step to the predictor variables only

* `all_outcomes()` applies the step to the outcome variable(s) only

Functions that specify the type of the variables:

* `all_nominal()` applies the step to all variables that are nominal (categorical)

* `all_numeric()` applies the step to all variables that are numeric

Back to credit data
=====

```r
model_recipe_steps <- model_recipe %>% 
  # convert the additional ingredients variable to dummy variables
  step_num2factor(default, PAY_0, PAY_2, PAY_3, PAY_4, PAY_5, PAY_6) %>%
  step_dummy(SEX, EDUCATION, MARRIAGE, PAY_0, PAY_2, PAY_3, PAY_4, PAY_5, PAY_6) %>%
  # rescale all numeric variables
  step_scale(all_numeric()) %>%
  step_nzv(all_predictors())
```

Note that we could have included `step_num2factor()` to fix SEX, EDUCATION and MARRIAGE

***


```r
model_recipe_steps
```

```
Data Recipe

Inputs:

      role #variables
   outcome          1
 predictor         23

Operations:

Factor variables from default, PAY_0, PAY_2, PAY_3, PAY_4, ...
Dummy variables from SEX, EDUCATION, MARRIAGE, PAY_0, PAY_2, PAY_3, ...
Scaling for all_numeric()
Sparse, unbalanced variable filter on all_predictors()
```


Order of steps
====

https://tidymodels.github.io/recipes/articles/Ordering.html

While your project’s needs may vary, here is a suggested order of potential steps that should work for most problems:

* Impute
* Individual transformations for skewness and other issues
* Discretize (if needed and if you have no other choice)
* Create dummy variables
* Create interactions
* Normalization steps (center, scale, range, etc)
* Multivariate transformation (e.g. PCA, spatial sign, etc)


Preparing and baking the recipe
=====


```r
prepped_recipe <- prep(model_recipe_steps, training = credit_train)
prepped_recipe
```

```
Data Recipe

Inputs:

      role #variables
   outcome          1
 predictor         23

Training data contained 24001 data points and no missing data.

Operations:

Factor variables from default, PAY_0, PAY_2, PAY_3, PAY_4, ... [trained]
Dummy variables from SEX, EDUCATION, MARRIAGE, PAY_0, PAY_2, PAY_3, ... [trained]
Scaling for LIMIT_BAL, AGE, BILL_AMT1, ... [trained]
Sparse, unbalanced variable filter removed EDUCATION_X4, ... [trained]
```
***


```r
credit_train_preprocessed <- bake(prepped_recipe, credit_train)
credit_test_preprocessed <- bake(prepped_recipe, credit_test)

credit_train_preprocessed
```

```
# A tibble: 24,001 x 40
   LIMIT_BAL   AGE BILL_AMT1 BILL_AMT2 BILL_AMT3 BILL_AMT4 BILL_AMT5
       <dbl> <dbl>     <dbl>     <dbl>     <dbl>     <dbl>     <dbl>
 1     0.154  2.60    0.0532    0.0436   0.00993    0         0     
 2     0.384  4.01    0.638     0.679    0.710      0.440     0.476 
 3     0.384  6.17    0.117     0.0798   0.516      0.326     0.315 
 4     3.84   3.14    5.00      5.80     6.41       8.44      7.94  
 5     1.08   3.03    0.153     0.198    0.174      0.190     0.194 
 6     0.154  3.79    0         0        0          0         0.214 
 7     1.54   3.68    0.150     0.138    0.0798     0.0391    0.0300
 8     2.00   5.52    0.167     0.305    0.144      0.132     0.366 
 9     4.84   4.44    0.165     0.0915   0.0937     0.101     0.107 
10     0.538  3.25    0.894     0.948    0.947      1.04      0.594 
# ... with 23,991 more rows, and 33 more variables: BILL_AMT6 <dbl>,
#   PAY_AMT1 <dbl>, PAY_AMT2 <dbl>, PAY_AMT3 <dbl>, PAY_AMT4 <dbl>,
#   PAY_AMT5 <dbl>, PAY_AMT6 <dbl>, default <fct>, SEX_X2 <dbl>,
#   EDUCATION_X1 <dbl>, EDUCATION_X2 <dbl>, EDUCATION_X3 <dbl>,
#   MARRIAGE_X1 <dbl>, MARRIAGE_X2 <dbl>, PAY_0_X.2 <dbl>, PAY_0_X0 <dbl>,
#   PAY_0_X1 <dbl>, PAY_0_X2 <dbl>, PAY_2_X.2 <dbl>, PAY_2_X0 <dbl>,
#   PAY_2_X2 <dbl>, PAY_3_X.2 <dbl>, PAY_3_X0 <dbl>, PAY_3_X2 <dbl>,
#   PAY_4_X.2 <dbl>, PAY_4_X0 <dbl>, PAY_4_X2 <dbl>, PAY_5_X.2 <dbl>,
#   PAY_5_X0 <dbl>, PAY_5_X2 <dbl>, PAY_6_X.2 <dbl>, PAY_6_X0 <dbl>,
#   PAY_6_X2 <dbl>
```

Specifying the models
====


```r
logistic_glm <-
  logistic_reg(mode = "classification") %>%
  set_engine("glm") %>%
  fit(default ~ ., data = credit_train_preprocessed)

rf_mod <- 
  rand_forest(
    mode = "classification",
    trees = 250) %>%
  set_engine("ranger") %>%
  fit(default ~ ., data = credit_train_preprocessed)
```

***


```r
boost_mod <-
  boost_tree(mode = "classification",
             trees = 1500,
             mtry = 3,
             learn_rate = 0.03,
             sample_size = 1,
             tree_depth = 5) %>%
  set_engine("xgboost") %>%
    fit(default ~ ., data = credit_train_preprocessed)
```

Running predictions
=====


```r
predictions_glm <- logistic_glm %>%
  predict(new_data = credit_test_preprocessed) %>%
  bind_cols(credit_test_preprocessed %>% dplyr::select(default))

predictions_rf <- rf_mod %>%
  predict(new_data = credit_test_preprocessed) %>%
  bind_cols(credit_test_preprocessed %>% dplyr::select(default))

predictions_boost <- boost_mod %>%
  predict(new_data = credit_test_preprocessed) %>%
  bind_cols(credit_test_preprocessed %>% dplyr::select(default))
```

Evaluating the results
====


```r
predictions_glm %>%
  conf_mat(default, .pred_class)
predictions_rf %>%
  conf_mat(default, .pred_class)
```
***

```r
predictions_boost %>%
  conf_mat(default, .pred_class)
```

Evaluating the results (2)
====

```r
predictions_glm %>%
  conf_mat(default, .pred_class) %>%
  summary() %>%
  dplyr::select(-.estimator) %>%
  filter(.metric %in%
    c("accuracy", "mcc", "f_meas"))

predictions_rf %>%
  conf_mat(default, .pred_class) %>%
  summary() %>%
  dplyr::select(-.estimator) %>%
  filter(.metric %in%
    c("accuracy", "mcc", "f_meas"))
```
***

```r
predictions_boost %>%
  conf_mat(default, .pred_class) %>%
  summary() %>%
  dplyr::select(-.estimator) %>%
  filter(.metric %in%
    c("accuracy", "mcc", "f_meas"))
```


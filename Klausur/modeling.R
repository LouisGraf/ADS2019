#Data Modeling
library(tidyverse)
library(tidymodels)
library(rsample)
library(parsnip)
library(xgboost)

# train test split
basketball_split = initial_split(basketball, prop = 0.8, strata = 'shot_made_flag')
basketball_train = training(basketball_split)
basketball_test = testing(basketball_split)




# recipe
model_recipe = recipe(shot_made_flag ~., data = basketball_train)

model_recipe %>%
  step_modeimpute(combined_shot_type) %>%
  step_string2factor(combined_shot_type, season, shot_type) %>%
  step_num2factor(period, playoffs, shot_made_flag) %>%
  step_dummy(combined_shot_type, season, shot_type, period, playoffs) %>%
  step_scale(all_numeric()) %>%
  step_center(all_numeric()) -> model_recipe_steps



# Prep and bake
prepped_recipe = prep(model_recipe_steps, training = basketball_train)
basketball_train_preprocessed = bake(prepped_recipe, basketball_train)
basketball_test_preprocessed = bake(prepped_recipe, basketball_test)



# Train Models
logistic_glm <-
  logistic_reg(mode = "classification") %>%
  set_engine("glm") %>%
  fit(shot_made_flag ~ ., data = basketball_train_preprocessed)

rf_mod <- 
  rand_forest(
    mode = "classification",
    trees = 250) %>%
  set_engine("ranger") %>%
  fit(shot_made_flag ~ ., data = basketball_train_preprocessed)

boost_mod <-
  boost_tree(mode = "classification",
             trees = 1500,
             mtry = 3,
             learn_rate = 0.03,
             sample_size = 1,
             tree_depth = 5) %>%
  set_engine("xgboost") %>%
  fit(shot_made_flag ~ ., data = basketball_train_preprocessed)



# Predictions
predictions_glm <- logistic_glm %>%
  predict(new_data = basketball_test_preprocessed) %>%
  bind_cols(basketball_test_preprocessed %>% dplyr::select(shot_made_flag))

predictions_rf <- rf_mod %>%
  predict(new_data = basketball_test_preprocessed) %>%
  bind_cols(basketball_test_preprocessed %>% dplyr::select(shot_made_flag))

predictions_boost <- boost_mod %>%
  predict(new_data = basketball_test_preprocessed) %>%
  bind_cols(basketball_test_preprocessed %>% dplyr::select(shot_made_flag))




#Evaluation Confusion Matrix
predictions_glm %>%
  conf_mat(shot_made_flag, .pred_class)

predictions_rf %>%
  conf_mat(shot_made_flag, .pred_class)

predictions_boost %>%
  conf_mat(shot_made_flag, .pred_class)




#Evaluation Acc, Mcc, f_meas

predictions_glm %>%
  conf_mat(shot_made_flag, .pred_class) %>%
  summary() %>%
  dplyr::select(-.estimator) %>%
  filter(.metric %in%
           c("accuracy", "mcc", "f_meas"))

predictions_rf %>%
  conf_mat(shot_made_flag, .pred_class) %>%
  summary() %>%
  dplyr::select(-.estimator) %>%
  filter(.metric %in%
           c("accuracy", "mcc", "f_meas"))

predictions_boost %>%
  conf_mat(shot_made_flag, .pred_class) %>%
  summary() %>%
  dplyr::select(-.estimator) %>%
  filter(.metric %in%
           c("accuracy", "mcc", "f_meas"))

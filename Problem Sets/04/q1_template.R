# Problem Set 4
# Question 1

# Name: Louis Graf
# Matrikelnummer: 2389931

library(tidyverse)
library(hexbin)
library(tidymodels)
library(esquisse)
library(xgboost)
library(kernlab)
options("esquisse.display.mode" = "dialog")
#a) ---------------------------

bball_data = read_csv2("Problem Sets/04/basketball_complete.csv")

bball_data %>%
  ggplot(aes(x = loc_x, y = loc_y, z = shot_made_flag)) +
  stat_summary_hex(fun = "mean",) +
  theme_bw()

#b) -------------------------------
#Splitting Data into Training- & Testsplit
bball_split <- initial_split(bball_data, prop = 0.8)
bball_train <- training(bball_split)
bball_test <- testing(bball_split)



#Building the recipe
recipe <- recipe(shot_made_flag ~ . , data = bball_train)

recipe %>%
  step_num2factor(shot_made_flag) %>%
  step_string2factor(season) %>%
  step_dummy(shot_type, combined_shot_type) %>%
  step_nzv(all_predictors()) %>%
  step_scale(all_numeric())-> recipe_steps



#Preparing and Preprocessing the data
prepped_recipe <- prep(recipe_steps, training = bball_train)

train_preprocessed <- bake(prepped_recipe, bball_train)
test_preprocessed <- bake(prepped_recipe, bball_test)



#Modeling Data
logistic_glm <- logistic_reg(mode = "classification") %>%
  set_engine("glm") %>%
  fit(shot_made_flag ~ ., data = train_preprocessed)


rf_mod <- rand_forest(
          mode = "classification",
          trees = 250) %>%
  set_engine("ranger") %>%
  fit(shot_made_flag ~ ., data = train_preprocessed)


boost_mod <- boost_tree(mode = "classification",
             trees = 1500,
             mtry = 3,
             learn_rate = 0.03,
             sample_size = 1,
             tree_depth = 5) %>%
  set_engine("xgboost") %>%
  fit(shot_made_flag ~ ., data = train_preprocessed)


#Running Predictions
predictions_glm <- logistic_glm %>%
  predict(new_data = test_preprocessed) %>%
  bind_cols(test_preprocessed %>% dplyr::select(shot_made_flag))


predictions_rf <- rf_mod %>%
  predict(new_data = test_preprocessed) %>%
  bind_cols(test_preprocessed %>% dplyr::select(shot_made_flag))


predictions_boost <- boost_mod %>%
  predict(new_data = test_preprocessed) %>%
  bind_cols(test_preprocessed %>% dplyr::select(shot_made_flag))



#Evaluating the results
predictions_glm %>%
  conf_mat(shot_made_flag, .pred_class) %>%
  summary() %>%
  dplyr::select(-.estimator) %>%
  filter(.metric %in% c("accuracy", "mcc", "f_meas"))


predictions_rf %>%
  conf_mat(shot_made_flag, .pred_class) %>%
  summary() %>%
  dplyr::select(-.estimator) %>%
  filter(.metric %in% c("accuracy", "mcc", "f_meas"))


predictions_boost %>%
  conf_mat(shot_made_flag, .pred_class) %>%
  summary() %>%
  dplyr::select(-.estimator) %>%
  filter(.metric %in% c("accuracy", "mcc", "f_meas"))


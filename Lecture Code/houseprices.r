library(tidyverse)
library(lubridate)
houses = read.csv2("Lecture Code/kc_house_data.csv", sep=",", dec=".")

library(rsample)
houses %>% 
  mutate(date = ymd_hms(as.character(date)),
         month = month(date),
         year = year(date),
         dateNumeric = as.numeric(date)) %>%
  dplyr::select(-id, -date) -> houses.prepared

houses_split <- initial_split(houses.prepared, prop = 0.8)
houses_train <- training(houses_split)
houses_test <- testing(houses_split)

library(tidymodels)
# define the recipe (it looks a lot like applying the lm function)
model_recipe <- recipe(price ~ ., 
                       data = houses_train)

summary(model_recipe)

model_recipe_steps <- model_recipe %>% 
  # convert the additional ingredients variable to dummy variables
  step_num2factor(waterfront, view) %>%
  # rescale all numeric variables
  step_scale(all_numeric())

prepped_recipe <- prep(model_recipe_steps,
                       training = houses_train)
prepped_recipe

houses_train_preprocessed <- bake(prepped_recipe,
                                  houses_train)
houses_test_preprocessed <- bake(prepped_recipe,
                                 houses_test)

houses_train_preprocessed

linear_reg <-
  linear_reg(mode = "regression") %>%
  set_engine("lm") %>%
  fit(price ~ ., data = houses_train_preprocessed)

rf_mod <- 
  rand_forest(
    mode = "regression",
    trees = 250) %>%
  set_engine("ranger") %>%
  fit(price ~ ., data = houses_train_preprocessed)

boost_mod <-
  boost_tree(mode = "regression",
             trees = 500,
             mtry = 5,
             learn_rate = 0.075,
             sample_size = 1,
             tree_depth = 3) %>%
  set_engine("xgboost") %>%
  fit(price ~ ., data = houses_train_preprocessed)

predictions_lm <- linear_reg %>%
  predict(new_data = houses_test_preprocessed) %>%
  bind_cols(houses_test_preprocessed %>% dplyr::select(price))

predictions_rf <- rf_mod %>%
  predict(new_data = houses_test_preprocessed) %>%
  bind_cols(houses_test_preprocessed %>% dplyr::select(price))

predictions_boost <- boost_mod %>%
  predict(new_data = houses_test_preprocessed) %>%
  bind_cols(houses_test_preprocessed %>% dplyr::select(price))

predictions = list(predictions_lm, predictions_rf, predictions_boost)

predictions %>% map(function(x){metrics(x, truth = price, estimate = .pred)})

importance <- xgboost::xgb.importance(boost_mod$fit$feature_names, model = boost_mod$fit)
xgboost::xgb.plot.importance(importance)


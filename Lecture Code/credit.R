library(tidyverse)
credit = read.csv2("Lecture Code/UCI_Credit_Card.csv", sep=",", dec=".")

library(rsample)
credit %>% 
  rename(default = default.payment.next.month) %>%
  mutate(MARRIAGE = as.factor(MARRIAGE),
         SEX = as.factor(SEX),
         EDUCATION = as.factor(EDUCATION)) %>%
  dplyr::select(-ID) -> credit

credit_split <- initial_split(credit, prop = 0.8)
credit_train <- training(credit_split)
credit_test <- testing(credit_split)

library(tidymodels)
# define the recipe (it looks a lot like applying the lm function)
model_recipe <- recipe(default ~ ., 
                       data = credit_train)

summary(model_recipe)

model_recipe_steps <- model_recipe %>% 
  # convert the additional ingredients variable to dummy variables
  step_num2factor(default, PAY_0, PAY_2, PAY_3, PAY_4, PAY_5, PAY_6) %>%
  # rescale all numeric variables
  step_scale(all_numeric()) %>%
  step_pca(all_numeric()) %>%
  step_dummy(SEX, EDUCATION, MARRIAGE, PAY_0, PAY_2, PAY_3, PAY_4, PAY_5, PAY_6)

prepped_recipe <- prep(model_recipe_steps, training = credit_train)
prepped_recipe

credit_train_preprocessed <- bake(prepped_recipe, credit_train)
credit_test_preprocessed <- bake(prepped_recipe, credit_test)

credit_train_preprocessed

logistic_glm <-
  logistic_reg(mode = "classification") %>%
  set_engine("glm") %>%
  fit(default ~ ., data = credit_train_preprocessed)

glmn <- 
  logistic_reg(penalty = 0.01, mixture = 0.5) %>% 
  set_engine("glmnet") %>%
  fit(default ~ ., data = credit_train_preprocessed)
glmn

rf_mod <- 
  rand_forest(
    mode = "classification",
    trees = 250) %>%
  set_engine("ranger") %>%
  fit(default ~ ., data = credit_train_preprocessed)

boost_mod <-
  boost_tree(mode = "classification",
             trees = 500,
             mtry = 5,
             learn_rate = 0.075,
             sample_size = 1,
             tree_depth = 3) %>%
  set_engine("xgboost") %>%
  fit(default ~ ., data = credit_train_preprocessed)

predictions_glm <- logistic_glm %>%
  predict(new_data = credit_test_preprocessed) %>%
  bind_cols(credit_test_preprocessed %>% dplyr::select(default))

predictions_glmnet <- glmn %>%
  predict(new_data = credit_test_preprocessed) %>%
  bind_cols(credit_test_preprocessed %>% dplyr::select(default))

predictions_rf <- rf_mod %>%
  predict(new_data = credit_test_preprocessed) %>%
  bind_cols(credit_test_preprocessed %>% dplyr::select(default))

predictions_boost <- boost_mod %>%
  predict(new_data = credit_test_preprocessed) %>%
  bind_cols(credit_test_preprocessed %>% dplyr::select(default))

predictions_glm %>%
  conf_mat(default, .pred_class) %>%
  summary() %>%
  dplyr::select(-.estimator) %>%
  filter(.metric %in%
           c("accuracy", "mcc", "f_meas"))

predictions_glmnet %>%
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

predictions_boost %>%
  conf_mat(default, .pred_class) %>%
  summary() %>%
  dplyr::select(-.estimator) %>%
  filter(.metric %in%
           c("accuracy", "mcc", "f_meas", "auc"))

predictions_boost_prob <- boost_mod %>%
  predict(new_data = credit_test_preprocessed, type = "prob") %>%
  bind_cols(credit_test_preprocessed %>% dplyr::select(default))

predictions_boost_prob %>%
roc_curve(default, .pred_0) %>%
  ggplot(aes(x = 1 - specificity, y = sensitivity)) +
  geom_path() +
  geom_abline(lty = 3) +
  coord_equal() +
  theme_bw()

predictions_boost_prob %>%
  roc_auc(default, .pred_0)

#### Bagging-Bootstrap Aggrgrating



Make decisions by averaging learner's output (regression) or majority voting (classification)



Assume m training examples, then randomly sampling m examples with replacement.



Bagging train multiple learner on data by bootstrap sampling

Bagging reduces variance, especially for unstable learners.



#### Random Forest

Use decision tree as the base learner

Decision tree is unstable, linear regression is stable.



#### Boosting

Boosting combines weak learners into a strong one/ Primarily to reduce bias.



Re-sample data focus on wrong prediction class.



Gradient boosting learns weak learners by fitting the residuals



Use decision tree as the weak learner
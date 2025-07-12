% generate points
%MCMCgenerator("MCMCsamples.mat",100);

% run simulator on generated points
%runSim("MCMCsamples.mat",'SIMsamples.mat');

% estimate abnormal time 
t_ab=Tab_estimate("SIMsamples1.mat");

% estimate transition probabilities
calculateTransitionProbabilities("SIMsamples1.mat");

% expected time using transition probabilities
load("prob_time.mat");
hVH=avg_time(3)+transitionProbabilities(3,6)*avg_time(6);
hVL=avg_time(2)+transitionProbabilities(2,5)*avg_time(5);
hAB=hVL+hVH;
fprintf("\n\n----- FINAL RESULTS -----\n1-\tExpected time is %f\n",t_ab);
fprintf("2-\tExpected time is %f\n",hAB);


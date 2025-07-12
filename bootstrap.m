
function bootstrap(X)
    n = length(X);
    
    % Bootstrap parameters
    B = 10000; 
    alpha = 0.05;
    
    bootstrap_means = zeros(B, 1);
    
    for b = 1:B
        bootstrap_sample = X(randi(n, n, 1)); 
        bootstrap_means(b) = mean(bootstrap_sample);
    end
    
    lower_bound = prctile(bootstrap_means, 100 * alpha / 2); 
    upper_bound = prctile(bootstrap_means, 100 * (1 - alpha / 2)); 
    
    fprintf('Confidence interval of 95%%: [%.4f, %.4f]\n', lower_bound, upper_bound);
    fprintf('Interval width: %.4f\n', upper_bound - lower_bound);
end


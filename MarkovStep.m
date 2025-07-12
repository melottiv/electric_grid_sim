function x=MarkovStep(x_curr,f_new,sigma)
% proposal function
proposal = @(x) x + sigma * randn(1, 3);

% density of empirical distribution
get_density = @(x) f_new(min(max(round(x(1)), 1), 6), ...
                     min(max(round(x(2)), 1), 6), ...
                     min(max(round(x(3)), 1), 6));

    while true              % keeps trying until it gets an accepted sample
            x_prime = proposal(x_curr);
            if any(x_prime < 1) || any(x_prime > 6)
                continue;
            end
            f_curr = get_density(x_curr);
            f_prime = get_density(x_prime);
            acceptance_ratio = f_prime / f_curr;
            if acceptance_ratio >= 1 || rand() <= acceptance_ratio
                x = x_prime;
                break           % finds one and moves on
            end
    end
end
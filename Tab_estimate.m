function t_ab=Tab_estimate(filename)
    load(filename);
    %load("simulated_data.mat");
    N=size(e_tot,2);
    
    results = NaN(1, N); 
    
    for i = 1:N
        e=e_tot{i};
        te=te_tot{i};
        results(i) = abnormalTime(e,te);
    end
    t_ab=mean(results);
    fprintf("Abnormal time computed over %d valid samples is %.3f\n\n",N,t_ab);
    bootstrap(results);
end



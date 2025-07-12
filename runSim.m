function runSim(INfilename,OUTfilename)
    addpath('Simulator-final');
    
    %load('generated_samples1.mat','samples');
    load(INfilename);
    N = size(samples, 2);
    
    lambda_exp = 1/6;
    
    e_tot = cell(1, N); 
    te_tot = cell(1, N); 
    h=waitbar(0,"Elaborating...");
    for i = 1:N
        t = exprnd(1/lambda_exp);
        waitbar(i/N,h,sprintf("Processing sample %i/%i",i,N));
        try
            [t, x, d, te, z, e, p] = NetworkSimRun(t, samples(:, i));
            e_tot{i} = e;
            te_tot{i} = te;
        catch ME
            fprintf('Error during sample %d: %s\n', i, ME.message);
        end
    end
    close(h);
    nonEmptyIdx = ~cellfun('isempty', e_tot); 
    e_tot = e_tot(nonEmptyIdx);  
    te_tot = te_tot(nonEmptyIdx);  

    %save('simulated_data.mat', 'e_tot', 'te_tot');
    save(OUTfilename,'e_tot',"te_tot");
end

function MCMCgenerator(filename,n_samples)

% load and check

load('DataSet.mat','f_new'); 
load("DataSet100-11.mat",'Dat');
if ~exist('f_new', 'var') || ~isequal(size(f_new), [6, 6, 6])
    error('Missing variable');
end

min_X2 = min(Dat(1,:)); max_X2 = max(Dat(1,:)); delta_X2 = max_X2 - min_X2;
min_Ps = min(Dat(2,:)); max_Ps = max(Dat(2,:)); delta_Ps = max_Ps - min_Ps;
min_Tm = min(Dat(3,:)); max_Tm = max(Dat(3,:)); delta_Tm = max_Tm - min_Tm;

%n_samples = 1500;                  % number of generated samples
x_curr = [3, 3, 3];                 % starting point
samples = zeros(3, n_samples);      % generated samples
sigma = 0.5;                          % proposal SD
burn_in=n_samples/2;                  % burn in period
thinning=n_samples/50;

h=waitbar(0,"Elaborating...");
for i=1:burn_in
    waitbar(i/burn_in,h,"Burn in period...");
    x_curr=MarkovStep(x_curr,f_new,sigma);
end

for t=1:n_samples
    waitbar(t/n_samples,h,sprintf("Processing sample %i/%i",t,n_samples));
    for i=1:thinning
        x_curr=MarkovStep(x_curr,f_new,sigma);
    end
    x_curr=MarkovStep(x_curr,f_new,sigma);
    % normalizing values
    X2_cont = ((x_curr(1) - 1) / (6 - 1)) * delta_X2 + min_X2; % Maps 1-6 -> min-max X2
    Ps_cont = ((x_curr(2) - 1) / (6 - 1)) * delta_Ps + min_Ps; % Maps 1-6 -> min-max Ps
    Tm_cont = ((x_curr(3) - 1) / (6 - 1)) * delta_Tm + min_Tm; % Maps 1-6 -> min-max Tm

    % saves sample
    samples(:,t)=[X2_cont,Ps_cont,Tm_cont];
end

close(h);

% tests
flag=0;

% autocorrelation test
N = size(samples, 2);
confidence_interval = 0.1; % higher threshold due to low number of samples
fprintf('Autocorrelation Test\t(Confidence Interval: ±%.2f)\n', confidence_interval);
for i = 1:3
    [acf, ~] = autocorr(samples(i, :), 'NumLags', N-1);
    max_autocorr = max(abs(acf(2:end)));
    if max_autocorr > confidence_interval
        fprintf('Dimension %d: NOT PASSED\t\tMax value= %.3f\n', i, max_autocorr);
        flag=flag+1;
    else
        fprintf('Dimension %d: ok\t\t\t\tMax value = %.3f\n', i, max_autocorr);
    end
end

%{
subplot(3, 1, 1);
autocorr(samples(1, :));  
title('Autocorrelation on X2 axis');

% Dimensione Y
subplot(3, 1, 2);
autocorr(samples(2, :));  % Autocorrelazione della seconda dimensione (Y)
title('Autocorrelation on Ps axis');

% Dimensione Z
subplot(3, 1, 3);
autocorr(samples(3, :));  % Autocorrelazione della terza dimensione (Z)
title('Autocorrelation on Tm axis');
%}
fprintf("\n");

% cross correlation
f_gen=points_to_grid(samples);
f_gen_norm=f_gen/sum(f_gen(:));
f_new_norm=f_new/sum(f_new(:));

cross_corr = convn(f_gen_norm, flip(flip(flip(f_new_norm, 1), 2), 3), 'same');
[max_corr, idx] = max(cross_corr(:));

[i, j, k] = ind2sub(size(cross_corr), idx);

disp(['Max cross correlation: ', num2str(max_corr)]);
disp(['Corresponding shift: (', num2str(i), ', ', num2str(j), ', ', num2str(k), ')']);

fprintf("\n");


if(flag~=0)
    disp("---WARNING: samples did not pass all tests---");
    disp('');
end

% graphs

    figure;
    subplot(2,2,2);
    scatter3(samples(1, :), samples(2, :), samples(3, :), '.', 'MarkerEdgeAlpha', 0.5);
    title('Generated samples');
    xlabel('X2');
    ylabel('Ps');
    zlabel('Tm');
    grid on;
    
    
    subplot(2,2,1);
    scatter3(Dat(1, :),Dat(2, :),Dat(3, :), '.', 'MarkerEdgeAlpha', 0.5);
    title('Original samples');
    xlabel('X2');
    ylabel('Ps');
    zlabel('Tm');
    grid on;
    
    [x1,x2,x3]=ndgrid(1:6, 1:6, 1:6);
    
    subplot(2,2,4);
    s=scatter3(x1(:),x2(:),x3(:),100,'filled','MarkerEdgeAlpha',1);
    s.MarkerFaceAlpha = 'flat';  
    s.AlphaData = f_gen(:); 
    xlabel('X2');
    ylabel('Ps');
    zlabel('Tm');
    title('generated distribution');
    grid on;
    
    subplot(2,2,3);
    s=scatter3(x1(:),x2(:),x3(:),100,'filled','MarkerEdgeAlpha',1);
    s.MarkerFaceAlpha = 'flat';  
    s.AlphaData = f_new(:); 
    xlabel('X2');
    ylabel('Ps');
    zlabel('Tm');
    title('original distribution');
    grid on;

%filename=strcat('generated_samples',string(n_samples),'.mat');
fprintf("Saving generated samples in %s\n",filename);
save(filename,"samples");

end



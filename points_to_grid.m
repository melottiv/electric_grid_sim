function grid_counts = points_to_grid(points)

    if size(points, 1) ~= 3
        error('L''array dei punti deve avere 3 righe (una per ogni dimensione).');
    end
    
    num_bins = 6;
    
    min_vals = min(points, [], 2); 
    max_vals = max(points, [], 2); 
    
    edges = cell(1, 3); 
    for dim = 1:3
        edges{dim} = linspace(min_vals(dim), max_vals(dim), num_bins + 1); % Bordi inclusivi
    end
    
    grid_counts = zeros(num_bins, num_bins, num_bins);
    
    [~, x_bins] = histc(points(1, :), edges{1});
    [~, y_bins] = histc(points(2, :), edges{2});
    [~, z_bins] = histc(points(3, :), edges{3});
    
    valid_points = (x_bins > 0 & x_bins <= num_bins) & ...
                   (y_bins > 0 & y_bins <= num_bins) & ...
                   (z_bins > 0 & z_bins <= num_bins);
    x_bins = x_bins(valid_points);
    y_bins = y_bins(valid_points);
    z_bins = z_bins(valid_points);
    
    for i = 1:length(x_bins)
        grid_counts(x_bins(i), y_bins(i), z_bins(i)) = ...
            grid_counts(x_bins(i), y_bins(i), z_bins(i)) + 1;
    end
end

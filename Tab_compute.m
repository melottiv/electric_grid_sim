
function Tab=Tab_compute(e,te)
    N=size(e);
    Tab=0;
    abnormalV=V_ab(e.');
    abnormalQ=Q_ab(e.');
    
    abnormal=abnormalQ|abnormalV;
    abnormal_indices = find(abnormal == 1);
    
    if isempty(abnormal_indices)
        return;
    end
    
    start_idx = abnormal_indices(1); 
    for i = 2:length(abnormal_indices)
        if abnormal_indices(i) ~= abnormal_indices(i-1) + 1
            end_idx = abnormal_indices(i);
            Tab = Tab + (te(end_idx) - te(start_idx));

            start_idx = abnormal_indices(i);
        end
    end
    
    end_idx = abnormal_indices(end);
    Tab = Tab + (te(end_idx) - te(start_idx));
end

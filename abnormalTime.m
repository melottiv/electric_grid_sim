function T=abnormalTime(e,te)
    T = 0;
    start = NaN; 
    abnormalV=V_ab(e.');
    abnormalQ=Q_ab(e.');
    
    abnormal=abnormalQ|abnormalV;

    for i = 1:length(abnormal)
        if abnormal(i) == 1 && isnan(start)
            start = te(i);
        elseif abnormal(i) == 0 && ~isnan(start)
            T = T + (te(i) - start);
            start = NaN; 
        end
    end

    if ~isnan(start)
        T = T + (te(end) - start);
    end
end
function [stateSequence, timeSpent] = getStateSequenceAndTimes(e, te)

    state = '3V0';
    stateSequence = strings(1, length(e)); 
    timeSpent = zeros(1, length(e)); 
    lastTimestamp = te(1); 
    currentIndex = 1; 
    
    for i = 1:length(e)

        switch e{i}
            case 'vn'
                state = '3V0';
            case 'vm'
                state = '3VL';
            case 'vp'
                state = '3VH';
            case 'tm'
                if strcmp(state, '3VL')
                    state = '2';
                elseif strcmp(state, '2')
                    state = '1';
                end
            case 'tp'
                if strcmp(state, '3VH')
                    state = '4';
                elseif strcmp(state, '4')
                    state = '5';
                end
        end
        
        if i > 1 && ~strcmp(state, stateSequence(currentIndex))
            timeSpent(currentIndex) = te(i) - lastTimestamp;
            currentIndex = currentIndex + 1;
            lastTimestamp = te(i);
        end
        
        stateSequence(currentIndex) = state;
    end
    
    timeSpent(currentIndex) = te(end) - lastTimestamp;
    
    stateSequence = stateSequence(1:currentIndex);
    timeSpent = timeSpent(1:currentIndex);

end

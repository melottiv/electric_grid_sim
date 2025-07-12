function calculateTransitionProbabilities(filename)
    load(filename);
    %load("simulated_data.mat");

    n=size(e_tot,2);
    s_tot=cell(1,n);
    t_tot=cell(1,n);
    for i=1:n
        [s,t]=getStateSequenceAndTimes(e_tot{i},te_tot{i});
        s_tot{i}=s;
        t_tot{i}=t;
    end
    
    N = length(s_tot);
   
    uniqueStates={'3V0','3VL','3VH','1','2','4','5'};
    nStates = 7;  
    total_time=zeros(7,1);
    visits=zeros(7,1);
    
    stateIdx = containers.Map(uniqueStates, 1:nStates);
    
    transitionCounts = zeros(nStates, nStates);
    
    for i = 1:N
        sequence = s_tot{i};  
        time=t_tot{i};
        for j = 1:length(sequence)-1
            fromState = sequence{j};  
            toState = sequence{j+1};  
            
            fromIdx = stateIdx(fromState);
            toIdx = stateIdx(toState);
            
            transitionCounts(fromIdx, toIdx) = transitionCounts(fromIdx, toIdx) + 1;
            total_time(fromIdx)=total_time(fromIdx)+time(j);
            visits(fromIdx)=visits(fromIdx)+1;
        end
            j=length(sequence);
            finalState=sequence{j};
            finalIdx=stateIdx(finalState);
            total_time(finalIdx)=total_time(finalIdx)+time(j);
            visits(finalIdx)=visits(finalIdx)+1;
    end
    avg_time=total_time./visits;
    avg_time(isnan(avg_time)) = 0;
    transitionProbabilities = transitionCounts ./ sum(transitionCounts, 2);
    transitionProbabilities(isnan(transitionProbabilities)) = 0;
    
    fprintf("\n");
    disp('Transition probability matrix:');
    fprintf("\t");
    for j=1:nStates
            fprintf("%s\t\t",uniqueStates{j});
    end
    fprintf("\n____|_____________________________________________________\n");
    for i=1:nStates
        fprintf("%s\t|",uniqueStates{i});
        for j=1:nStates
            fprintf("%.3f\t",transitionProbabilities(i,j));
        end
        fprintf("\n");
    end
    fprintf("\n");
    disp("Average time in each state:")
    for i=1:nStates
        fprintf("%s\t\t%d\n",uniqueStates{i},avg_time(i));
    end
    save("prob_time.mat",'transitionProbabilities','avg_time');
end

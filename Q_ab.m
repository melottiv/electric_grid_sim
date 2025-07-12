function ab_Q=Q_ab(e)
    N=length(e);
    ab_Q=zeros(N,1);
    state='q0';     % states q0, ql, qh
    for i=1:N
        switch(e{i})
            case'qp'
                state='qh';
            case'qm'
                state='ql';
            case'qn'
                state='q0';
        end
    
        if(strcmp(state,'qh')|strcmp(state,'ql'))
            ab_Q(i)=1;
        end
    end
end

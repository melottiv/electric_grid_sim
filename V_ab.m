function ab_V=V_ab(e)
    N=length(e);
    ab_V=zeros(N,1);
    state='v0';     % states v0, vl, vh
    for i=1:N
        switch e{i}
            case 'vp'
                state = 'vh';
            case 'vm'
                state = 'vl';
            case 'vn'
                state = 'v0';
        end
    
        if(strcmp(state,'vh')|strcmp(state,'vl'))
            ab_V(i)=1;
        end
    end
end

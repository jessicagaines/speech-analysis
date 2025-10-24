function annotate_pval(pval,rho,siglevel,loc,type)
    if strcmp(type,'Spearman')
        symbol = '\rho';
    elseif strcmp(type,'Pearson')
        symbol = 'r';
    elseif strcmp(type,'ICC')
        symbol = 'ICC r';
    else
        symbol = '';
    end    
    if pval < siglevel
        text(loc(1),loc(2),strcat(symbol,"^{2} = ", num2str(round(rho^2,2))))
        text(loc(1)-10,loc(2),'*','FontSize',20)
    else
        text(loc(1),loc(2),strcat(symbol,"^{2} = ", num2str(round(rho^2,2))," (n.s.)"))
    end
end
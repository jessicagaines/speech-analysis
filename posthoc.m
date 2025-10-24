function posthoc(tbl,var1,var2,model,subplot_title,y_lim,x_label,savepath)
    labels1 = unique(var1,'stable');
    labels2 = unique(var2,'stable');
    
    fig = figure('Position',[100,50,350*length(labels1),400]);
    
    tiledlayout(1,length(labels1))

    for i=1:length(labels1)
        current_cat = labels1(i);
        idx = find(var1 == current_cat);
        posthoc_tbl = tbl(idx,:);
        fprintf("Posthoc = " + current_cat + "\n")
        posthoc_lme = fitlme(posthoc_tbl,model,"DummyVarCoding","reference")
        p = coefTest(posthoc_lme)

        nexttile;
        hold on;
        title(subplot_title + current_cat)
        betas = posthoc_lme.Coefficients.Estimate;
        std_errs = posthoc_lme.Coefficients.SE;
        std_devs = std_errs * sqrt(height(posthoc_tbl));
        variances = std_devs.^2;
        intercept_variance = variances(1);
        combined_variances = vertcat(intercept_variance, variances(2:end) + intercept_variance);
        combined_std_devs = sqrt(combined_variances);
        combined_std_errs = combined_std_devs ./ sqrt(height(posthoc_tbl));
        intercept = betas(1);
        total_betas = vertcat(intercept, betas(2:end)+intercept);
        bar(labels2,total_betas)
        errorbar(1:length(labels2),total_betas,combined_std_errs,LineStyle="none",color='k')
        for j=1:length(labels2)
            if posthoc_lme.Coefficients.pValue(j) < 0.05
                text(j-0.1,max(10,total_betas(j) + 10),'*',FontSize=20,color='k')
            end
        end
        ylim(y_lim)
        xlabel(x_label)
        ylabel("Fixed Effects Coefficient (cents)")

    end

    saveas(fig,savepath,'fig');
    saveas(fig,savepath,'epsc');

end
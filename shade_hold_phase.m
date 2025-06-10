function shade_hold_phase(cond_values, min, max)
    for i = 2:2:length(cond_values)-1
        val1 = cond_values(i)+0.5;
        val2 = cond_values(i+1)+0.5;
        color = 0.9;
        area([val1 val2],[max max],'FaceColor',[color color color],'EdgeColor',[color color color])
        area([val1 val2],[min min],'FaceColor',[color color color],'EdgeColor',[color color color])
    end
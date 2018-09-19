function plotMyFigures(entropy_50_time,entropy_100_time,subj)
    global length_x
    global M
    global continuousUniformEntropy
    
    
    figure(subj),   
    for TIME = 1:length_x
       
        ent_50 = entropy_50_time{subj,TIME};
        ent_100 = entropy_100_time{subj,TIME};      
        subplot(3,4,TIME),
        plot(ent_50,'--ks','LineWidth',0.5,'MarkerFaceColor','g','MarkerSize',4),
        hold on , 
        plot(ent_100,'--rs','LineWidth',0.5,'MarkerFaceColor','g','MarkerSize',4)
        hold on ,
        plot(ones(1,M).*continuousUniformEntropy,'LineWidth',3)
        xlim([0 14]);
    end
    
end

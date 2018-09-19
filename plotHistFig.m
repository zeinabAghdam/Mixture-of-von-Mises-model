function [] = plotHistFig(jointDist,Xrad)

    %figure, 
    plot(linspace(-pi,pi,100), jointDist,'r','LineWidth',2)
    hold on , 
    histnorm(Xrad,50)
    %histnorm(Xrad,50,'EdgeAlpha',0.05);
    
end

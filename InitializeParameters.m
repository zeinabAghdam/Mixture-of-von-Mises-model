function [mu, conc, alpha]  = InitializeParameters(k,Xrad)
    
    % k, number of models in the mixture. 
    clear mu;
    clear conc;
    clear alpha;
    
    murad = mean(Xrad) * rand(k, 1);
    mu(:,1) = cos(murad);
    mu(:,2) = sin(murad);    
    conc = ones(1, k);
    
    % In case of only two mixture models k = 2, we use 0.5* ones(1,k)
    alpha = rand * ones(1,k);

end

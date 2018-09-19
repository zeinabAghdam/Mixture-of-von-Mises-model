% The vonMises Fisher distribution for a 1 dimensional case. 

function pdfval = getpdf_VMf(mu,kappa,data)
    
    % Limit kappa for numerical safety
  %  kappa = min(kappa, 700);
    
    
    coeff = 1 / ((2*pi)* besseli(0,kappa));
    pdfval = coeff * exp(kappa*(mu'*data));
%     
% dim = 2;
% 
%       logNormalize  =  (dim/2-1)*log(kappa) - (dim/2)*log(2*pi) - logbesseli(dim/2-1,kappa);
%       pdfval = logNormalize + exp(kappa*mu*data);

% pdfval = kappa* cos(data-mu) - log(2*pi) - log(besseli(0,kappa));

end

% Input : Set Xrad of data points
% Output A soft clustering of X over a mixture of M-vMF distributions.
% Input data points are interpreted as radients
% In the case that k=2, we have a vonMises distribution.
% 
% mu, conc, alpha are vectors of mu = [mu1, mu2]; conc=[conc1, conc2];
% alpha = [alpha1, alpha2];
Initialization();
global M
global startItem
global endItem
global iniTime
global timeStep
global endTime
global timeIndex
global ItemIndex
global R
global jointDist
defaultM = M;

% !!!!!!!! Load your data Xrad ( in Rad )
 X = convertRadiantsToVectors(Xrad);
        
% Initialize randomly the r.vs.
% First initializations of the mu, kappa, and functions
% likelihood.
M = defaultM;
[vMu,vKappa,vAlpha] = InitializeParameters(M, Xrad);
[vMu,vKappa,vAlpha, assignments] = fitMixtureOfMVonMisesFisher(M, X, vMu, vKappa, vAlpha);

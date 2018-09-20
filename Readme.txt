The codes are implementation of "Clustering on the Unit Hypersphere using
von Mises-Fisher Distributions" by Arindam Banerjee et al.


1 - convert radians into vectors on the two dimensional sphere 
    X(:,1) = cos(Xrad);
     X(:,2) = sin(Xrad);
2 - Set the initialization parameters [InitializeParameters]
3 - Compute the cluster likelihoods 
4 - Applying the EM 
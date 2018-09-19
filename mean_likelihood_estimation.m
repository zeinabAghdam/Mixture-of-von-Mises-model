function marginalLK = mean_likelihood_estimation(h,cluster_likelihood,X)
    marginalLK = cluster_likelihood(:,h)' * X;

end

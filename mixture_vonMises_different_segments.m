% Estimate a mixture of von Mises distribution over different segments
% Input : Set Xrad of data points
% Output A soft clustering of X over a mixture of 2-vMF distributions.
% Input data points are interpreted as radients
% The case that k=2 is a special case of a von Mises distribution.
% 
% mu, conc, alpha are vectors of mu = [mu1, mu2]; conc=[conc1, conc2];
% alpha = [alpha1, alpha2];

clear all 
close all
clc
global Xrad
global time
global segments_offset
global start_segment
global end_segment
global M
global k
global continuousUniformEntropy


iteration_size = 500;
time_index = 1;

vMean_info = cell(10,length(50:2:100));
vConc_info = cell(10,length(50:2:100));
vMean_rad_info = cell(10,length(50:2:100));
vDistEntrop = cell(10, length(50:2:100));


for subj = 1:10
    
	load(strcat('D:\HTW\phase_data\DataNumbered\', num2str(subj),'.mat'));
    time_index = 1;
    clear cluster_likelihood
    clear likelihood_data
    
    for time = 50:2:100
        
        initialize();
        clear cluster_likelihood
        clear likelihood_data
        clear jointDist
        clear mu
        clear murad
        clear kappa
        clear X

        muRad = zeros(M,1);
        muSubjects = zeros(M,2);
        concSubjects= zeros(M,2);

        start_segmenst =1;
        end_segment = segments_size;
        
        % Convert radients into vectors on the two-dimensional unit sphere
        % Xrad = ipsi2_phase(:,time); 
        Xrad = ipsi1_phase(:,time); 
        X(:,1) = cos(Xrad);
        X(:,2) = sin(Xrad);
        
        for segments =1:M

                X_rad = Xrad(start_segments:end_segments);
                X(:,1) = cos(X_rad);
                X(:,2) = sin(X_rad);

                [mu,kappa,alpha] = InitializeParameters(k,X_rad);
                [m,n]= size(X); % Data to be in column-wise manner.

                epsilon = 0.001;
                diff = 1;

                for iteration = 1:iteration_size
                    for i =1:m
                        for h=1:k
                            likelihood_data(i,h)= getpdf_VMf(mu(h,:)', kappa(h), X(i,:)');
                        end

                        for h=1:k
                          % cluster_likelihood(i,h) = log(alpha(h)) + likelihood_data(i,h) - log(sum(likelihood_data(i,:)));
                           cluster_likelihood(i,h) = alpha(h)* likelihood_data(i,h)/sum(alpha .* likelihood_data(i,:));
                        end  
                    end

                    % The M (Maximization Step) of EM
                    for h=1:k
                        alpha(1,h) =  (1/m) * sum(cluster_likelihood(:,h));
                        mu(h,:) = mean_likelihood_estimation(h,cluster_likelihood,X);
                        rbar = norm(mu(h,:)) / (alpha(1,h)*m);
                        mu(h,:) = mu(h,:) ./ norm(mu(h,:));
                        kappa(1,h) = (rbar*2 - rbar^3)/(1-rbar^2);
                        %kappa(1,h) = 2*rbar*(1+ (0.5* rbar^2) +  (0.4167* rbar^4));
                    end
                end



            % Reconstruct the mean and kappa (- Added shift)
            murad = atan2(mu(:,2), mu(:,1))';
            murad = pi + murad;

            muSubjects(segments,:) = mu;
            concSubjects(segments,:) = kappa;
            muRad(segments) = murad;

            % Reconstruct the joint Distribution:: 
            % (alpha_1 * vM_pdf_1 + alpha_2 * vM_pdf_2 + ... [Depending on the
            % number of clusters.]  
            jointDist = zeros(100, 1);
            for h=1:k
                jointDist = jointDist + alpha(1,h)*circ_vmpdf([],murad(1,h),kappa(1,h));
            end

            % Compute the entropy of data
            distEntrop(segments) = entrop(normalise(jointDist)) * continuousUniformEntropy;
            
            start_segment = start_segment + segments_offset;
            end_segment = end_segment + segments_offset; 
            
        end
        
        
        % Save the information over different subjects and times:
        vMean_info{subj,time_index} = muSubjects;
        vConc_info{subj,time_index} = concSubjects;
        vMean_rad_info{subj,time_index} = muRad;
        vDistEntrop{subj,time_index} = distEntrop(:);
        
        time_index  = time_index + 1;
    
        
    end
end






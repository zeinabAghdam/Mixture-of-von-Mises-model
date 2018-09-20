function theta_ = generateSyntheticVonMises(mu_hat, kappa_hat,m)
% Method-1
% We perform rejection sampling to generate m samples from the von
% Mises Fisher distribution specified through mu_hat and kappa_hat.
% The density function is given by f:
f = inline('1/(2*pi * besseli(0, kappa)) * exp(kappa * cos(x-mu))', 'mu', 'kappa', 'x');
% c is the maximum value the density function can reach
c = f(mu_hat, kappa_hat, mu_hat);
% theta_ is where we store the results
theta_ = zeros(1,m);

% Draw m samples
for i=1:m
    % We try 500 times to draw a valid sample.
    % If we do not succeed after that, we just skip this sample (but that
    % should almost never happen)
    for t=1:500
        % Uniformly sample a point u_1 between -pi and pi
        u_1 = rand * 2 * pi - pi;
        % Uniformly sample a test value u_2 between 0 and c.
        u_2 = rand * c;

        % If u_2 is smaller than the value of f at point u_1, we keep the
        % sample (the probability that this happens is proportional to the
        % values of f).
        % Otherwise, we take another sample and try again.
        if (u_2 < circ_vmpdf(u_1, mu_hat, kappa_hat))
        %if (u_2 < f(mu_hat, kappa_hat, u_1))
            theta_(i) = u_1;
            break;
        end
    end
end


%hist(theta_,20);

%% Method-2

% tau_f1 = inline('1+ sqrt(1+(4*kappa^2))', 'kappa');
% p_f2   = inline('(tau-sqrt(2*tau))/(2*kappa)', 'tau', 'kappa');
% theta_ = zeros(1,m);
% 
% tau = tau_f1(kappa_hat);
% p_  = p_f2(tau,kappa_hat);
% 
%     for i=1:m
%         for tr=1:1000
%             u_1 = rand;
%             u_2 = rand;
%             u_3 = rand;
% 
%             r = (1+p_^2)/(2*p_);       
%             z = cos(pi*u_1);
%             f = (1+(r*z))/(r+z);
%             c = kappa_hat*(r-f);
% 
%             if  (c*(2-c)-u_2 >0) || (log(c/u_2)+1-c >=0)
%                 theta_(i) = sign((u_3 -0.5)) * acos(f);
%                 break;
%             end
%         end
%     end
% end

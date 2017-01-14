function [outlier,likelihood] = calculate_association_hough(particles,pic,pos_stD,centers,lambda_psi, target_rgb, use_color)
image_height = size(pic, 1);
image_width = size(pic, 2);

%number of particles 
N = size(particles,2);


k_color = 0.2;
likelihood = zeros(1,N);
pic = permute(pic,[3 1 2]);

A = 1/sqrt(2 * pi) * pos_stD;
B =  - 0.5 / (pos_stD.^2);

particles = round(particles);
if (size(centers,1)==0)
    disp('no circles found')
     for k = 1:N
        m = particles(1,k);
        n = particles(2,k);
    
        I = (m >= 1 & m <= image_height);
        J = (n >= 1 & n <= image_width);
        if I && J
            C = double(pic(:,m, n));
            H = C - target_rgb;
            H2 = H' * H;
            likelihood(k) = A*exp(H2*B);
            
            if ~use_color
                % Spread the likelihood equally.
                try
                likelihood = 1/N*ones(N);
                outlier = ones(1,N);
                return;
                end
            end
            
            outlier = ones(1,N);
        end
     end
     return 
end


for k = 1:N
    
    m = particles(1,k);
    n = particles(2,k);
    
    I = (m >= 1 & m <= image_height);
    J = (n >= 1 & n <= image_width);
    
    if I && J
        %calculate likelihood:
        
        
        %By distance
        D = min(pdist2(particles(2:-1:1,k)',centers));
        D2 = D' * D;
        
        %By color
        C = double(pic(:,m, n));
        H = C - target_rgb;
        H2 = H' * H;
        
        %Use both distance and color to calculate the likelihood
        
        if use_color
            combinedInnovation = D2 + k_color*H2;
        else
            combinedInnovation = D2;
        end
        
        likelihood(k) = A*exp(combinedInnovation*B);
    else
        
        likelihood(k) = 0;
    end
outlier = likelihood<=lambda_psi;
end 

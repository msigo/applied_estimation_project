function [outlier,likelihood] = calculate_association(particles,pic,rgb_stD,color, lambda_psi)
image_height = size(pic, 1);
image_width = size(pic, 2);

%number of particles 
N = size(particles,2);

likelihood = zeros(1,N);
pic = permute(pic,[3 1 2]);

A = sqrt(2 * pi) * rgb_stD;
B =  - 0.5 / (rgb_stD.^2);

particles = round(particles);

for k = 1:N
    
    m = particles(1,k);
    n = particles(2,k);
    
    I = (m >= 1 & m <= image_height);
    J = (n >= 1 & n <= image_width);
    
    if I && J
        
        C = double(pic(:,m, n));
        
        D = C - color;
        
        D2 = D' * D;
        
        likelihood(k) = A*exp(D2*B);
    else
        
        likelihood(k) = 0;
    end
outlier = likelihood<=lambda_psi;
end 

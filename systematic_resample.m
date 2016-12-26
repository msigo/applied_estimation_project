function particles_resampled = systematic_resample(particles,likelihood)
    N=size(particles,2);
    
    weight = likelihood / sum(likelihood);
    cdf = cumsum(weight);
    
    particles_resampled = zeros(4,N);
    r0 = (1/N)*rand(1);

    for m = 1:N
        i = find(cdf>=(r0 +(m-1)/N),1);
        particles_resampled(:,m) = particles(:,i); 
    end
end

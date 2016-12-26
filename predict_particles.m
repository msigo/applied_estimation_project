function updated_particles = predict_particles(particles,R,F_update)

    N = size(particles, 2);

    updated_particles = F_update * particles;

    diff=sqrt(diag(R)).*randn(4,N);
    updated_particles = updated_particles + diff;
end 
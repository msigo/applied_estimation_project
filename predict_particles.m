function updated_particles = predict_particles(particles,old_particles,R,F_update, k_motion)

    N = size(particles, 2);

    updated_particles =  k_motion*(particles - old_particles) + F_update*particles;
    
    
    diff=sqrt(diag(R)).*randn(4,N);
    updated_particles = updated_particles + diff;
end 
function updated_particles = predict_particles(particles,old_particles,R,F_update, particle_mean, old_particle_mean,motion_model)
    

    k_motion = 0.2;
    N = size(particles, 2);
    
    
   
    if motion_model
        %motion = k_motion(particle-old_particle); 
        %motion = k_motion*(particle_mean-particles);
        motion = repmat(k_motion*(particle_mean-old_particle_mean),1,N);
    else
        motion = 0;
    end
    
    
    updated_particles =  motion + particles;
   
    diff=sqrt(diag(R)).*randn(4,N);
    updated_particles = updated_particles + diff;
end 
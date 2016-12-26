function particles = initialize_particles(picsize, number_of_particles)
    
    particles(1,:)= picsize(2)*rand(1,number_of_particles);
    particles(2,:)= picsize(1)*rand(1,number_of_particles);
    particles(3:4,:)=2000*rand(2,number_of_particles);

end
function plots = show_particles_and_state_estimated(particles, frame)

particle_mean = median(particles, 2);

figure(1)
image(frame)
title('Showing particles and mean value')

hold on
plot(particles(2,:), particles(1,:), '.');
plot(particle_mean(2,:), particle_mean(1,:), 'h', 'MarkerSize', 16, 'MarkerEdgeColor', 'y', 'MarkerFaceColor', 'y');
hold off


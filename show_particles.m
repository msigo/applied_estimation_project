function show_particles(particles, image_frame)

figure(1)
image(image_frame)
title('Showing Particle cloud')

hold on
plot(particles(2,:), particles(1,:), '.')
hold off

drawnow

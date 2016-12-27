function show_particles(particles, image_frame, centers, radii, hough_on)

figure(1)
image(image_frame)
title('Showing Particle cloud')

hold on
plot(particles(2,:), particles(1,:), '.')

if hough_on
    viscircles(centers,radii);
end

hold off

drawnow

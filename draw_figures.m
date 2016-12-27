function draw_figures(particles,image_frame, centers, radii, hough_on, binary)

figure(1)

subplot(2,2,1)
image(image_frame)
title('Showing Particle cloud')

hold on
plot(particles(2,:), particles(1,:), '.')

if hough_on
    viscircles(centers,radii);
end

hold off

subplot(2,2,2)
image(binary);
title('Binary image')


drawnow

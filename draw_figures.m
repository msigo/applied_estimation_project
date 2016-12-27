function draw_figures(particles,image_frame, centers, radii, hough_on, binary, verbose)

figure(1)

if verbose > 1
    subplot(2,2,1)
end
image(image_frame)
title('Showing Particle cloud')

hold on
plot(particles(2,:), particles(1,:), '.')

if hough_on
    viscircles(centers,radii);
end

hold off

if verbose > 1
    subplot(2,2,2)
    image(binary);
    title('Binary image')
end


drawnow

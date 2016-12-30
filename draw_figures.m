function draw_figures(particles,image_frame, centers, radii, hough_on, binary, verbose, particle_mean)


figure(1)


if verbose > 1
    subplot(2,1,1)
end
hold on
imshow(image_frame)
title('Showing estimated state')

plot(particle_mean(2,:), particle_mean(1,:), 'h', 'MarkerSize', 10, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');

hold off

if verbose > 1
    subplot(2,1,2)
    
    hold on 
    imshow(binary);
    title('Binary image')
    
    if hough_on
    viscircles(centers,radii);
    end
    
    plot(particles(2,:), particles(1,:), '.', 'color', 'b');
    hold off
end


drawnow

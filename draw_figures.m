function frame = draw_figures(particles,image_frame, centers, radii, binary, verbose, particle_mean, record_movie_flag)

frame = 0;

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
    
    plot(particles(2,:), particles(1,:), '.', 'color', 'b');


    viscircles(centers,radii);
    
    hold off
end


if record_movie_flag
    frame = getframe(gcf);
end

drawnow

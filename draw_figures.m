function frame = draw_figures(particles,image_frame, centers, radii, binary, verbose, particle_mean, record_movie_flag)

frame = 0;

figure(1)



numberOfPlots = verbose;



subplot(1,numberOfPlots,1)
hold on
imshow(image_frame)
title('Showing estimated state')

plot(particle_mean(2,:), particle_mean(1,:), 'h', 'MarkerSize', 10, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');

hold off

if verbose > 1
    subplot(1,numberOfPlots,2)
    
    hold on 
    imshow(binary);
    title('Binary image')
    
    plot(particles(2,:), particles(1,:), '.', 'color', 'b');
    viscircles(centers,radii);
    
    
    
    hold off
    
    if verbose > 2
        % Plot zoomed in at estimated state
        subplot(1,numberOfPlots,3)

        hold on 
        imshow(binary);
        title('Binary image around estimated state')

        plot(particles(2,:), particles(1,:), '.', 'color', 'b');
        viscircles(centers,radii);

        set(gca,'XLim',[(particle_mean(2,:) - 100) (particle_mean(2,:) + 100)], 'YLim', [(particle_mean(1,:) - 100) (particle_mean(1,:) + 100)])

        hold off
    end
end






if record_movie_flag
    frame = getframe(gcf);
end

drawnow

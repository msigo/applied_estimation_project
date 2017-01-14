function frame = draw_figures(particles,image_frame, centers, radii, binary, verbose, particle_mean, record_movie_flag)

frame = 0;

figure(1)



numberOfPlots = verbose;






%    subplot(2,2,1)
%    
%    hold on 
%    imshow(binary);
%    title('Binary image')
%    
%    plot(particles(2,:), particles(1,:), '.', 'color', 'b');
%    viscircles(centers,radii);
%    
%    
%    
%    hold off
        % Plot zoomed in at estimated state
        subplot(2,2,[1,2])

        hold on 
        imshow(binary);
        title('Binary image around estimated state')

        plot(particles(2,:), particles(1,:), '.', 'color', 'b');
        viscircles(centers,radii);

        set(gca,'XLim',[(particle_mean(2,:) - 50) (particle_mean(2,:) + 50)], 'YLim', [(particle_mean(1,:) - 50) (particle_mean(1,:) + 50)])

        hold off




subplot(2,2,[3,4])
hold on
imshow(image_frame)
title('Showing estimated state')

plot(particle_mean(2,:), particle_mean(1,:), 'h', 'MarkerSize', 10, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');

hold off


if record_movie_flag
    frame = getframe(gcf);
end

drawnow

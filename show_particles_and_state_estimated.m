function plots = show_particles_and_state_estimated(particles, frame,plots)

particle_mean = median(particles, 2);

figure(1)
image(frame)
title('Showing particles and mean value')

hold on
P1=plot(particles(2,:), particles(1,:), '.');
P2=plot(particle_mean(2,:), particle_mean(1,:), 'h', 'MarkerSize', 32, 'MarkerEdgeColor', 'y', 'MarkerFaceColor', 'y');
hold off

plots = [P1,P2]; % plots
hcb = [0,0]; % checkbox handle (preallocate)
cb_text = {'Particle Cloud  ','Mean value '}; % checkbox text
for i = 1:2
    hcb(i) = uicontrol('Style','checkbox','Value',1,...
                       'Position',[-30+i*40 1 40 15],'String',cb_text{i});
end
set(hcb,'Callback',{@box_value,hcb,plots});

drawnow

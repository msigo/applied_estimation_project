%% Parameters
%test

% 
rng(3);
video_file = 2;
motion_model = 1;

nCircles = 3;

verbose = 2;

switch(video_file) 
    
    case 1
        color_to_track = 'yellow'
        level = 'bright';
        hough_on = 1;
        radii_thresholds = [10,15]; % Counted the radii of a ball to aprox 11 pixels.
        video_file ='Billiard.mov';%'Billiard_black_ball.mov'
        switch(color_to_track)
            case 'black'
                threshold_color = [0; 0; 0];
                sigma_rgb = 20; %rgb tolerance.
            case 'blue'
                threshold_color = [0; 0; 255];
                sigma_rgb = 70; %rgb tolerance.
            case 'yellow'
                threshold_color = [229; 235; 32]; 
                sigma_rgb = 70; %rgb tolerance.
        end

    case 2
        color_to_track = 'white'
        level = 'bright';
        hough_on = 1;
        radii_thresholds = [9,20];%[13,20]; 
        video_file = 'billiardblack.mp4';
        
        switch(color_to_track)
            case 'yellow'
                threshold_color = [229; 235; 64];
                sigma_rgb = 80;
            case 'red'
                threshold_color = [255; 0; 0];
                sigma_rgb = 80;
            case 'blue'
                threshold_color = [0; 0; 255];
                sigma_rgb = 70;
            case 'white'
                threshold_color = [255; 255; 255];
                sigma_rgb = 70;
        end
        
    case 3
        level = 'bright'
        hough_on = 1;
        radii_thresholds = [30,40]; 
        binary_threshold = 150;
        video_file = 'billiard3.mp4';
        threshold_color = [239; 212; 40];
        sigma_rgb = 70; %rgb tolerance.

        %[229; 235; 64]; %yellow
        %[0,0,160]; %blue
        %Xrgb_trgt = [0,0,0]; %black
    
    case 4
        level = 'bright';
        hough_on = 1;
        radii_thresholds = [30,50]; 
        binary_threshold = 150;
        video_file = 'billiard4.mp4';
        threshold_color = [255;255;255];
        sigma_rgb = 70; %rgb tolerance.
        
    case 5
        level = 'bright';
        hough_on = 1;
        radii_thresholds = [25,40]; 
        binary_threshold = 150;
        video_file = 'billiard2.mp4';
        threshold_color = [255,255,255];
        sigma_rgb = 70; %rgb tolerance.
        %[229; 235; 64]; %yellow
        %[0,0,160]; %blue
        %[0,0,0]; %black
        
end

centers = [0 0];
radii = 0;

F_update = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];%[1 0 1 0; 0 1 0 1; 0 0 1 0; 0 0 0 1];

if motion_model
    k_motion = 0.25;
else
    k_motion = 0;
end

Npop_particles = 1000;

sigma_xy = 45; % process noise in x,y.
sigma_xy_for_hough = 20; %measurement noise
sigma_vec = 5;%process noise in velocity
R= [sigma_xy,0,0,0;0,sigma_xy,0,0;0,0,sigma_vec,0;0,0,0,sigma_vec].^2;




%% Loading 
video = VideoReader(video_file);

Npix_resolution = [video.Width video.Height];
Nfrm_movie = floor(video.Duration * video.FrameRate);

%% Object Tracking by Particle Filter
%initialize particles
X =initialize_particles(Npix_resolution,Npop_particles);
old_particles = X;
particle_mean = mean(X,2);
old_mean = particle_mean;
%for t = 1:Nfrm_movie
%    Y_K_movie(:,:,:,t) = read(video, t);
%end

for k = 20:2:Nfrm_movie
    
    % Getting Image
    Y_k = read(video, k);
    %Y_k = Y_K_movie(:,:,:,k); %If all frames is already read.
    % predict 
    
    X = predict_particles(X,old_particles,R,F_update, particle_mean, old_mean, motion_model);
    
    
    old_mean = particle_mean;
    
    if (hough_on)
        
        Y_k_binary_temp =Y_k(:,:,1)>threshold_color(1) -sigma_rgb & Y_k(:,:,1)< threshold_color(1) +sigma_rgb...
            &Y_k(:,:,2)>threshold_color(2)-sigma_rgb & Y_k(:,:,2)< threshold_color(2)+sigma_rgb...
            &Y_k(:,:,3)>threshold_color(3)-sigma_rgb & Y_k(:,:,3)< threshold_color(3)+sigma_rgb;
        
        Y_k_binary=Y_k_binary_temp;
        
        %find circles
        [centers, radii] = imfindcircles(Y_k_binary,radii_thresholds,'ObjectPolarity',level, ...
        'Sensitivity',0.92);
        % Calculating Log Likelihood
        
        
        if size(centers, 1) > nCircles
            centers = centers(1:nCircles,:);
            radii = radii(1:nCircles);
        end
           
        [outlier,L] =calculate_association_hough(X(1:2,:),Y_k,sigma_xy_for_hough, centers,1e-9,threshold_color);
    else
        % Calculating Log Likelihood
        [outlier,L] = calculate_association(X(1:2,:),Y_k,sigma_rgb, threshold_color,1e-9);

    end
       
    % Resampling
    X = systematic_resample(X,L);
    % Showing Image
    
    particle_mean = mean(X, 2);
    draw_figures(X, Y_k, centers, radii, hough_on, Y_k_binary, verbose, particle_mean); 
    
    %show_state_estimated(X, Y_k);
    %show_particles_and_state_estimated(X, Y_k);

end


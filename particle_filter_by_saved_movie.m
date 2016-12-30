%% Parameters
%test

% 
rng(3);
video_file = 4;
motion_model = 1;

nCircles = 3;

verbose = 2;

switch(video_file) 
    
    case 1
        level = 'bright';
        hough_on = 1;
        radii_thresholds = [10,16]; % Counted the radii of a ball to aprox 11 pixels.
        binary_threshold = 10;
        video_file ='Billiard.mov';%'Billiard_black_ball.mov'

    case 2
        level = 'bright';
        hough_on = 1;
        radii_thresholds = [10,20];%[13,20]; 
        binary_threshold = 88;%74
        video_file = 'billiardblack.mp4';
        
       
        Xrgb_trgt = [229; 235; 64]; % Track yellow
        %Xrgb_trgt = [0,0,160]; % Track blue
        Xrgb_trgt = [0;0;0];
        %[0,0,0]; %black
    case 3
        level = 'bright'
        hough_on = 1;
        radii_thresholds = [30,40]; 
        binary_threshold = 150;
        video_file = 'billiard3.mp4';
        Xrgb_trgt = [239; 212; 40];
        %[229; 235; 64]; %yellow
        %[0,0,160]; %blue
        %Xrgb_trgt = [0,0,0]; %black
    
    case 4
        level = 'bright';
        hough_on = 1;
        radii_thresholds = [30,50]; 
        binary_threshold = 150;
        video_file = 'billiard4.mp4';
        Xrgb_trgt = [255;255;255];
        %[229; 235; 64]; %yellow
        %[0,0,160]; %blue
        %[0,0,0]; %black
        
    case 5
        level = 'bright';
        hough_on = 1;
        radii_thresholds = [25,40]; 
        binary_threshold = 150;
        video_file = 'billiard2.mp4';
        Xrgb_trgt = [255,255,255];
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

Xstd_rgb = 100; %rgb tolerance.
Xstd_pos = 45; % process noise in x,y.
Xstd_pos_for_hough = 20; %measurement noise
Xstd_vec = 5;%process noise in velocity
R= [Xstd_pos,0,0,0;0,Xstd_pos,0,0;0,0,Xstd_vec,0;0,0,0,Xstd_vec].^2;




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
for k = 20:2:Nfrm_movie
    
    % Getting Image
    Y_k = read(video, k);
    % predict 
    
    X = predict_particles(X,old_particles,R,F_update, particle_mean, old_mean, motion_model);
    
    
    old_mean = particle_mean;
    
    if (hough_on)
        
        Y_k_binary_temp =Y_k(:,:,1)>Xrgb_trgt(1) -Xstd_rgb & Y_k(:,:,1)< Xrgb_trgt(1) +Xstd_rgb...
            &Y_k(:,:,2)>Xrgb_trgt(2)-Xstd_rgb & Y_k(:,:,2)< Xrgb_trgt(2)+Xstd_rgb...
            &Y_k(:,:,3)>Xrgb_trgt(3)-Xstd_rgb & Y_k(:,:,3)< Xrgb_trgt(3)+Xstd_rgb;
        
        Y_k_binary=Y_k_binary_temp;
        
        %find circles
        [centers, radii] = imfindcircles(Y_k_binary,radii_thresholds,'ObjectPolarity',level, ...
        'Sensitivity',0.92);
        % Calculating Log Likelihood
        
        
        if size(centers, 1) > nCircles
            centers = centers(1:nCircles,:);
            radii = radii(1:nCircles);
        end
           
        [outlier,L] =calculate_association_hough(X(1:2,:),Y_k,Xstd_pos_for_hough, centers,1e-9,Xrgb_trgt);
    else
        % Calculating Log Likelihood
        [outlier,L] = calculate_association(X(1:2,:),Y_k,Xstd_rgb, Xrgb_trgt,1e-9);

    end
       
    % Resampling
    X = systematic_resample(X,L);
    % Showing Image
    
    particle_mean = mean(X, 2);
    draw_figures(X, Y_k, centers, radii, hough_on, Y_k_binary, verbose, particle_mean); 
    
    %show_state_estimated(X, Y_k);
    %show_particles_and_state_estimated(X, Y_k);

end


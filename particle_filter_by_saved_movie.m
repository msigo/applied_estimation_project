%% Parameters
%test

rng(2);

video_file = 2;
motion_model = 0;

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
    case 3
        level = 'bright'
        hough_on = 1;
        radii_thresholds = [30,40]; 
        binary_threshold = 150;
        video_file = 'billiard3.mp4';
    
    case 4
        level = 'bright' 
        hough_on = 1;
        radii_thresholds = [30,40]; 
        binary_threshold = 150;
        video_file = 'billiard4.mp4';
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

Xstd_rgb = 70; %rgb tolerance.
Xstd_pos = 45; % process noise in x,y.
Xstd_pos_for_hough = 20; %measurement noise
Xstd_vec = 5;%process noise in velocity
R= [Xstd_pos,0,0,0;0,Xstd_pos,0,0;0,0,Xstd_vec,0;0,0,0,Xstd_vec].^2;

Xrgb_trgt = [239; 212; 40];
%[229; 235; 64]; %yellow
%[0,0,160]; %blue
%[0,0,0]; %black


%% Loading 
video = VideoReader(video_file);

Npix_resolution = [video.Width video.Height];
Nfrm_movie = floor(video.Duration * video.FrameRate);

%% Object Tracking by Particle Filter
%initialize particles
X =initialize_particles(Npix_resolution,Npop_particles);
old_particles = X;
for k = 20:2:Nfrm_movie
    
    % Getting Image
    Y_k = read(video, k);
    % predict 
    X = predict_particles(X,old_particles,R,F_update, k_motion);
    old_particles = X;
    
    if (hough_on)
        %find circles
        %Y_k_binary = rgb2gray(Y_k);
        %Y_k_binary = Y_k_binary<binary_threshold;
        Y_k_binary_temp =Y_k(:,:,1)>Xrgb_trgt(1) -Xstd_rgb & Y_k(:,:,1)< Xrgb_trgt(1) +Xstd_rgb...
            &Y_k(:,:,2)>Xrgb_trgt(2)-Xstd_rgb & Y_k(:,:,2)< Xrgb_trgt(2)+Xstd_rgb...
            &Y_k(:,:,3)>Xrgb_trgt(3)-Xstd_rgb & Y_k(:,:,3)< Xrgb_trgt(3)+Xstd_rgb;
        
        Y_k_binary=Y_k_binary_temp;
        
        [centers, radii] = imfindcircles(Y_k_binary,radii_thresholds,'ObjectPolarity',level, ...
        'Sensitivity',0.92);
        % Calculating Log Likelihood
        
        
        [outlier,L] =calculate_association_hough(X(1:2,:),Y_k,Xstd_pos_for_hough, centers,1e-9,Xrgb_trgt);
    else
        % Calculating Log Likelihood
        [outlier,L] = calculate_association(X(1:2,:),Y_k,Xstd_rgb, Xrgb_trgt,1e-9);

    end
       
    % Resampling
    X = systematic_resample(X,L);
    % Showing Image
    
    
    %draw_figures(X, Y_k, centers, radii, hough_on, Y_k_binary, verbose); 
    %show_state_estimated(X, Y_k);
    show_particles_and_state_estimated(X, Y_k);

end


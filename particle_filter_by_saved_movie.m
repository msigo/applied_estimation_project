%% Parameters
%test

video_file = 2;

verbose = 2;

if video_file == 1
    hough_on = 1;
    radii_thresholds = [10,16]; % Counted the radii of a ball to aprox 11 pixels.
    binary_threshold = 10;
    video_file = 'Billiard_black_ball.mov';
else
    hough_on = 1;
    radii_thresholds = [15,20]; 
    binary_threshold = 78;
    video_file = 'billiardblack.mp4';
end
    
    


centers = 0;
radii = 0;

F_update = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];%[1 0 1 0; 0 1 0 1; 0 0 1 0; 0 0 0 1];

Npop_particles = 4000;

Xstd_rgb = 50;
Xstd_pos = 25;%25;
Xstd_pos_for_hough = 5;%25;
Xstd_vec = 5;%5;
R= [Xstd_pos,0,0,0;0,Xstd_pos,0,0;0,0,Xstd_vec,0;0,0,0,Xstd_vec].^2;

Xrgb_trgt = [0; 0; 255];

%% Loading 
video = VideoReader(video_file);

Npix_resolution = [video.Width video.Height];
Nfrm_movie = floor(video.Duration * video.FrameRate);

%% Object Tracking by Particle Filter
%initialize particles
X =initialize_particles(Npix_resolution,Npop_particles);
for k = 20:4:Nfrm_movie
    
    % Getting Image
    Y_k = read(video, k);
    
    % predict 
    X =predict_particles(X,R,F_update);
    
    if (hough_on)
        %find circles
        Y_k_binary = rgb2gray(Y_k);
        Y_k_binary = Y_k_binary<binary_threshold;
        
        [centers, radii] = imfindcircles(Y_k_binary,radii_thresholds,'ObjectPolarity','bright', ...
        'Sensitivity',0.92);
        % Calculating Log Likelihood
        [outlier,L] =calculate_association_hough(X(1:2,:),Y_k,Xstd_pos_for_hough, centers,1e-9);
    else
        % Calculating Log Likelihood
        [outlier,L] = calculate_association(X(1:2,:),Y_k,Xstd_rgb, Xrgb_trgt,1e-9);

    end
       
    % Resampling
    X = systematic_resample(X,L);
    % Showing Image
    
    
    draw_figures(X, Y_k, centers, radii, hough_on, Y_k_binary, verbose); 
    %show_state_estimated(X, Y_k);

end


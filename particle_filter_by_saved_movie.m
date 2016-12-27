%% Parameters
%test

hough_on = 1;
radii_thresholds = [10,16]; % Counted the radii of a ball to aprox 11 pixels.


centers = 0;
radii = 0;

F_update = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];%[1 0 1 0; 0 1 0 1; 0 0 1 0; 0 0 0 1];

Npop_particles = 4000;

Xstd_rgb = 50;
Xstd_pos = 35;%25;
Xstd_vec = 5;%5;
R= [Xstd_pos,0,0,0;0,Xstd_pos,0,0;0,0,Xstd_vec,0;0,0,0,Xstd_vec].^2;

Xrgb_trgt = [0; 0; 255];

%% Loading Movie
video = VideoReader('Billiard.mov');

Npix_resolution = [video.Width video.Height];
Nfrm_movie = floor(video.Duration * video.FrameRate);

%% Object Tracking by Particle Filter
%initialize particles
%X = create_particles(Npix_resolution, Npop_particles);
X =initialize_particles(Npix_resolution,Npop_particles);
for k = 20:2:Nfrm_movie
    
    % Getting Image
    Y_k = read(video, k);

    % predict 
    %X = update_particles(F_update, Xstd_pos, Xstd_vec, X);
    X =predict_particles(X,R,F_update);
    % Calculating Log Likelihood
    %L = calc_log_likelihood(Xstd_rgb, Xrgb_trgt, X(1:2, :), Y_k);
    [outlier,L] =calculate_association(X(1:2,:),Y_k,Xstd_rgb, Xrgb_trgt,1e-9);
   
    % Resampling
    %X = resample_particles(X, L);
    X = systematic_resample(X,L);
    % Showing Image
    
    if hough_on
        [centers, radii] = imfindcircles(Y_k,[10 16],'ObjectPolarity','dark', ...
        'Sensitivity',0.9);
    end
    
    show_particles(X, Y_k, centers, radii, hough_on); 
    %show_state_estimated(X, Y_k);

end


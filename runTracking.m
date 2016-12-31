function M = runTracking(video_file, nParticles, R, sigma_xy_for_hough, threshold_color, sigma_rgb, radii_thresholds, nCircles, motion_model_flag, verbose)
    video = VideoReader(video_file);

    Npix_resolution = [video.Width video.Height];
    Nfrm_movie = floor(video.Duration * video.FrameRate);

    %% Object Tracking by Particle Filter
    %initialize particles
    X =initialize_particles(Npix_resolution,nParticles);
    old_particles = X;
    particle_mean = mean(X,2);
    old_mean = particle_mean;
    
    for t = 1:Nfrm_movie
        Y_K_movie(:,:,:,t) = read(video, t);
    end

    frameCounter = 0;
    for k = 20:Nfrm_movie

        frameCounter = frameCounter + 1;
        % Getting Image
        %Y_k = read(video, k);
        Y_k = Y_K_movie(:,:,:,k); %If all frames is already read.
        % predict 

        X = predict_particles(X,old_particles,R, particle_mean, old_mean, motion_model_flag);


        old_mean = particle_mean;

     

        Y_k_binary_temp =Y_k(:,:,1)>threshold_color(1) -sigma_rgb & Y_k(:,:,1)< threshold_color(1) +sigma_rgb...
                &Y_k(:,:,2)>threshold_color(2)-sigma_rgb & Y_k(:,:,2)< threshold_color(2)+sigma_rgb...
                &Y_k(:,:,3)>threshold_color(3)-sigma_rgb & Y_k(:,:,3)< threshold_color(3)+sigma_rgb;

        Y_k_binary=Y_k_binary_temp;

            %find circles
        [centers, radii] = imfindcircles(Y_k_binary,radii_thresholds,'ObjectPolarity','bright', ...
            'Sensitivity',0.92);
            % Calculating Log Likelihood


        if size(centers, 1) > nCircles
            centers = centers(1:nCircles,:);
            radii = radii(1:nCircles);
        end

        [outlier,L] =calculate_association_hough(X(1:2,:),Y_k,sigma_xy_for_hough, centers,1e-9,threshold_color);
       
        

        % Resampling
        X = systematic_resample(X,L);

        particle_mean = mean(X, 2);
        M(frameCounter)=draw_figures(X, Y_k, centers, radii, Y_k_binary, verbose, particle_mean); 
        %show_state_estimated(X, Y_k);
        %show_particles_and_state_estimated(X, Y_k);

    end

    %figure(2)
    %movie(M);
end




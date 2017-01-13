clear all, close all;

rng(3);
video_file = 3;
motion_model_flag = 1;
use_color_association_flag =1;

nCircles = 3;

verbose = 3;

record_movie_flag = 0;


movieMakeArray = [%{2, 'yellow'}];
                  %{2, 'red'};]
                  %{2, 'blue'}];
                  %{2, 'white'};
                  {3, 'yellow'};]
                  %{3, 'white'};
                  %{4, 'black'};
                  %{4, 'white'}];

                  %{1, 'blue'}]
                 
movieName = 'movie3trackYellow'                  

for i = 1:size(movieMakeArray,1)              
    
    currentConfig = movieMakeArray(i,:);
    
    video = cell2mat(currentConfig(1));
    color_to_track = cell2mat(currentConfig(2));
    
    switch(video)

        case 1
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

            radii_thresholds = [30,40]; 
            binary_threshold = 150;
            video_file = 'billiard3.mp4';
            
            switch(color_to_track)
                case 'yellow'
                     threshold_color = [239; 212; 40];
                     sigma_rgb = 100; %rgb tolerance

                case 'white'
                     threshold_color = [240; 240; 240];
                     sigma_rgb = 100; %rgb tolerance
            end


        case 4
            level = 'bright';
            hough_on = 1;
            radii_thresholds = [30,50]; 
            binary_threshold = 150;
            video_file = 'billiard4.mp4';
            color_to_track = 'black';

            switch(color_to_track)
                case 'black'
                     threshold_color = [0; 0; 0];
                     sigma_rgb = 50; %rgb tolerance

                case 'white'
                     threshold_color = [240; 240; 240];
                     sigma_rgb = 100; %rgb tolerance
            end

        case 5
            level = 'bright';
            hough_on = 1;
            radii_thresholds = [10,15];
            video_file = 'billiard2.mp4';
            color_to_track = 'yellow';

            switch(color_to_track)               
                case 'yellow'
                     threshold_color = [239; 212; 40];
                     sigma_rgb = 100; %rgb tolerance
            end

        case 6
            level = 'bright';
            hough_on = 1;
            radii_thresholds = [8,12];
            video_file = 'billiardblack2.mp4';
            color_to_track = 'white';

            switch(color_to_track)               
                case 'black'
                     threshold_color = [0; 0; 0];
                     sigma_rgb = 30; %rgb tolerance

                case 'white'
                    threshold_color = [250;250;250];
                    sigma_rgb = 50;
            end

    end

    nParticles = 1000;

    sigma_xy = 45; % process noise in x,y.
    sigma_xy_for_hough = 20; %measurement noise
    sigma_vec = 5;%process noise in velocity

    R= [sigma_xy,0,0,0;0,sigma_xy,0,0;0,0,sigma_vec,0;0,0,0,sigma_vec].^2;

    movie = runTracking(video_file, nParticles, R, sigma_xy_for_hough, threshold_color, sigma_rgb, radii_thresholds, nCircles, motion_model_flag, verbose, record_movie_flag, use_color_association_flag);
    
    if record_movie_flag
        v = VideoWriter(sprintf('%s%d.avi',movieName,i),'Motion JPEG AVI');
        open(v);
        writeVideo(v,movie);
        close(v);
    end
   
end


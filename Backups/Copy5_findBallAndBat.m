%% File to detect automatically ball and bat positions
    % Matrix containing x,y coordinates of the ball in every image
    ball_positions = zeros(21,2);  
    % Matrix containing x,y coordinates of the bat in every image
    bat_positions = zeros(21,2);
    
%     image0 = imread('TennisSet1/stennis.1.ppm');
%     figure('Position', [850 400 900 600]);
%     imshow(image0, 'InitialMagnification',250);
%     impixelinfo();

    for imageID = 1:length(ball_positions)
        im = imread(['TennisSet1/stennis.' int2str(imageID),'.ppm']);
        % Converts the coloured RGB image to a grayscale image using proportional
        % scaling with values: 0.2126R + 0.7151G + 0.0721B 
        imGray = weightedSum(im, 0.2126, 0.7151, 0.0721);
        % Converts the matrix back to an image
        imGray = mat2gray(imGray);

         % Applies a noise filter
        noiseIm = medfilt2(imGray);

        % Converts resulting image to binary image using the canny method and 
        % 2 thresholds (lower and upper threshold)
        bin = edge(noiseIm,'canny', [0.1 0.2]);

        %% To isolate the Ball
        % Keeps curved objects only
        shapeIm = bwpropfilt(bin,'eccentricity',[0, 0.8]);
        % Defines Structuring Element
        se = strel('disk',10);
        % Fills in each object so that areas can be calculated
        closingIm = imclose(shapeIm,se);
        % Eliminates very small and very big objects (noise)
        sizeIm = bwareafilt(closingIm,[100, 400]); %150 - 400
        % Keeps the smallest object when there is noise
        uniqueIm = bwareafilt(sizeIm,1,'smallest');

    %     % To show resulting image after last modification
%         figure('Position', [850 400 900 600]);
%         imshow(uniqueIm, 'InitialMagnification',250);
%         impixelinfo();

        %% To identify and locate the ball
        % Using labels to find the upmost pixel of the resulting image as it  
        labelMat = bwlabel(uniqueIm);
        [rows, columns] = size(labelMat);    
        ball_pose_found = 0;
        % read horizontally and look for a non-empty pixel
        while (ball_pose_found == 0)   
            for a = 1:rows
                for b = 1:columns
                    if (labelMat(a,b) ~= 0 && ball_pose_found == 0)
                        ball_positions(imageID,1) = b;
                        ball_positions(imageID,2) = a;
                        ball_pose_found = 1;                
                    end
                end
            end
        end
        
%       fprintf('\n\nX%d ball: %d \n', imageID, ball_positions(imageID,1));
%       fprintf('Y%d ball: %d \n', imageID, ball_positions(imageID,2));



        %% To isolate the Bat
        faverage=ones(4,6)/(3*3);
        noiseIm2 = imfilter(imGray,faverage);

        % Sets intensity thresholds
        low_intensity = 0.8;
        high_intensity = 1;
        % Converts grayscale image to binary using intensity thresholds to
        % separate the bat from the hand
        bin2 = gray2binary(noiseIm2, low_intensity, high_intensity);
        % Converts the matrix of double to logical values (0,1)
        bin2 = logical(bin2);

        % Eliminates table and hand
        shapeIm2 = bwpropfilt(bin2,'eccentricity',[0.97, 0.995]);
        % Eliminates small and large objects (noise)
        sizeIm2 = bwareafilt(shapeIm2,[300, 1000]);
        % Define Structuring Element
        se2 = strel('disk',5);
        % Fills in holes and gaps for better rendering
        closingIm2 = imclose(sizeIm2,se2);

    %     % To show resulting image after last modification
    %     figure;
    %     imshow(closingIm2, 'InitialMagnification',250);
    %     impixelinfo();

        %% To identify and locate the tip of the bat
        % Using labels to find the leftmost pixel of the resulting image
        labelMat2 = bwlabel(closingIm2);
        bat_pose_found = 0;
        % Reads vertically and look for a non-empty pixel
        while (bat_pose_found == 0)   
            for a = 1:columns
                for b = 1:rows
                    if (labelMat2(b, a) ~= 0 && bat_pose_found == 0)
                        bat_positions(imageID,1) = a;
                        bat_positions(imageID,2) = b;
                        bat_pose_found = 1;                
                    end
                end
            end
        end

%       fprintf('\n\nX%d bat: %d \n', imageID, bat_positions(imageID,1));
%       fprintf('Y%d bat: %d \n', imageID, bat_positions(imageID,2));

    end
    
    
    %% Calculate 2D-velocities and speeds (in pixels per frame)

   ballSpeeds = zeros(21,1);
   batSpeeds = zeros(21,1);
   
   xBallVelocity = zeros(21,1);
   yBallVelocity = zeros(21,1);
   xBatVelocity = zeros(21,1);
   yBatVelocity = zeros(21,1);
   
   for i = 1:length(ball_positions)-1
       ballSpeeds(i+1) = (sqrt((ball_positions(i+1,1) - ball_positions(i,1))^2 ... 
                    + (ball_positions(i+1,2) - ball_positions(i,2))^2)) * ...
                    0.24 * 25;
       batSpeeds(i+1) = (sqrt((bat_positions(i+1,1) - bat_positions(i,1))^2 ... 
                    + (bat_positions(i+1,2) - bat_positions(i,2))^2)) * ...
                    0.24 * 25;
                
       xBallVelocity(i+1) = ball_positions(i+1,1) - ball_positions(i,1);
       yBallVelocity(i+1) = (ball_positions(i+1,2) - ball_positions(i,2));

       xBatVelocity(i+1) = bat_positions(i+1,1) - bat_positions(i,1);
       yBatVelocity(i+1) = bat_positions(i+1,2) - bat_positions(i,2);

   end

   for i = 1:length(ball_positions)
       fprintf('\n\nIn position %d ball speed is: %.2f \n', i, ballSpeeds(i));
       fprintf('In position %d bat speed is: %.2f \n', i,batSpeeds(i));

%        fprintf('\n\nIn position %d for the ball,  X velocity is: %d \n', i,xBallVelocity(i));
%        fprintf('In position %d for the ball,  Y velocity is: %d \n', i,yBallVelocity(i));
%        fprintf('In position %d for the bat,  X velocity is: %d \n', i,xBatVelocity(i));
%        fprintf('In position %d for the bat,  Y velocity is: %d \n', i,yBatVelocity(i));

   end
   
   
   
   
    %% Plot 2D-velocities (in pixels per frame)
%         frames = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21];
%         hold on;
        % Ball
%         s1 = scatter(frames,xBallVelocity,'filled');
%         s1.MarkerEdgeColor = 'm';
        % s1.MarkerEdgeColor = 'g';
%         s1 = scatter(frames,-yBallVelocity,'filled');
%         s1.MarkerEdgeColor = 'b';
        % s1.MarkerEdgeColor = 'm';
        
        % Bat
%         s1 = scatter(frames,xBatVelocity,'filled');
%         s1.MarkerEdgeColor = 'g';
%         s1 = scatter(frames,-yBatVelocity,'filled');
%         s1.MarkerEdgeColor = 'r';


        % Pick your axes HERE             <------ 2
%         title('Bat Velocity');
%         title('Ball Velocity');
%         xlabel('Frame ID (time)') ;   
%         ylabel('Vx (nb of pixels/frame)') ;
%         ylabel('Vy (nb of pixels/frame)') ;

        % Choose your Xmin & Xmax HERE    <------ 3
%         xMin = 0;
%         xMax = 25;
%         xMin = 0;
%         xMax = 25;
%         xlim([xMin xMax]);
%         yMin = -15;
%         yMax = 15;         
%         yMin = -5;
%         yMax = 5; 
%         ylim([yMin yMax]);


%         for i = 1:length(frames)-1
%             x1 = frames(i);
%             y1 = -yBallVelocity(i);
%             x2 = frames(i+1);
%             y2 = -yBallVelocity(i+1);
%             x1 = frames(i);
%             y1 = (xBallVelocity(i));
%             x2 = frames(i+1);
%             y2 = (xBallVelocity(i+1));

%             x1 = frames(i);
%             y1 = (xBatVelocity(i));
%             x2 = frames(i+1);
%             y2 = (xBatVelocity(i+1));
%             x1 = frames(i);
%             y1 = -yBatVelocity(i);
%             x2 = frames(i+1);
%             y2 = -yBatVelocity(i+1);
        %     plot([x1,x2], [y1, y2], 'b-', 'LineWidth', 2);
%             plot([x1,x2], [y1, y2], 'm-', 'LineWidth', 2);
%             plot([x1,x2], [y1, y2], 'g-', 'LineWidth', 2);
%             plot([x1,x2], [y1, y2], 'r-', 'LineWidth', 2);
%             set(gca,'FontSize',20)
%         end

 
 %% Plot 3D-Speeds (in cm per second)
%         frames = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21];
%         hold on;
% %         s1 = scatter(frames,ballSpeeds,'filled');
% %         s1.MarkerEdgeColor = 'r';
%         s1 = scatter(frames,batSpeeds,'filled');
%         s1.MarkerEdgeColor = 'g';
%         
% 
% 
%         % Pick your axes HERE             <------ 2
%         title('Bat Speed');
% %         title('Ball Speed');
%         xlabel('Frame ID (time)') ;        
%         ylabel('Speed (cm/second)') ;
% 
%         % Choose your Xmin & Xmax HERE    <------ 3
%         % Ball
% %         xMin = 0;
% %         xMax = 25;
% %         xlim([xMin xMax]);
% %         yMin = 0;
% %         yMax = 200;         
% %         ylim([yMin yMax]);
% 
%         % Bat
%         xMin = 0;
%         xMax = 25;
%         xlim([xMin xMax]);
%         yMin = 0;
%         yMax = 70;         
%         ylim([yMin yMax]);
% 
%         for i = 1:length(frames)-1
%             x1 = frames(i);
% %             y1 = (ballSpeeds(i));
%             y1 = (batSpeeds(i));
%             x2 = frames(i+1);
% %             y2 = (ballSpeeds(i+1));
%             y2 = (batSpeeds(i+1));
%             plot([x1,x2], [y1, y2], 'g-', 'LineWidth', 2);
% %             plot([x1,x2], [y1, y2], 'r-', 'LineWidth', 2);
%             set(gca,'FontSize',20)
%         end
        
        
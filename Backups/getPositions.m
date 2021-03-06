%% Function that detects automatically ball and bat and returns their positions
function [im1, im2, positions] = getPositions(index,object)

    % Matrix containing x,y coordinates of the ball in every image
    ball_positions = zeros(21,2);  
    % Matrix containing x,y coordinates of the bat in every image
    bat_positions = zeros(21,2);
    positions = zeros(2,2);

    for imageID = 1:21
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
    %     figure('Position', [850 400 900 600]);
    %     imshow(uniqueIm, 'InitialMagnification',250);
    %     impixelinfo();

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

    %   fprintf('\n\nx_ball %d: %d \n', imageID, ball_positions(imageID,1));
    %   fprintf('y_ball %d: %d \n', imageID, ball_positions(imageID,2));



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

    %     fprintf('\n\nx_bat %d: %d \n', imageID, bat_positions(imageID,1));
    %     fprintf('y_bat %d: %d \n', imageID, bat_positions(imageID,2));

    %% Returns positions of the ball or the bat for 2 successive images
     % (object and images selection, based on arguments)  
        if (object == 1)
            if (object == 1 && imageID == index)
                im1 = uniqueIm;
                positions(1,1) = ball_positions(imageID,1);
                positions(1,2) = ball_positions(imageID,2);
            end
            if (object == 1 && imageID == index+1)
                im2 = uniqueIm;
                positions(2,1) = ball_positions(imageID,1);
                positions(2,2) = ball_positions(imageID,2);
            end
        end
        if (object == 2)
            if (object == 1 && imageID == index)
                im1 = closingIm2;
                positions(1,1) = bat_positions(imageID,1);
                positions(1,2) = bat_positions(imageID,2);                
            end
            if (object == 1 && imageID == index+1)
                im2 = closingIm2;
                positions(2,1) = bat_positions(imageID,1);
                positions(2,2) = bat_positions(imageID,2);                    
            end
        end
        
    end   
    
end

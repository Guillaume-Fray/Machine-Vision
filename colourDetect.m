%% Extract joint, target and cube positions for side view
    % Matrix containing x,y coordinates of the ball in every image
    ball_positions = zeros(68,2);  
    % Matrix containing x,y coordinates of the bat in every image
    bat_positions = zeros(68,2);
    xBall = 0;
    yBall = 0; 
    xBat = 0;
    yBat = 0;
    
    rows = 175;
    columns = 260;
    upper_bound = 0;
    lower_bound = 0;
    left_bound = 0;
    right_bound = 0;
    search_radius_x = 30;
    search_radius_y = 25;
    
%         im0 = imread('TennisSet2/stennis.77.ppm');
%         figure('Position', [850 400 900 600]);
%         imshow(im0, 'InitialMagnification',250);
%         impixelinfo();

for imageID = 1:length(ball_positions)
%     im = imread(['TennisSet2/stennis.' int2str(89-imageID),'.ppm']);
    im = imread(['TennisSet2/stennis.' int2str(20+imageID),'.ppm']);
    fprintf('\n\nImage %d \n', imageID+20);
    
    % Size of image = 240 352 3  --- 3 being the RGB values of each pixel
    % Readjusted image size = 175 260 3

    %%
    % ---------------------------- TESTING -----------------------------------
    % To get the RGB low and high values of the ball by taking several 
    % points on each of them. Results below.

    % white = [255 255 255; 205 204 163; 202 196 155; 186 181 139; ...
    %                 205 188 180; 202 189 183; 207 190 183]; 

    % To get the pixel coordinates of the ball:
%         impixelinfo();


    % ---------------------------- END of TESTING -----------------------------

    %% To isolate the Bat
    % 	Extract out the color bands from the original image
    % 	into 3 separate 2D arrays, one for each color component.
    %   To constrain the mask to a certain area in the image corresponding to
    %   the table, in order to reduce undesirable detections
        whiteRedBand = im(1:175, 10:269, 1);
        whiteGreenBand = im(1:175, 10:269, 2);
        whiteBlueBand = im(1:175, 10:269, 3);

      % Threshold for White
    % (Using the previous values found during testing)
        redThresholdLowForWHITE = 185;
        redThresholdHighForWHITE = 255;
        greenThresholdLowForWHITE = 180;
        greenThresholdHighForWHITE = 255;
        blueThresholdLowForWHITE = 210; %135, 210
        blueThresholdHighForWHITE = 255;

    % Now apply each color band's particular thresholds to the color band
    redMaskForWHITE = (whiteRedBand >= redThresholdLowForWHITE) & (whiteRedBand <= redThresholdHighForWHITE);
    greenMaskForWHITE = (whiteGreenBand >= greenThresholdLowForWHITE) & (whiteGreenBand <= greenThresholdHighForWHITE);
    blueMaskForWHITE = (whiteBlueBand >= blueThresholdLowForWHITE) & (whiteBlueBand <= blueThresholdHighForWHITE);

    whiteObjectsMask = uint8(redMaskForWHITE & greenMaskForWHITE & blueMaskForWHITE);

    % Set a minimum size to get rid of the noise (in number of pixels) for the 
    % colour detection
    smallestAcceptableArea = 10;%20

    % Get rid of small objects
    whiteObjectsMask = uint8(bwareaopen(whiteObjectsMask, smallestAcceptableArea));

    % Smooth the border using a morphological closing operation, imclose().
    structuringElement = strel('disk', 4);
    whiteObjectsMask = imclose(whiteObjectsMask, structuringElement);

    % Fill in any holes in the regions, since they are most likely red also.
    whiteObjectsMask = uint8(imfill(whiteObjectsMask, 'holes'));

    % You can only multiply integers if they are of the same type.
    % (ObjectsMask is a logical array.)
    % We need to convert the type of ObjectsMask to the same data type as redBand.
    whiteObjectsMask = cast(whiteObjectsMask, class(whiteRedBand));

    % Use the object masks to mask out the specific coloured portions 
    % of the rgb image.
    maskedImageRforWHITE = whiteObjectsMask .* whiteRedBand;
    maskedImageGforWHITE = whiteObjectsMask .* whiteGreenBand;
    maskedImageBforWHITE = whiteObjectsMask .* whiteBlueBand;

    % Concatenate the masked color bands to form the rgb image.
    maskedRGBImageWHITE = cat(3, maskedImageRforWHITE, maskedImageGforWHITE, maskedImageBforWHITE);

    [meanRGBwhite, whiteAreas, numberOfWhiteBlobs] =  ...
        MeasureBlobs(whiteObjectsMask, whiteRedBand, whiteGreenBand, whiteBlueBand);

    imGray = weightedSum(maskedRGBImageWHITE, 0.2126, 0.7151, 0.0721);
    bin = imbinarize(imGray,1);
    sizeIm = bwareafilt(bin,[10, 250]);
        
    ball_pose_found = 0;
    if (imageID == 1)
      % set current position
      % then do search only 70-80 pixels around but don't forget to
      % implement a guard so that it does search out of image
      % coordinates

        % read horizontally and look for a non-empty pixel around the
        % area where the ball was in the previous frame
        while (ball_pose_found == 0)   
%                 fprintf('ball_pose_found 1: %d \n',ball_pose_found);
            for a = 1:rows
                for b = 1:columns
                    if (sizeIm(a,b) ~= 0 && ball_pose_found == 0)
                        xBall = b+10; % +10 because of the offset
                        yBall = a;
                        ball_pose_found = 1;
                    end
                end
            end
        end

    else
        while (ball_pose_found == 0)
%                 fprintf('ball_pose_found 2: %d \n',ball_pose_found);
            for i = upper_bound:lower_bound
                for j = left_bound:right_bound
                    if (sizeIm(i,j) ~= 0 && ball_pose_found == 0)
%                             fprintf('sizeIm(%d,%d): %d \n',i,j,sizeIm(i,j));
                        xBall = j+10; % +10 because of the offset
                        yBall = i;
                        ball_pose_found = 1;    
                    end
                    if (i == lower_bound && j == right_bound)
                        ball_pose_found = 2;  
                    end
                end
            end
        end       
    end

%       fprintf('ball_pose_found 3: %d \n',ball_pose_found);

    if ((yBall - search_radius_y) > 1)
        upper_bound = yBall - search_radius_y;
    else
        upper_bound = 1;
    end
    if ((yBall + search_radius_y) < 175)
        lower_bound = yBall + search_radius_y;
    else
        lower_bound = 175;
    end
    if ((xBall - search_radius_x) > 1)
        left_bound = xBall - search_radius_x;
    else
        left_bound = 1;
    end
    if ((xBall + search_radius_x) < 260)
        right_bound = xBall + search_radius_x;
    else
        right_bound = 260;
    end

%     fprintf('\nX%d ball: %d \n', imageID+20, xBall);
%     fprintf('Y%d ball: %d \n', imageID+20, yBall);
%     fprintf('left bound: %d \n', left_bound);
%     fprintf('right bound: %d \n', right_bound);
%     fprintf('upper bound: %d \n', upper_bound);
%     fprintf('lower bound: %d \n', lower_bound);

%     figure('Position', [850 400 900 600]);
%     imshow(sizeIm, 'InitialMagnification',250);
%     impixelinfo();
%     fontSize = 13;
%     caption = sprintf('Image %d', imageID+20);
% %   caption = sprintf('Image %d', 89 - imageID);
%     title(caption, 'FontSize', fontSize);

        
    %% To isolate the Bat
        % Converts the coloured RGB image to a grayscale image using proportional
        % scaling with values: 0.2126R + 0.7151G + 0.0721B 
        imGray2 = weightedSum(im, 0.2126, 0.7151, 0.0721);
        % Converts the matrix back to an image
        imGray2 = mat2gray(imGray2);

        faverage=ones(4,6)/(3*3);
        noiseIm2 = imfilter(imGray2,faverage);

        % Sets intensity thresholds
        low_intensity = 0.8;
        high_intensity = 1;
        % Converts grayscale image to binary using intensity thresholds to
        % separate the bat from the hand
        bin2 = gray2binary(noiseIm2, low_intensity, high_intensity);
        % Converts the matrix of double to logical values (0,1)
        bin2 = logical(bin2);

        % Eliminates table and hand
        shapeIm2 = bwpropfilt(bin2,'eccentricity',[0.8, 0.995]);
        % Eliminates small and large objects (noise)
        sizeIm2 = bwareafilt(shapeIm2,[100, 1000]);
        % Define Structuring Element
        se2 = strel('disk',5);
        % Fills in holes and gaps for better rendering
        closingIm2 = imclose(sizeIm2,se2);

        % To show resulting image after last modification
        figure;
        imshow(closingIm2, 'InitialMagnification',250);
        impixelinfo();

end

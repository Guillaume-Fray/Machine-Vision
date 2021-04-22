%% Extract joint, target and cube positions for side view
    clear all;
    close all;
    clc;
    % Matrix containing x,y coordinates of the ball in every image
    xyCentreBallOff = zeros(68,2);
    xyCentreBallTemp = zeros(68,2);
    xyCentreBallNext = zeros(68,2);
    
    % This corresponds to the real position as the search has a +10 offset
    % on the x-axis
    xyCentreBall = zeros(68,2);
    
    % Matrix containing x,y coordinates of the bat in every image
    xyCentreBat = zeros(68,2);
    xyCentreBatTemp = zeros(68,2);
    xyCentreBatNext = zeros(68,2);
    
    rowsBall = 175;
    columnsBall = 260;
    
    n = 68;
    
    
%         im0 = imread('TennisSet2/stennis.77.ppm');
%         figure('Position', [850 400 900 600]);
%         imshow(im0, 'InitialMagnification',250);
%         impixelinfo();

for imageID = 1:length(xyCentreBallOff)
%     im = imread(['TennisSet2/stennis.' int2str(89-imageID),'.ppm']);
    im = imread(['TennisSet2/stennis.' int2str(20+imageID),'.ppm']);
    imBat = im;
%     fprintf('\n\nImage %d \n', imageID+20);
    
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

    %% To isolate the Ball
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
        blueThresholdLowForWHITE = 210; 
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
    structuringElement = strel('disk', 3);
    whiteObjectsMask = imclose(whiteObjectsMask, structuringElement);

    % Fill in any holes in the regions
%     whiteObjectsMask = uint8(imfill(whiteObjectsMask, 'holes'));

    % We need to convert the type of ObjectsMask to the same data type as 
    % redBand.
    whiteObjectsMask = cast(whiteObjectsMask, class(whiteRedBand));

    % Use the object masks to mask out the specific coloured portions 
    % of the rgb image.
    maskedImageRforWHITE = whiteObjectsMask .* whiteRedBand;
    maskedImageGforWHITE = whiteObjectsMask .* whiteGreenBand;
    maskedImageBforWHITE = whiteObjectsMask .* whiteBlueBand;

    % Concatenate the masked color bands to form the rgb image.
    maskedRGBImageWHITE = cat(3, maskedImageRforWHITE, maskedImageGforWHITE, maskedImageBforWHITE);
    
    imGray = weightedSum(maskedRGBImageWHITE, 0.2126, 0.7151, 0.0721);
    bin = imbinarize(imGray,1);
    se = strel('line',5,-5);
    erodedBin = imerode(bin,se);  
    sizeIm = bwareafilt(bin,[10, 250]);
    
    %% To get Ball's Position
        [labelMat1, numberOfObjects] = bwlabel(bin, 8);
        % determine the most useful properties
        ballBox = regionprops(labelMat1, 'Perimeter', 'Centroid');
        
        if (imageID == 1)
                xyCentreBallOff(1,1) = 131;
                xyCentreBallOff(1,2) = 28;
        else
            if (numberOfObjects > 0)
%                 fprintf('numberOfGreenBlobs: %d\n',numberOfGreenBlobs);  
                for f = 1:numberOfObjects
                    xyCentreBallTemp(imageID,1) = int16(ballBox(f).Centroid(1));
                    xyCentreBallTemp(imageID,2) = int16(ballBox(f).Centroid(2));
                    heuristicTemp = sqrt(double((xyCentreBallTemp(imageID,2) - ...
                                    xyCentreBallOff(imageID-1,2))^2 + ...
                                    (xyCentreBallTemp(imageID,1) - ...
                                    xyCentreBallOff(imageID-1,1))^2));
                    
%                     fprintf('Temp Heuristic: %.1f\n', heuristicTemp);            
                                
                    if (f == 1)
                        heuristic = heuristicTemp;
                    end
                    if (heuristicTemp <= heuristic)
                        heuristic = heuristicTemp;
                        xyCentreBallNext(imageID,1) = uint16(ballBox(f).Centroid(1,1));
                        xyCentreBallNext(imageID,2) = uint16(ballBox(f).Centroid(1,2));
%                         fprintf('Area: %d\n',uint16(propsCube(k).Area));
                    end
                end
                % Guard in case the ball is not found
                if (heuristic > 30)
                    xyCentreBallNext(imageID,1) = xyCentreBallOff(imageID-1,1);
                    xyCentreBallNext(imageID,2) = xyCentreBallOff(imageID-1,2);
                end
                
                 xyCentreBallOff(imageID,1) = xyCentreBallNext(imageID,1);% because of the +10 offset of the search
                 xyCentreBallOff(imageID,2) = xyCentreBallNext(imageID,2);
                
%                     fprintf('Heuristic: %.1f\n', heuristic); 
%                     fprintf('%d   %d\n\n',xyCube(imageID,1), xyCube(imageID,2));
            else
                 xyCentreBallOff(imageID,1) =  xyCentreBallOff(imageID-1,1);
                 xyCentreBallOff(imageID,2) =  xyCentreBallOff(imageID-1,2);
            end
        end
        
        % Search offset correction
        xyCentreBall(imageID,1) = xyCentreBallOff(imageID,1) + 10;
        xyCentreBall(imageID,2) = xyCentreBallOff(imageID,2);
 
%         fprintf('%d\n, ',xyCentreBall(imageID,1)); 
%         fprintf('%d\n\n, ',xyCentreBall(imageID,2));    
    
%     if (imageID == 59)
%         figure('Position', [850 400 900 600]);
%         imshow(sizeIm, 'InitialMagnification',250);
% %         impixelinfo();
% % %         fontSize = 13;
% % %         title('FontSize', fontSize);
%     end

        
    %% To isolate the Bat
        % Get rid of light objects
        for c = 1:352
            for d = 1:240
                if (im(d,c,1)> 90 || im(d,c,2)> 70 || im(d,c,3)> 70)
                    imBat(d,c,1) = 255;
                    imBat(d,c,2) = 255;
                    imBat(d,c,3) = 255;
                end
            end
        end
        % Converts the coloured RGB image to a grayscale image using proportional
        % scaling with values: 0.2126R + 0.7151G + 0.0721B
        imGray2 = weightedSum(imBat, 0.2126, 0.7151, 0.0721);
        % Converts the matrix back to an image
        imGray2 = mat2gray(imGray2);
        
        faverage=ones(2,4)/(3*3);
        noiseIm2 = imfilter(imGray2,faverage);
        
        % Sets intensity thresholds
        low_intensity = 0.8;
        high_intensity = 0.9;
        % Converts grayscale image to binary using intensity thresholds to
        % separate the bat from the hand
        bin2 = gray2binary(noiseIm2, low_intensity, high_intensity);
        % Converts the matrix of double to logical values (0,1)
        bin2 = logical(bin2);
        
        % Make a "negative" of the binary image (black becomes white, and
        % white becomes black)
        for c = 1:352
            for d = 1:240
                if (bin2(d,c,1) == 0)
                    bin2(d,c,1) = 1;
                else
                    bin2(d,c,1) = 0;
                end
            end
        end
        
        strEl = strel('line',5,-5);
        % Separate Bat from the table outer line
        erodedBW = imerode(bin2,strEl);     
        sizeIm2 = bwareafilt(erodedBW,[30, 1200]);
        
        areaIm = bwpropfilt(sizeIm2,'Area',12);
        periIm = bwpropfilt(areaIm,'Perimeter',12);
        

    %% To identify and locate the tip of the bat
        % label the 11 remaining objects
        [labelMat2, numberOfObjects2] = bwlabel(periIm, 8);
        % determine the most useful properties
        batBox = regionprops(labelMat2,'Area', 'Perimeter','Centroid');
    
        
        if (imageID == 1)
                xyCentreBat(imageID,1) = 152;
                xyCentreBat(imageID,2) = 176;
        end
        
%         fprintf('Previous position = %d   %d \n', uint16(xCentre1), uint16(yCentre1));

        % Search for the nearest object to the previous known bat position
        if (imageID > 1)
            for e = 1:numberOfObjects2
                % discriminate the edges of the table
                if (batBox(e).Perimeter > 300)
                    xyCentreBatTemp(imageID,1) = 0;
                    xyCentreBatTemp(imageID,2) = 0;
                else
                    xyCentreBatTemp(imageID,1) = int16(batBox(e).Centroid(1));
                    xyCentreBatTemp(imageID,2) = int16(batBox(e).Centroid(2));
                end
               
                interDist = (xyCentreBatTemp(imageID,1)-xyCentreBat(imageID-1,1))^2 + ...
                    (xyCentreBatTemp(imageID,2)-xyCentreBat(imageID-1,2))^2;
                interDist = sqrt(double(interDist));
%                 fprintf('Previous pose = %d  %d   \n', xCentre1, yCentre1);
%                 fprintf('pose = %d  %d   \n', xCentre2, yCentre2);

%                 fprintf('minus = %d  %d   \n', xCentre2-xCentre1, yCentre2-yCentre1);
%                 fprintf('Current distance = %.1f   \n\n', interDist);
                if (e == 1)
                    distance = interDist;
                end
                if (interDist <= distance)
                    distance = interDist;
                    xyCentreBatNext(imageID,1) = int16(batBox(e).Centroid(1));
                    xyCentreBatNext(imageID,2) = int16(batBox(e).Centroid(2));
                end         
            end
            % Guard in case the bat is not found
            if (distance > 45)
                xyCentreBatNext(imageID,1) = xyCentreBat(imageID-1,1);
                xyCentreBatNext(imageID,2) = xyCentreBat(imageID-1,2);
            end

            xyCentreBat(imageID,1) = xyCentreBatNext(imageID,1);
            xyCentreBat(imageID,2) = xyCentreBatNext(imageID,2);

%             fprintf('Heuristic: %.1f\n', heuristic); 
%                     fprintf('%d   %d\n\n',xyCube(imageID,1), xyCube(imageID,2));
%             else
%                  xyCentreBall(imageID,1) =  xyCentreBall(imageID-1,1);
%                  xyCentreBall(imageID,2) =  xyCentreBall(imageID-1,2);    
                              
        end

        
%         if (imageID == 27  ||  imageID == 35)
% %             figure('Position', [850 400 900 600]);
% %             imshow(periIm, 'InitialMagnification',250);
% %             impixelinfo();
%             figure('Position', [650 400 900 600]);
%             imshow(periIm, 'InitialMagnification',200);
% %             impixelinfo();
%         end

%               fprintf(' %d\n', xyCentreBat(imageID,2));
%               fprintf(' %d,', xyCentreBat(imageID,2));
%             fprintf('Object %d A = %d \n', e, box(e).Area);
%             fprintf('P = %d \n', uint16(box(e).Perimeter));


end

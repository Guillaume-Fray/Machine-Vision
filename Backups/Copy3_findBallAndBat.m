%% Main file used to identify and locate ball and bat.
%determine their velocities
for uniqueIm = 1:20
    im = imread(['TennisSet1/stennis.' int2str(uniqueIm),'.ppm']);
    % Converts the coloured RGB image to a grayscale image using proportional
    % scaling with values: 0.2126R + 0.7151G + 0.0721B 
    imGray = weightedSum(im, 0.2126, 0.7151, 0.0721);
    % Converts the matrix back to an image
    imGray = mat2gray(imGray);
    % Converts the image to a matrix of doubles and stores it to the matrix variable
    matrix = im2double(imGray);

     % Applies a noise filter
    noiseIm = medfilt2(imGray);

    % Converts resulting image to binary image using the canny method and 
    % 2 thresholds (lower and upper threshold)
    bin = edge(noiseIm,'canny', [0.1 0.2]);

    % figure('Position', [500 100 900 600]);
    % imshow(bin, 'InitialMagnification',250);

    
    %% To isolate the Ball
    % Define Structuring Element
    se = strel('disk',10);
    % To only keep curved objects 
    shapeIm = bwpropfilt(bin,'eccentricity',[0, 0.8]); %0.9 for set 2
    % To fill in each object so that areas can be calculated
    closingIm = imclose(shapeIm,se);
    % To eliminate very small and very big objects (noise)
    sizeIm = bwareafilt(closingIm,[100, 400]); %150 - 400
    % To only keep the ball 
    uniqueIm = bwareafilt(sizeIm,1,'smallest');

    % To show original binary image next to same image after last modification
    figure('Position', [850 400 900 600]);
    imshow(shapeIm, 'InitialMagnification',250);
    
    
    %% To isolate the Bat
%     faverage=ones(4,6)/(3*3);
%     noiseIm2 = imfilter(imGray,faverage);
% 
%     % Sets intensity thresholds
%     low_intensity = 0.8;
%     high_intensity = 1;
%     % Converts grayscale image to binary using intensity thresholds to
%     % separate the bat from the hand
%     bin2 = gray2binary(noiseIm2, low_intensity, high_intensity);
%     % Converts the matrix of double to logical values (0,1)
%     bin2 = logical(bin2);
% 
%     % Eliminates table and hand
%     shapeIm2 = bwpropfilt(bin2,'eccentricity',[0.97, 0.995]);
%     % Eliminates small and large objects (noise)
%     sizeIm2 = bwareafilt(shapeIm2,[300, 1000]);
%     % Define Structuring Element
%     se2 = strel('disk',5);
%     % Fills in holes and gaps for better rendering
%     closingIm2 = imclose(sizeIm2,se2);
% 
%     figure;
%     imshow(closingIm2, 'InitialMagnification',250);
%     
    
    %% To identify and locate the tip of the bat
    % % Using labels to find the leftmost pixel of the resulting image as it  
    % % always belong to the tip of the bat. (where the speed is the highest)
    % Label all objects in the binary image
%     labelMat = bwlabel(bin);
%     [rows, columns] = size(labelMat);
%     % Matrix that only contains the object to be kept
%     newLabelMat = zeros(rows, columns);      
    %     bat_pose_found = 0;
    %     L2 = bwlabel(cc);
    %     % read vertically and look for a non-empty pixel
    %     while (bat_pose_found == 0)   
    %         for a = 1:columns
    %             for b = 1:rows
    %                 if (L2(b, a) ~= 0 && bat_pose_found == 0)
    %                     x_bat = b;
    %                     y_bat = a;
    %                     bat_pose_found = 1;                
    %                 end
    %             end
    %         end
    %     end
    %     
    %     fprintf('x_bat: %d \n', x_bat);
    %     fprintf('y_bat: %d \n', y_bat);       

    % figure('Position', [350 400 900 600]);
    % imshow(cc, 'InitialMagnification',250);
    % figure;
    % imshowpair(bin,cc,'montage');

    
end



















%% Problems with images: 13 in all scenarios
% --> get rid of it or estimate position of the ball


%%

%%% --- Remove largest connected element ---
% cc1 = bwconncomp(b);
% disp(size(cc1));
% disp(cc1(1,1));
% 
% numPixels = cellfun(@numel,cc1.PixelIdxList);
% [biggest,idx] = max(numPixels);
% b(cc1.PixelIdxList{idx}) = 0;
% imwrite(b, 'newIm.ppm');
% b2 = imread('newIm.ppm');  %does not work with image 4







% L = bwlabel(b);
% [rows, columns] = size(L);


% for i = 1:rows
%     for j = 1:columns
%         if ~(L(i,j) == 7 || L(i,j) == 5 || L(i,j) == 6)
%             L(i,j) = 0;
%         else
%             L(i,j) = 1;
%         end 
%     end
% end

% newIm0 = mat2gray(L);
% imwrite(newIm0, 'newIm11.ppm');
% 
% qw = imread('newIm11.ppm');
% imshow(qw);

% Original
% imshow(im0);



% cc2 = bwconncomp(b2);
% numPixels2 = cellfun(@numel,cc2.PixelIdxList);
% [biggest2,idx2] = max(numPixels2);
% b2(cc2.PixelIdxList{idx2}) = 0;
% imwrite(b2, 'newIm.ppm');
% b3 = imread('newIm.ppm');

% cc3 = bwconncomp(b3);
% numPixels3 = cellfun(@numel,cc3.PixelIdxList);
% [biggest3,idx3] = max(numPixels3);
% b3(cc3.PixelIdxList{idx3}) = 0;
% imwrite(b3, 'newIm.ppm');
% b4 = imread('newIm.ppm');

% cc4 = bwconncomp(b4);
% numPixels4 = cellfun(@numel,cc4.PixelIdxList);
% [biggest4,idx4] = max(numPixels4);
% b4(cc4.PixelIdxList{idx4}) = 0;
% imwrite(b4, 'newIm.ppm');
% b5 = imread('newIm.ppm');




% fprintf('rows of L: %d  %d \n',rows);
% fprintf('\ncolumns of L: %d  %d \n',columns);

% [ball_row, ball_column] = find(L==7);
% rc_ball = [ball_row, ball_column];
% 
% [raquet_row, raquet_column] = find(L==6);
% rc_raquet = [raquet_row,  raquet_column];

% for i = 1:rows
%     for j = 1:columns
%         if ~(L(i,j) == 1)
%             L(i,j) = 0;
%         else
%             L(i,j) = 1;
%         end 
%     end
% end




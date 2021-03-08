% tic toc
im0 = imread('TennisSet1/stennis.0.ppm');

% Converts the coloured RGB image to a grayscale image using the function
% 0.2989R + 0.5870G + 0.1140B 
i0 = rgb2gray(im0);

% Converts the image to a matrix of doubles and stores it to the mat0 variable
mat0 = im2double(i0);

 % Applies a median filter to reduce the noise
noiseI0 = medfilt2(i0);

% % SOLUTION 1
% % Convert the grayscale image to a binary image using Sobel
% sobelI0 = edge(noiseI0,'sobel');
% imshow(sobelI0);

% % SOLUTION 2
% Convert to binary image using the approxycanny method and dual threshold
% (best results with lower and upper threshold values = [0.06 0.2])
b = edge(noiseI0,'approxcanny', [0.06 0.2]); 
imshow(b);

% SOLUTION 3
% ----> below
% % % 4. Write a matlab function to use dual threshold (lower and upper thresholds) to convert
% % % gray image to binary.
% % % 5. Convert the grayscale images to binary.
% % % 6. Observe the effect of the threshold level by combining the binary and the grayscale
% % % image into a new image.
% % % 7. Use a histogram to choose the best threshold for each image.
% % % 8. Use Otsu algorithm for image binarization
% % % a. Matlab functions: level = graythresh(I)
% % % b. BW = imbinarize(I,level)




% % % % BW = edge(I,method,threshold,direction);
%imwrite(new01, 'image0.ppm');
%imwrite(new02, 'image0.ppm');
% % % % C = imfuse(A,B);





% Testing:
    %imwrite(i0, 'image0.ppm'); % --- THIS WORKS ---
    
    % matH = ones(3, 3);
    % newMatI = filter2(matH, mat0);
    % newI = mat2gray(newMatI);
    %imshow(i0);
    % imshow(im0);
    % sizeIm0 = size(im0); % 240  352  3(RGB)
    % fprintf('\n The size of the image (or matrix) is:  %.d  %.d  %.d % \n', ...
    %          sizeIm0(1), sizeIm0(2), sizeIm0(3));
    % disp(' ');
    %imshow(i0);
    % newImage0 = imread('image0.ppm');
    % imshow(newImage0);
    % cannyI0 = edge(newI0,'canny');
    % % Applies a contrast stretching filter with 1% saturation for both the 
    % % upper and lower limits.
    % newI0 = imadjust(noiseI0,stretchlim(noiseI0),[0.01 0.99]);
    % imshow(newI0);
    % b = edge(a,'approxcanny'); % approxcanny > Prewitt > Sobel > 
                                 % zerocross > Roberts > log > canny
    % % Stretches the contrasts with lower and upper limits
    % a = imadjust(noiseI0,stretchlim(noiseI0),[0.4 0.6]);           





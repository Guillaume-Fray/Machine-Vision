% tic toc
im = imread('TennisSet1/stennis.1.ppm');

% Converts the coloured RGB image to a grayscale image using proportional
% scaling with values: 0.2126R + 0.7151G + 0.0721B 
imGray = weightedSum(im, 0.2126, 0.7151, 0.0721);
% Converts the matrix back to an image
imGray = mat2gray(imGray);
% Converts the image to a matrix of doubles and stores it to the matrix variable
matrix = im2double(imGray);

 % Applies a noise filter
noiseIm = medfilt2(imGray);

% Convert to binary image using the canny method and 2 thresholds
% (lower and upper threshold)
bin = edge(noiseIm,'canny', [0.1 0.2]);

figure('Position', [500 100 900 600]);
imshow(bin, 'InitialMagnification',250);

% Label all objects in the binary image
labelMat = bwlabel(bin);
[rows, columns] = size(labelMat);
% Matrix that only contains the object to be kept
newLabelMat = zeros(rows, columns);

for i = 1:rows
    for j = 1:columns
        if ~(labelMat(i,j) == 27)
            newLabelMat(i,j) = 1;
        else
            newLabelMat(i,j) = 0;
        end 
    end
end

newIm1 = mat2gray(newLabelMat);
figure('Position', [500 100 900 600]);
imshow(newIm1, 'InitialMagnification',250);

%%

% ----------------------------- TESTING -----------------------------------
% Converts the coloured RGB image to a grayscale image using proportional
% scaling with values: 0.2989R + 0.5870G + 0.1140B 
% imGray2 = rgb2gray(im);

% Converts the coloured RGB image to a grayscale image using the intensity
% averaging approach
% imGray3 = averaging(im);
% imGray3 = mat2gray(imGray3);
% 
% matrix2 = im2double(imGray2);
% matrix3 = im2double(imGray3);
% 
% noiseIm2 = medfilt2(imGray2);
% noiseIm3 = medfilt2(imGray3);

% noiseIm = filter2([0.3, 0.6], imGray2);
% noiseIm2 = filter2([0.9, 1], imGray2);
% noiseIm3 = filter2([0.6, 0.9], imGray2);

% faverage=ones(4,6)/(3*3);
% noiseIm = imfilter(imGray,faverage);
% noiseIm2 = imfilter(imGray2,faverage);
% noiseIm3 = imfilter(imGray3,faverage);

% noiseIm = wiener2(imGray, [5 5]);
% noiseIm2 = wiener2(imGray2, [5 5]);
% noiseIm3 = wiener2(imGray3, [5 5]);

% noiseIm = imgaussfilt(imGray);
% noiseIm2 = imgaussfilt(imGray2);
% noiseIm3 = imgaussfilt(imGray3);

% laplacian = fspecial('laplacian');
% noiseIm = imfilter(imGray,laplacian,'replicate');
% noiseIm2 = imfilter(imGray2,laplacian,'replicate');
% noiseIm3 = imfilter(imGray3,laplacian,'replicate');


% figure;
% imhist(imGray);
% figure;
% imhist(imGray2);
% figure;
% imhist(imGray3);



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




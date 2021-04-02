% tic toc
im0 = imread('TennisSet1/stennis.17.ppm');

% Converts the coloured RGB image to a grayscale image using the function
% 0.2989R + 0.5870G + 0.1140B 
i0 = rgb2gray(im0);

% Converts the image to a matrix of doubles and stores it to the mat0 variable
mat0 = im2double(i0);

 % Applies a median filter to reduce the noise
noiseI0 = medfilt2(i0);

% % SOLUTION 2
% Convert to binary image using the approxycanny method and dual threshold
% (best results with lower and upper threshold values = [0.06 0.2])
b = edge(noiseI0,'approxcanny', [0.06 0.2]); 
% imshow(b);

%% To isolate Hand+Bat
se = strel('disk',3);
% c = imclose(b,se);

% c = bwpropfilt(b,'perimeter', 1); %check which SE is the largest
% c = bwareafilt(b,[65 100]);
% d = bwpropfilt(c,'perimeter', 1);

d = bwpropfilt(b,'eccentricity',[0.96, 1]);
% d = imclose(c,se);


%% To isolate the ball
% % To fill in each object so that areas can be calculated
% e = imclose(b,se);
se2 = strel('disk',10);
% To only keep curved objects 
f = bwpropfilt(b,'eccentricity',[0, 0.8]); %0.9 for set 2
% To fill in each object so that areas can be calculated
e = imclose(f,se2);
% To get rid of very small and very big objects (noise)
h = bwareafilt(e,[250, 500]);
% To only keep the ball 
i = bwareafilt(h,1,'largest');

imshowpair(b,d,'montage');
% To show original binary image next to same image after last modification
% imshowpair(b,i,'montage');



















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






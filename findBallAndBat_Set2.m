% tic toc
im = imread('TennisSet2/stennis.79.ppm');
figure;
imshow(im);

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

% figure('Position', [500 100 900 600]);
% imshow(bin, 'InitialMagnification',250);

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

% newIm1 = mat2gray(newLabelMat);
% figure('Position', [500 100 900 600]);
% imshow(newIm1, 'InitialMagnification',250);

%% To isolate Hand+Bat
se = strel('disk',10);
% to get rid off the table (pure straight lines => coefficient = 1)
c = bwpropfilt(bin,'eccentricity',[0.8, 0.995]); %[0.9, 0.995] for set 2
% to get rid off small objects (noise)
d = bwareafilt(c,[50, 10000]);
cc = imclose(d,se);

% Using labesl to find the leftmost pixel of the resulting image as it  
% always belong to the tip of the bat. (where the speed is the highest)
    bat_pose_found = 0;
    L2 = bwlabel(cc);
    % read vertically and look for a non-empty pixel
    while (bat_pose_found == 0)   
        for a = 1:columns
            for b = 1:rows
                if (L2(b, a) ~= 0 && bat_pose_found == 0)
                    x_bat = b;
                    y_bat = a;
                    bat_pose_found = 1;                
                end
            end
        end
    end
    
    fprintf('x_bat: %d \n', x_bat);
    fprintf('y_bat: %d \n', y_bat);       
                
figure('Position', [350 400 900 600]);
imshow(cc, 'InitialMagnification',250);
% figure;
% imshowpair(bin,cc,'montage');


%% To isolate the Ball
% % To fill in each object so that areas can be calculated
% e = imclose(b,se);
se2 = strel('disk',10); % try small values like 5
% To only keep curved objects 
f = bwpropfilt(bin,'eccentricity',[0, 0.95]); %0.8 originally (up to 48); 
% from 55 the ball is in the hand and then many problems occur

% To fill in each object so that areas can be calculated
e = imclose(f,se2);
% To get rid of very small and very big objects (noise)
h = bwareafilt(e,[80, 400]); %100 - 400 originally (up to 48)
% To only keep the ball 
i = bwareafilt(h,5,'smallest');

% To show original binary image next to same image after last modification
figure('Position', [850 400 900 600]);
imshow(i, 'InitialMagnification',250);
% figure;
% imshowpair(bin,i,'montage');




















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




function [grayMatrix] = weightedSum(rgbImage, R, G, B)
% Converts an RGB image to a grayscale image using the weighted sum approach
%   Takes as input the RGB image matrix and the 3 factors R,G and B and
%   returns the resulting grayscale matrix.
    [rows, col] = size(rgbImage);
    % Division by 3 necessary because there are 3 values for each column
    % in the RGB matrix but only 1 per column in the grayscale image.
    columns = col/3;
    grayMatrix = zeros(rows,columns);
    
    for i = 1:rows
        for j = 1:columns
            grayMatrix(i,j) = R*rgbImage(i,j,1) + G*rgbImage(i,j,2) + ...
                              B*rgbImage(i,j,3);
        end
    end
end

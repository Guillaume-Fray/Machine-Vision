function [grayMatrix] = averaging(rgbImage)
% Converts an RGB image to a grayscale image by averaging the RGB values
%   Takes as input the RGB image matrix and returns the resulting 
%   grayscale matrix.
    [rows, col] = size(rgbImage);    
    % Division by 3 necessary because there are 3 values for each column
    % in the RGB matrix but only 1 per column in the grayscale image.
    columns = col/3;
    grayMatrix = zeros(rows,columns);
    
    for i = 1:rows
        for j = 1:columns
            grayMatrix(i,j) = (rgbImage(i,j,1) + rgbImage(i,j,2) + ...
                              rgbImage(i,j,3))/3;
        end
    end
end

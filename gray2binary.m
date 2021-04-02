function [binMatrix] = gray2binary(grayImage, low, high)
% Converts an grayscale image to a binary image using low and high 
% threshold values based on intensities
    [rows, col] = size(grayImage);
    binMatrix = zeros(rows,col);
    
    for i = 1:rows
        for j = 1:col
            if (grayImage(i,j) < low)
%                 fprintf('\nbinMatrix(%d,%d): %.2f', i,j,binMatrix(i,j));
                binMatrix(i,j) = 0;
            elseif (grayImage(i,j) > high)
                binMatrix(i,j) = 0;
            else
                binMatrix(i,j) = 1;
            end
        end
    end
end
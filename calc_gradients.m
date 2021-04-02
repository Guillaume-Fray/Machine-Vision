function [xGrad, yGrad, tGrad] = calc_gradients(image1, image2)
% return gradients
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Converts the image to a matrix of doubles
    matrix1 = im2double(image1);
    matrix2 = im2double(image2);
    matrix1 = matrix1 + 1;
    matrix2 = matrix2 + 1;

    hmsk = [-1 0 1 ; -1 0 1 ; -1 0 1];
    vmsk = [-1 -1 -1 ; 0 0 0 ; 1 1 1];
    amsk = ones(3,3) / 9.0;

    sim1 = conv2(matrix1, amsk);
    sim2 = conv2(matrix2, amsk);
    mim = 0.5 * (sim1 + sim2);

    xGrad = conv2(mim, hmsk);
    yGrad = conv2(mim, vmsk);
    tGrad = conv2(sim2 - sim1, amsk);

end
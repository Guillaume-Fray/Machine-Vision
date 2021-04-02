%% Determine ball and bat 2D velocities (in pixels per frame)
%     im1 = imread('TennisSet1/stennis.1.ppm');
%     im2 = imread('TennisSet1/stennis.2.ppm');
    ball = 1;
    bat = 2;
    
    imageID = 11;
    [im1, im2, positions] = findBallAndBat(imageID,ball);
    im1 = im2double(im1);
    im1 = im1+1;
    im2 = im2double(im2);
    im2 = im2+1;
    
    
    [xGrad, yGrad, tGrad] = calc_gradients(im1, im2);
    [vx,vy] = calc_velocities(xGrad, yGrad, tGrad);
    
%         figure;
% %         imshow(xGrad, 'InitialMagnification',250);
%         mesh(vx);
%         figure;
% %         imshow(yGrad, 'InitialMagnification',250);
%         mesh(vy);
        figure;
        imshow(vx,[], 'InitialMagnification',350);
        impixelinfo();
        title('Vx');
        set(gca,'FontSize',20)
        
%         imshow(tGrad, 'InitialMagnification',250);
        figure;
        imshow(vy,[], 'InitialMagnification',350);
        impixelinfo();
        title('Vy');
        set(gca,'FontSize',20)
        
        vx = transpose(vx);
        vy = transpose(vy);
        [rows, cols] = size(vx);
        
       for i = 1:rows
           for j = 1:cols
               if (vx(i,j) ~= 0 && vy(i,j) ~= 0)
                fprintf('\nposition: %d  %d \n', i,j);           
                fprintf('vx: %.4f \n', vx(i,j));
                fprintf('vy: %.4f \n', vy(i,j));
               end
           end
       end
       
                   
%       fprintf('\nposition: %d  %d \n', positions(2,1),positions(2,2));           
%       fprintf('\nvx: %f \n', vx(positions(2,1),positions(2,2)),[]);
%       fprintf('vy: %f \n', vy(positions(2,1),positions(2,2)),[]);
        
        
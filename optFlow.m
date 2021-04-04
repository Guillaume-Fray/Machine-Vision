%% Optical Flow Visualisation

    opticFlow = opticalFlowLKDoG('NumFrames',3,'NoiseThreshold', 0.0009);

    for imageID = 1:20
        
        h = figure;
        movegui(h);
        hViewPanel = uipanel(h,'Position',[0 0 1 1],'Title','Plot of Optical Flow Vectors');
        hPlot = axes(hViewPanel);
        im = imread(['TennisSet1/stennis.' int2str(imageID),'.ppm']);
        % Converts the coloured RGB image to a grayscale image using proportional
        % scaling with values: 0.2126R + 0.7151G + 0.0721B 
        imGray = weightedSum(im, 0.2126, 0.7151, 0.0721);

        flow = estimateFlow(opticFlow,imGray);
        imshow(im, 'InitialMagnification',350);
        hold on;
        plot(flow,'DecimationFactor',[20 1],'ScaleFactor',10,'Parent',hPlot);
        hold off;
        pause(10^-3);

    end
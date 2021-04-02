% File to plot the results
clear all;
close all;

% Measured Positions:
    % Bat 
%     X1 = [111,111,112,113,113,112,110,108,106,104,103,102,101,101,102,102,103,105,105,106];
%     Y1 = [153,159,164,168,173,175,175,174,169,163,154,148,143,143,145,152,158,164,171,174];
    
%     % Ball 
    X1 = [143,143,140,138,137,136,134,133,133,131,133,132,132,132,135,134,137,137,134,137];
    Y1 = [40,29,23,21,23,29,40,56,77,102,130,100,74,52,34,21,12,8,9,12];

% % Real Positions:
%     % Bat 
%     X2 = [111,113,113,115,115,113,111,109,107,105,103,103,103,103,103,105,105,105,105,107];
%     Y2 = [149,153,159,163,167,171,171,169,165,159,151,143,139,139,141,147,153,161,165,169];

%     % Ball 
    X2 = [142,141,140,140,139,137,136,134,133,131,131,132,131,133,134,135,135,135,136,136];
    Y2 = [42,31,24,21,23,30,42,59,81,112,135,105,79,55,36,22,13,9,9,13];

hold on;
s1 = scatter((X1),(Y1),'filled','g');
% s1.MarkerEdgeColor = 'b';
s1.MarkerEdgeColor = 'g';
s2 = scatter((X2),(Y2),'filled');
% s2.MarkerEdgeColor = 'r';
s2.MarkerEdgeColor = 'm';


% Pick your axes HERE             <------ 2
% title('Bat Trajectory');
title('Ball Trajectory');
xlabel('X coordinates   -   (nb of pixels)') ;
ylabel('Y coordinates   -   (nb of pixels)') ;

% Choose your Xmin & Xmax HERE    <------ 3
xMin = 50;
xMax = 200;
xlim([xMin xMax]);
yMin = 0;
yMax = 150;
ylim([yMin yMax]);

for i = 1:(length(X1)-1)
    x1 = (X1(i));
    y1 = (Y1(i));
    x2 = (X1(i+1));
    y2 = (Y1(i+1));
%     plot([x1,x2], [y1, y2], 'b-', 'LineWidth', 2);
    plot([x1,x2], [y1, y2], 'g-', 'LineWidth', 2);
    set(gca,'FontSize',20)
end

for i = 1:(length(X2)-1)
    x1 = (X2(i));
    y1 = (Y2(i));
    x2 = (X2(i+1));
    y2 = (Y2(i+1));
%     plot([x1,x2], [y1, y2], 'r-', 'LineWidth', 2);
    plot([x1,x2], [y1, y2], 'm-', 'LineWidth', 2);
    set(gca,'FontSize',20)
end

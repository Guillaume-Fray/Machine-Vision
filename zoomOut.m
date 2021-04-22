

X1 = [1,10,20,30,40,50,68];
Y1 = [68.47,63.01,53.00,39.05,29.12,18.02,17.80];

hold on;
s1 = scatter(X1,Y1,'filled');
s1.MarkerEdgeColor = 'b';
view(-30,10);


% Pick your axes HERE             
title('Zoom Out Function');
xlabel('Frame ID') ;
ylabel('Bat Length   -   (nb of pixels)') ;

% Choose your Xmin & Xmax HERE   
xMin = 1;
xMax = 68;
ylim([xMin xMax]);
yMin = 0;
yMax = 70;
ylim([yMin yMax]);


for i = 1:(length(X1)-1)
    x1 = X1(i);
    y1 = Y1(i);
    x2 = X1(i+1);
    y2 = (Y1(i+1));
    plot([x1,x2], [y1, y2], 'b-', 'LineWidth', 2);
    set(gca,'FontSize',20)
end


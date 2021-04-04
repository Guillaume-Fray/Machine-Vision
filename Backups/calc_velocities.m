function [vx, vy] = calc_velocities(xg, yg, tg)
% Returns velocities
% Must do by loops to catch singular velocity and clamp
[rows,cols] = size(xg);
% first do x velocity. Clamp at 3
for r = 1:rows
  for c = 1:cols
    if (abs(xg(r,c)) < 0.01)
      vx(r,c) = 0;
    else
      vx(r,c) = tg(r,c) ./ xg(r,c);
      if (abs(vx(r,c)) > 3) 
          vx(r,c) = 0; 
      end
    end
  end
end
% then do y velocity. Clamp at 3
for r = 1:rows
  for c = 1:cols
    if (abs(yg(r,c)) < 0.01)
      vy(r,c) = 0;
    else
      vy(r,c) = tg(r,c) ./ yg(r,c);
      if (abs(vy(r,c)) > 3) 
          vy(r,c) = 0; 
      end
    end
  end
end


function [coor_bound] = bound_coor(coor_floor,boundary)
%   坐标的边界限制
if coor_floor >= 1 && coor_floor <= boundary
    coor_bound = coor_floor;
elseif coor_floor < 1
    coor_bound = 1;
else
    coor_bound = boundary;
end
end


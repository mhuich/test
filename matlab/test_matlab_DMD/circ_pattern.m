function array = circ_pattern(width, height, radius)

x0 = round(height/2);
    y0 = round(width/2);

    [xx, yy] = meshgrid(1:height, 1:width);

    array= zeros(width,height);
    array((xx-x0).^2 + (yy-y0).^2 < radius^2)=1;
%     array=array==0;
    array = uint8(255*array);
end

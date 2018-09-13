 function array_moving_fast = lattice_moving_fast(height, width,period,pinhole,step_band,moving_speed)
%  height=400;width=400; period=50; pinhole=20; step_band=40; moving_speed=3;
arraybasic=logical(zeros(period));
arraybasic(1:pinhole,1:pinhole)=logical(ones(pinhole));
arraydum=repmat(arraybasic,floor(height/period),floor(width/period));
array= logical(zeros(height,width,floor(step_band/moving_speed)^2));
ii=1;
for i=1:floor(step_band/moving_speed);
    arraydum =(circshift(arraydum,moving_speed,1));
    for j=1:floor(step_band/moving_speed);
        arraydum = (circshift(arraydum,moving_speed,2));
        array(1:size(arraydum,1),1:size(arraydum,2),ii)=arraydum;
%         imshow(array(:,:,ii));
        ii=ii+1;
    end
end
 array = uint8(255*array);
 array_moving_fast=array;


    
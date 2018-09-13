function array = lattice_pattern(width, height,period,pinhole,shift)
array= zeros(width,height);
arraybasic=zeros(period);
arraybasic(1+shift(1)*pinhole:shift(1)*pinhole+pinhole,1+shift(2)*pinhole:shift(2)*pinhole+pinhole)=ones(pinhole);
arraydum=repmat(arraybasic,ceil(max(width,height)/period));
array=arraydum(1:size(array,1),1:size(array,2));

%array = uint8(255*array);
array = logical(array);
end
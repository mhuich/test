function mask = rand_pattern(width, height, percentage)
    %%% DMD avec largeur à la verticale
    p=percentage/100;
    maskRAND = rand(height, width);

    S = sort(maskRAND(:));
    ind = round( height*width*p );
    s = S( end - min(ind,length(S)) + 1 );
    maskIN = ( (maskRAND >= s) >0 );

%     h = ones(16,16);
%     mask=conv2(maskIN,h,'same');
    mask=uint8(255*maskIN);
end
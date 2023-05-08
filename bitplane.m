function [ Bres ] = bitplane( A,bp )
At=Component_Transformation(A,'FI');
Awz=zeros(size(A));
Srec=zeros(size(A));

Awz(:,:,1)=wavelift(At(:,:,1), 3, 'cdf97');
Awz(:,:,2)=wavelift(At(:,:,2), 3, 'cdf97');
Awz(:,:,3)=wavelift(At(:,:,3), 3, 'cdf97');

if(bp<1)
    bp=1;
elseif(bp>7)
    bp=1;
else
    bp=bp;
end

res=max(max(At(:,:,1)));
bin=dec2bin(res);
n=length(bin);
res2=floor(abs(Awz(:,:,1))/(2 ^ (n - (n-bp)))) * (2 ^ (n -(n- bp)));
res3=res2 .* sign(Awz(:,:,1));

res=max(max(At(:,:,2)));
bin=dec2bin(res);
n=length(bin);
res4=floor(abs(Awz(:,:,2))/(2 ^ (n - (n-bp)))) * (2 ^ (n -(n- bp)));
res5=res4 .* sign(Awz(:,:,2));

res=max(max(At(:,:,3)));
bin=dec2bin(res);
n=length(bin);
res6=floor(abs(Awz(:,:,3))/(2 ^ (n - (n-bp)))) * (2 ^ (n -(n- bp)));
res7=res6 .* sign(Awz(:,:,3));

Srec(:,:,1)=wavelift(res3, -3, 'cdf97');
Srec(:,:,2)=wavelift(res5, -3, 'cdf97');
Srec(:,:,3)=wavelift(res7, -3, 'cdf97');

Arec=Component_Transformation(Srec,'II');
Bres=uint8(Arec);
figure;imshow(uint8(Bres));
return
end
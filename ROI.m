% Para realizar el guardado de un video
%
%system('dir');
%system('ffmpeg -i M3.avi');
%system('ffmpeg -i M3.avi imagen%3d.jpg');
%system('ffmpeg -f image2 imagen%3d.jpg videofinal.mpeg');
%system('ffmpeg -i video.avi -r 30 imagen%3d.jpg');
%D=dir;
%D.path
%D=what

function imagen = ROI(img,bp)

%img=img(256:512,256:512,:);
%figure;imshow(img);

imgt = Component_Transformation(img, 'FI');

imgy = imgt(:,:, 1);
imgcb = imgt(:,:, 2);
imgcr = imgt(:,:, 3);

imgw=zeros(size(img));
imgw(:,:,1) = wavelift(imgy, 3, 'cdf97');
imgw(:,:,2) = wavelift(imgcb, 3, 'cdf97');
imgw(:,:,3) = wavelift(imgcr, 3, 'cdf97');

%figure;imshow(imgyw);

Y=max(max(imgy));
Cb=max(max(imgcb));
Cr=max(max(imgcr));
T=[Y Cb Cr];
x=ceil(log2(min(T)));
b=2^x;
%hay que multiplicar cada cuadrante por b que es la entropia maxima

matriz = zeros(size(img));

for i=1:1:3
    matriz(1:64,1:64,i)=imgw(1:64,1:64,i);
    matriz(1:32,1:32,i)=imgw(1:32,1:32,i).*b;
    
    matriz(1:64,65:128,i)=imgw(1:64,65:128,i);
    matriz(1:32,65:96,i)=imgw(1:32,65:96,i).*b;
    matriz(65:128,1:64,i)=imgw(65:128,1:64,i);
    matriz(65:96,1:32,i)=imgw(65:96,1:32,i).*b;
    matriz(65:128,65:128,i)=imgw(65:128,65:128,i);
    matriz(65:96,65:96,i)=imgw(65:96,65:96,i).*b;
    
    matriz(1:128,129:256,i)=imgw(1:128,129:256,i);
    matriz(1:64,129:192,i)=imgw(1:64,129:192,i).*b;
    matriz(129:256,1:128,i)=imgw(129:256,1:128,i);
    matriz(129:192,1:64,i)=imgw(129:192,1:64,i).*b;
    matriz(129:256,129:256,i)=imgw(129:256,129:256,i);
    matriz(129:192,129:192,i)=imgw(129:192,129:192,i).*b;
    
    matriz(1:256,257:end,i)=imgw(1:256,257:512,i);
    matriz(1:128,257:384,i)=imgw(1:128,257:384,i).*b;
    matriz(257:end,1:256,i)=imgw(257:512,1:256,i);
    matriz(257:384,1:128,i)=imgw(257:384,1:128,i).*b;
    matriz(257:end,257:end,i)=imgw(257:512,257:512,i);
    matriz(257:384,257:384,i)=imgw(257:384,257:384,i).*b;
end

Awz=matriz;

At=Component_Transformation(img,'FI');
Srec=zeros(size(img));

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

Srec(:,:,1)=res3;
Srec(:,:,2)=res5;
Srec(:,:,3)=res7;
w=Srec;

matriznueva=zeros(size(img));

for i=1:1:3
    matriznueva(1:64,1:64,i)=w(1:64,1:64,i);
    matriznueva(1:32,1:32,i)=w(1:32,1:32,i)./b;
    
    matriznueva(1:64,65:128,i)=w(1:64,65:128,i);
    matriznueva(1:32,65:96,i)=w(1:32,65:96,i)./b;
    matriznueva(65:128,1:64,i)=w(65:128,1:64,i);
    matriznueva(65:96,1:32,i)=w(65:96,1:32,i)./b;
    matriznueva(65:128,65:128,i)=w(65:128,65:128,i);
    matriznueva(65:96,65:96,i)=w(65:96,65:96,i)./b;
    
    matriznueva(1:128,129:256,i)=w(1:128,129:256,i);
    matriznueva(1:64,129:192,i)=w(1:64,129:192,i)./b;
    matriznueva(129:256,1:128,i)=w(129:256,1:128,i);
    matriznueva(129:192,1:64,i)=w(129:192,1:64,i)./b;
    matriznueva(129:256,129:256,i)=w(129:256,129:256,i);
    matriznueva(129:192,129:192,i)=w(129:192,129:192,i)./b;
    
    matriznueva(1:256,257:end,i)=w(1:256,257:512,i);
    matriznueva(1:128,257:384,i)=w(1:128,257:384,i)./b;
    matriznueva(257:end,1:256,i)=w(257:512,1:256,i);
    matriznueva(257:384,1:128,i)=w(257:384,1:128,i)./b;
    matriznueva(257:end,257:end,i)=w(257:512,257:512,i);
    matriznueva(257:384,257:384,i)=w(257:384,257:384,i)./b;
    
end

imgc = zeros(size(img));
imgc(:,:,1) = wavelift(matriznueva(:,:,1), -3, 'cdf97');
imgc(:,:,2) = wavelift(matriznueva(:,:,2), -3, 'cdf97');
imgc(:,:,3) = wavelift(matriznueva(:,:,3), -3, 'cdf97');

%   imgf(:,:,:)=imgc1;
%   imgf(:,:,2)=imgc2;
%   imgf(:,:,3)=imgc3;

imgc = Component_Transformation(imgc, 'II');
imagen=uint8(imgc);
figure;imshow(uint8(imgc));

end
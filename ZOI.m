% Para realizar el guardado de un video
%system('dir');
%system('ffmpeg -i M3.avi');
%system('ffmpeg -i M3.avi imagen%3d.jpg');
%system('ffmpeg -f image2 imagen%3d.jpg videofinal.mpeg');
%D=dir;
%D.path
%D=what

function imagen = ZOI(img)

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
    matriz = zeros(256,256,3);
    
    for i=1:1:3
    matriz(1:32,1:32,i)=imgw(1:32,1:32,i);

    matriz(1:32,33:64,i)=imgw(1:32,65:96,i);
    matriz(33:64,1:32,i)=imgw(65:96,1:32,i);
    matriz(33:64,33:64,i)=imgw(65:96,65:96,i);
    
    matriz(1:64,65:128,i)=imgw(1:64,129:192,i);
    matriz(65:128,1:64,i)=imgw(129:192,1:64,i);
    matriz(65:128,65:128,i)=imgw(129:192,129:192,i);
    
    matriz(1:128,129:256,i)=imgw(1:128,257:384,i);
    matriz(129:256,1:128,i)=imgw(257:384,1:128,i);
    matriz(129:256,129:256,i)=imgw(257:384,257:384,i);
    end
    
    imgc = zeros(size(matriz));
    imgc(:,:,1) = wavelift(matriz(:,:,1), -3, 'cdf97');
    imgc(:,:,2) = wavelift(matriz(:,:,2), -3, 'cdf97');
    imgc(:,:,3) = wavelift(matriz(:,:,3), -3, 'cdf97');
    
 %   imgf(:,:,:)=imgc1;
 %   imgf(:,:,2)=imgc2;
 %   imgf(:,:,3)=imgc3;    
      
    imgz = Component_Transformation(imgc, 'II');
    imagen=uint8(imgz);
    figure;imshow(uint8(imgz));

    Y=max(max(imgy));
    Cb=max(max(imgcb));
    Cr=max(max(imgcr));
    T=[Y Cb Cr];
    b=ceil(log2(min(T)));
    fprintf('Ymax: %f ',Y);
    fprintf('Cbmax: %f ',Cb);
    fprintf('Crmax: %f ',Cr);
    fprintf('Entropia: %f ',b);
 
end
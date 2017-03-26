im1=imread('CMU_right.jpg');
im2=imread('CMU_left.jpg');
subplot(1,2,1);
imshow(im1);
subplot(1,2,2);
imshow(im2);

[x1,y1] = ginput(4);
[x2,y2] = ginput(4);
A=[];

for i=1:length(x1)
    A= [A; -1*x1(i) -1*y1(i) -1 0 0 0 x1(i)*x2(i) y1(i)*x2(i) x2(i)];
    A= [A; 0 0 0 -1*x1(i) -1*y1(i) -1 x1(i)*y2(i) y1(i)*y2(i) y2(i)];    
end

[U, S, V] = svd(A);
h = V(:, end);
H = [h(1:3)';h(4:6)';h(7:9)'];

xLimits = [0 1000];
yLimits = [0 1000];
R = imref2d(size(im1),xLimits,yLimits) ;

tform = projective2d(H');
outputImage = imwarp(im1,tform, 'OutputView', R);
figure
imshow(im2);
imshow(outputImage);

% [m,n] = size(im1);
% for x=1:m
%     for y=1:n
% %         (x' ; y' ; 1) = H *(x ; y ; 1);
% imageData = im1;
% hSurface = surf([0 1; 0 1],[0 0; 1 1],zeros(2));
% set(hSurface,'CData',imageData,'FaceColor','texturemap');
        
        
        
        


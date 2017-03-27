function homography=returnHomography()
global pointArray;
A=[];
for i=1:1:4
    x=pointArray{i}(1);
    y=pointArray{i}(2);
    u=pointArray{i+4}(1);
    v=pointArray{i+4}(2);
    A=[A;-x -y -1 0 0 0 u*x u*y u;0 0 0 -x -y -1 v*x v*y v ];
end
% homography=null(A);
[U, S, V] = svd(A);
homography = V(:, end);
homography=vec2mat(homography',3);
global tform;
tform= estimateGeometricTransform([pointArray{1};pointArray{2};pointArray{3};pointArray{4}],[pointArray{5};pointArray{6};pointArray{7};pointArray{8}],...
        'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);
global w;
w=homography_solve([pointArray{1};pointArray{2};pointArray{3};pointArray{4}]',[pointArray{5};pointArray{6};pointArray{7};pointArray{8}]');

end
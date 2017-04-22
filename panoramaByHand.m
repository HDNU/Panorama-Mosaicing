function panoramaByHand()
global leftImage rightImage;
I = leftImage;
tforms(2) = projective2d(eye(3));
global homography;
t = projective2d(homography');
tforms(2) = tforms(1).T * t.T;
imageSize = size(I);  % all the images are the same size
% Compute the output limits  for each transform
for i = 1:numel(tforms)           
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(2)], [1 imageSize(1)]);    
end



avgXLim = mean(xlim, 2);

[~, idx] = sort(avgXLim);

centerIdx = floor((numel(tforms)+1)/2);

centerImageIdx = idx(centerIdx);



Tinv = invert(tforms(centerImageIdx));

for i = 1:numel(tforms)    
    tforms(i).T = Tinv.T * tforms(i).T;
end

%% Step 3 - Initialize the Panorama
% Now, create an initial, empty, panorama into which all the images are
% mapped. 
% 
% Use the |outputLimits| method to compute the minimum and maximum output
% limits over all transformations. These values are used to automatically
% compute the size of the panorama.

for i = 1:numel(tforms)           
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(2)], [1 imageSize(1)]);
end

% Find the minimum and maximum output limits 
xMin = min([1; xlim(:)]);
xMax = max([imageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([imageSize(1); ylim(:)]);

% Width and height of panorama.
width  = round(xMax - xMin);
height = round(yMax - yMin);

% Initialize the "empty" panorama.
panorama = zeros([height width 3], 'like', I);

%% Step 4 - Create the Panorama
% Use |imwarp| to map images into the panorama and use
% |vision.AlphaBlender| to overlay the images together.

blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');  

% Create a 2-D spatial reference object defining the size of the panorama.
xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);

% Create the panorama.
a={rightImage,leftImage};
for i = 1:2
    
    I = a{i};   
   
    % Transform I into the panorama.
    warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView);
       
    % Create an mask for the overlay operation.
    warpedMask = imwarp(ones(size(I(:,:,1))), tforms(i), 'OutputView', panoramaView);        
    
    % Clean up edge artifacts in the mask and convert to a binary image.
    warpedMask = warpedMask >= 1;
    
    % Overlay the warpedImage onto the panorama.
    panorama = step(blender, panorama, warpedImage, warpedMask);
end

figure
imshow(panorama)
end


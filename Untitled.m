fig=figure;
imshow('moon.tif')
dcm_obj = datacursormode(fig);
set(dcm_obj,'DisplayStyle','window',...
    'SnapToDataVertex','off','Enable','on')

disp('Click line to display a data tip, then press Return.')
% Wait while the user does this.
pause 

c_info = getCursorInfo(dcm_obj);
% % Make selected line wider
%  set(c_info.Target,'LineWidth',2) 
I = imread('moon.tif');
RGB = insertMarker(I,c_info.Position,'x','color','red','size',10);
hold on
imshow(RGB)


dcm_obj = datacursormode(fig);
set(dcm_obj,'DisplayStyle','window',...
    'SnapToDataVertex','off','Enable','on')

disp('Click line to display a data tip, then press Return.')
% Wait while the user does this.
pause 

c_info = getCursorInfo(dcm_obj);
% % Make selected line wider
%  set(c_info.Target,'LineWidth',2) 
I = imread('moon.tif');
RGB = insertMarker(RGB,c_info.Position,'x','color','red','size',10);
hold on
imshow(RGB)


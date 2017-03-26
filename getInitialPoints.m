
function getInitialPoints(fig,image)

dcm_obj = datacursormode(fig);
set(dcm_obj,'DisplayStyle','window',...
    'SnapToDataVertex','off','Enable','on')

disp('Click point ,then press Enter')
% Wait while the user does this.
pause 

c_info = getCursorInfo(dcm_obj);
% % Make selected line wider
%  set(c_info.Target,'LineWidth',2) 
I = imread(image);
RGB = insertMarker(I,c_info.Position,'x','color','red','size',10);
hold on
imshow(RGB)
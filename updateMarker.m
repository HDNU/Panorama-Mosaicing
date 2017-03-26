function RGB=updateMarker(RGB,fig,color)
dcm_obj = datacursormode(fig);
set(dcm_obj,'DisplayStyle','window',...
    'SnapToDataVertex','off','Enable','on')

disp('Click point, then press Enter.')
% Wait while the user does this.
pause

c_info = getCursorInfo(dcm_obj);
position=c_info.Position;
RGB = insertMarker(RGB,position,'*','color',color,'size',20);
global pointArray;
position
pointArray{length(pointArray)+1}=position;
hold on
imshow(RGB)

end
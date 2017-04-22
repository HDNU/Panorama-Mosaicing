function varargout = panorama(varargin)
% PANORAMA MATLAB code for panorama.fig
%      PANORAMA, by itself, creates a new PANORAMA or raises the existing
%      singleton*.
%
%      H = PANORAMA returns the handle to a new PANORAMA or the handle to
%      the existing singleton*.
%
%      PANORAMA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PANORAMA.M with the given input arguments.
%
%      PANORAMA('Property','Value',...) creates a new PANORAMA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before panorama_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to panorama_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help panorama

% Last Modified by GUIDE v2.5 21-Apr-2017 17:01:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @panorama_OpeningFcn, ...
                   'gui_OutputFcn',  @panorama_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before panorama is made visible.
function panorama_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to panorama (see VARARGIN)

% Choose default command line output for panorama
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes panorama wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = panorama_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
global leftImage rightImage;
varargout{1} = handles.output;
leftImage = imread('CMU_left.jpg');
axes(handles.leftImage);
imshow(leftImage);

rightImage = imread('CMU_right.jpg');
axes(handles.rightImage);
imshow(rightImage);

global homography;
global w;
global tform;


% --- Executes on button press in pickLeftImagePushButton.
function pickLeftImagePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to pickLeftImagePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global leftImage;
[path, Cancel] = imgetfile();
if Cancel
    msgbox(sprintf('Error'),'Error','Error');
    return
end
leftImage = imread(path);
axes(handles.leftImage);
imshow(leftImage);


% --- Executes on button press in pickRightImagePushButton.
function pickRightImagePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to pickRightImagePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rightImage;
[path, Cancel] = imgetfile();
if Cancel
    msgbox(sprintf('Error'),'Error','Error');
    return
end
rightImage = imread(path);
axes(handles.rightImage);
imshow(rightImage);


% --- Executes on button press in pickLeft.
function pickLeft_Callback(hObject, eventdata, handles)
% hObject    handle to pickLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fig=figure;
global leftImage;
RGB= leftImage;
imshow(leftImage);
global pointArray;
pointArray={};

RGB=updateMarker(RGB,fig,'cyan');
RGB=updateMarker(RGB,fig,'red');
RGB=updateMarker(RGB,fig,'yellow');
RGB=updateMarker(RGB,fig,'blue');
close;
axes(handles.leftImage);
imshow(RGB);


% --- Executes on button press in pickRight.
function pickRight_Callback(hObject, eventdata, handles)
% hObject    handle to pickRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fig=figure;
global rightImage;
RGB= rightImage;
imshow(rightImage);
global pointArray;
pointArray=pointArray(1:4);

RGB=updateMarker(RGB,fig,'cyan');
RGB=updateMarker(RGB,fig,'red');
RGB=updateMarker(RGB,fig,'yellow');
RGB=updateMarker(RGB,fig,'blue');
close;
axes(handles.rightImage);
imshow(RGB);



% --- Executes on button press in printPoints.
function printPoints_Callback(hObject, eventdata, handles)
% hObject    handle to printPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pointArray;
for i=1:1:8
    pointArray{i}
end


% --- Executes on button press in computeHomography.
function computeHomography_Callback(hObject, eventdata, handles)
% hObject    handle to computeHomography (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global homography;
homography=returnHomography();
figure;
t = uitable();
drawnow;
set(t, 'Data', homography)


% --- Executes on button press in projectLtoR.
function projectLtoR_Callback(hObject, eventdata, handles)
% hObject    handle to projectLtoR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global homography leftImage;
homography=returnHomography();
t = projective2d(homography');
imOut = imwarp(leftImage,t);
figure
imshow(imOut);


% --- Executes on button press in panoramaByHandInitialization.
function panoramaByHandInitialization_Callback(hObject, eventdata, handles)
% hObject    handle to panoramaByHandInitialization (see GCBO)
% eventdata  reservedlk m - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global homography;
homography=returnHomography();
panoramaByHand();


% --- Executes on button press in panoramaByMSAC.
function panoramaByMSAC_Callback(hObject, eventdata, handles)
% hObject    handle to panoramaByMSAC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
panoramaByMSAC();

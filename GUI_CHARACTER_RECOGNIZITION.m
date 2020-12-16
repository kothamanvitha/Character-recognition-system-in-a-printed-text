
function varargout = GUI_CHARACTER_RECOGNIZITION(varargin)
% GUI_CHARACTER_RECOGNIZITION MATLAB code for GUI_CHARACTER_RECOGNIZITION.fig
%      GUI_CHARACTER_RECOGNIZITION, by itself, creates a new GUI_CHARACTER_RECOGNIZITION or raises the existing
%      singleton*.
%
%      H = GUI_CHARACTER_RECOGNIZITION returns the handle to a new GUI_CHARACTER_RECOGNIZITION or the handle to
%      the existing singleton*.
%
%      GUI_CHARACTER_RECOGNIZITION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CHARACTER_RECOGNIZITION.M with the given input arguments.
%
%      GUI_CHARACTER_RECOGNIZITION('Property','Value',...) creates a new GUI_CHARACTER_RECOGNIZITION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_CHARACTER_RECOGNIZITION_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_CHARACTER_RECOGNIZITION_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_CHARACTER_RECOGNIZITION

% Last Modified by GUIDE v2.5 06-Sep-2019 18:38:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_CHARACTER_RECOGNIZITION_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_CHARACTER_RECOGNIZITION_OutputFcn, ...
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


% --- Executes just before GUI_CHARACTER_RECOGNIZITION is made visible.
function GUI_CHARACTER_RECOGNIZITION_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_CHARACTER_RECOGNIZITION (see VARARGIN)

% Choose default command line output for GUI_CHARACTER_RECOGNIZITION
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_CHARACTER_RECOGNIZITION wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_CHARACTER_RECOGNIZITION_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press to insert image
function pushbutton1_Callback(hObject, eventdata, handles)

% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
insert_image=uigetfile('.png')
Image=imread(insert_image);
axes(handles.axes2);
imshow(Image);
setappdata(0,'Image',Image)

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
matrix=[];
for im=1:260
    im_string=strcat('char_',num2str(im),'.png');
    image=imread(im_string);%Read character images(small and capital letters)
    im_rgbtogray=rgb2gray(image);%Convert all the images to gray images
    Bi=im2bw(im_rgbtogray,0.4);%Convert all the images to binary images
    Resize=imresize(Bi,[32 32]);%resize the images to 32X32
    Vector=Resize(1:1024);%Resizing the character images to 1X1024
    matrix(im,:)=Vector;
end
save('output_file.mat','matrix');
basic_list=['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']
training_list=[];count=0;
for i=1:26
    for j=1:5
        count=count+1;
        training_list(:,count)=basic_list(i);
    end
    
    for k=1:5
        count=count+1;
        training_list(:,count)=lower(basic_list(i));
    end
end
t_list=char(training_list)
%mdl=fitcknn(matrix,t_list)
X=matrix;
Y=t_list';
Mdl = fitcknn(X,Y,'NumNeighbors',5)
%Testing phase
img=getappdata(0,'Image');
mkdir('test_newletters');

i=rgb2gray(img);
f=imcomplement(i);
level=graythresh(f);
f1=im2bw(f,level);
% figure
% imshow(f1);
%f2=imdilate(f1,strel('disk',2));
%figure
%imshow(f2);
a=sum(f1);
% figure
% plot(a);
temp=[(a~=0)];
g=[0 temp];
h=[temp 0];
gaps=xor(g,h);
[pox,poy]=find(gaps==1)
display(length(poy))
test_matrix=[];
character_array=[];
for j=1:2:length(poy)
    ext=i(:,poy(j):poy(j+1)-1)
    t_bin=im2bw(ext,0.41);
    Resize=imresize(t_bin,[32 32]);
    vector=Resize(1:1024);
    test_matrix(floor(j/2)+1,:)=vector;
    
%     figure
%     imshow(ext);
end
for k=1:2:length(poy)
    test_vector=test_matrix(floor(k/2)+1,:);
    flwrClass=predict(Mdl,test_vector)
    set(handles.text2,'String',flwrClass);
    
    character_array(:,floor(k/2)+1)=flwrClass
end
% myFolder = 'C:\CHARACTER RECOGNITION\char_images\test_newletters';
% display('MANVITHA')
% if ~isdir(myFolder)
%   errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
%   uiwait(warndlg(errorMessage));
%   return;
% end
% filePattern = fullfile(myFolder, '*.jpg');
% jpegFiles = dir(filePattern);
% display(length(jpegFiles))
% test_matrix=[];
% for k = 1:length(jpegFiles)
%   baseFileName = jpegFiles(k).name;
%   fullFileName = fullfile(myFolder, baseFileName);
%   %fprintf(1, 'Now reading %s\n', fullFileName);
%   imageArray = imread(fullFileName);
%   
%   Bi=im2bw(imageArray,0.5);
%   Resize=imresize(Bi,[32 32]);
%   vector=Resize(1:1024);
%   test_matrix(k,:)=vector;
%    % Display image.
%   drawnow; % Force display to update immediately.
% end
% character_array=[]
% for l=1:length(jpegFiles)
%     test_vector=test_matrix(l,:);
%     flwrClass=predict(Mdl,test_vector)
% %     set(handles.text2,'String',flwrClass);
%     
%     character_array(:,l)=flwrClass
% end
 set(handles.text2,'String',char(character_array));
 display(char(character_array));

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2,'String'," ")
cla(handles.axes2,'reset')
% set(handles.axes2,'Visible','off')



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%==========================================================================
function varargout = testPrint(varargin)
%==========================================================================
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testPrint_OpeningFcn, ...
                   'gui_OutputFcn',  @testPrint_OutputFcn, ...
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



%==========================================================================
function testPrint_OpeningFcn(hObject, eventdata, handles, varargin)
%==========================================================================
handles.output = hObject;
set(handles.figure1, 'Color', [0.702 0.851 1.0]);
set(hObject,'toolbar','figure')
fid = fopen('platmobil.txt','r');
mydata = cell(1,1);
mydata{1} = fgetl(fid);
%sip=fread(fid, 10);
fclose(fid);
set(handles.txtPrint,'string',mydata{1});
guidata(hObject, handles);

%==========================================================================
function varargout = testPrint_OutputFcn(hObject, eventdata, handles) 
%==========================================================================

varargout{1} = handles.output;



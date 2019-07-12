function varargout = deteksiplatmobil(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @deteksiplatmobil_OpeningFcn, ...
                   'gui_OutputFcn',  @deteksiplatmobil_OutputFcn, ...
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


function deteksiplatmobil_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

function varargout = deteksiplatmobil_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%deteksi karakter 
function cmdDeteksi_Callback(hObject, eventdata, handles)
%thinning
itin=bwmorph(f,'thin',inf);
[row,col]=size(itin);

%look-up tabel
function [c,lut] = thin(a)
lut = [];
if (isempty(a))
c = zeros(size(a));
return;
end
G1 = uint8(lutthin1);
G2 = uint8(lutthin2);
G3 = uint8(lutthin3);
G4 = uint8(lutthin4);
lutlut = 1:512;
lookup = applylut(a, lutlut);
% Preallocate a uint8 zeros matrix
d = uint8(0);
[m,n] = size(a);
d(m,n) = 0;
% First subiteration
d(:) = G1(lookup) & G2(lookup) & G3(lookup);
c = a & ~d;
% Second subiteration
lookup = applylut(c, lutlut);
d(:) = G1(lookup) & G2(lookup) & G4(lookup);
c = c & ~d;

%blocking
fun=inline('size((find(x==1)),1)');
Iblok=blkproc(itin,[ceil(row/6) ceil(col/4)],fun);

%menghitung jarak terdekat
for i=1:length(hrf);
hrff=cell2mat(hrf(i))
sell=abs(Iblok-hrff);
d=sell.*sell;
d=sum(sum(d));
jarak(i)=sqrt(d);
end

%menginterpretasi hasil deteksi karakter
for k=1:L
Iblok=cell2mat(CellCrop(k));
abjad=dicoba(Iblok);
tampil(k)=abjad;
akhir(k)=char(tampil(k));
end


%Browse File
function cmdBrowse_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile({'*.jpg';'*.bmp';'*.tif';});
image = imread([pathname filename]);
handles.plat = plat;
axes(handles.plat);
imshow(image);
handles.output = hObject;
guidata(hObject, handles);

if ~ischar(filename) %on cancel press
    errordlg('Error!','File Belum Dipilih!'); %on cancel press writes this error message
   return;
end

function cmdPrint_Callback(hObject, eventdata, handles)


function txtUsername_Callback(hObject, eventdata, handles)
function txtUsername_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function txtPass_Callback(hObject, eventdata, handles)
function txtPass_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function cmdLogin_Callback(hObject, eventdata, handles)
data1 = get(handles.txtUsername,'String');
data2 = get(handles.txtPass,'String');
%data login
isi1 = 'platmobil';
isi2 = 'coba';

banding1 = strcmp(data1, isi1);
banding2 = strcmp(data2, isi2);

if(banding1==1) 
    if(banding2==1)
        set(handles.cmdLogin, 'Visible', 'off');
        set(handles.cmdCancel, 'Visible', 'off');
        set(handles.uipanellogin, 'Visible', 'off');
        
        set(handles.uipanel1, 'Visible', 'on');
        set(handles.uipanel2, 'Visible', 'on');
        set(handles.uipanel3, 'Visible', 'on');
        set(handles.cmdBrowse, 'Visible', 'on');
        set(handles.cmdDeteksi, 'Visible', 'on');
        set(handles.cmdPrint, 'Visible', 'on');
        set(handles.hasil, 'Visible', 'on');
        set(handles.cmdPisah, 'Visible', 'on');        
    elseif(banding2==0)
        set(handles.message, 'Visible', 'on');
        set(handles.OK, 'Visible', 'on');
        set(handles.peringatan, 'Visible', 'on');
        set(handles.peringatan, 'String', 'Password Anda Salah!');
    end
elseif(banding1==0)
    if(banding2==1)
        set(handles.message, 'Visible', 'on');
        set(handles.OK, 'Visible', 'on');
        set(handles.peringatan, 'Visible', 'on');
        set(handles.peringatan, 'String', 'Username Anda Salah!');
    elseif(banding2==0)
         set(handles.message, 'Visible', 'on');
         set(handles.OK, 'Visible', 'on');
         set(handles.peringatan, 'Visible', 'on');
         set(handles.peringatan, 'String', 'Username dan Password Anda Salah!');
    end
end

function cmdCancel_Callback(hObject, eventdata, handles)
set(handles.txtUsername,'String', ' ');
set(handles.txtPass,'String', ' ');

function OK_Callback(hObject, eventdata, handles)
set(handles.message, 'Visible', 'off');
set(handles.OK, 'Visible', 'off');
set(handles.peringatan, 'Visible', 'off');


function cmdPisah_Callback(hObject, eventdata, handles)
%praproses
Igray = rgb2gray(I);%grayscaling
%figure,imshow(Igray)
Ibw = im2bw(Igray,graythresh(Igray));%thresholding
%figure,imshow(Ibw)

%nilai greythresh dicari dengan metode otsu
num_bins = 256;
counts = imhist(I,num_bins);
p = counts / sum(counts);
omega = cumsum(p);
mu = cumsum(p .* (1:num_bins)');
mu_t = mu(end);
state = warning;
warning off;
sigma_b_squared = (mu_t * omega - mu).^2 ./ (omega .* (1 - omega));
maxval = max(sigma_b_squared);
if isfinite(maxval)
idx = mean(find(sigma_b_squared == maxval));
% Normalize the threshold to the range [0, 1].
level = (idx - 1) / (num_bins - 1);
else
level = 0.0;
end

%fill 
Ifill= imfill(Ibw,'holes');
%figure,imshow(Ifill)
if do_fillholes
marker = I;
idx = cell(1,ndims(I));
 for k = 1:ndims(I)
 idx{k} = 2:(size(I,k) - 1);
 end
    if ~islogical(marker)
    marker(idx{:}) = Inf;
    else
    marker(idx{:}) = 1;
    end
I2=imcomplement(imreconstruct(imcomplement(marker),imcomplement(I),conn));
else
mask = imcomplement(I);
marker = mask;
marker(:) = 0;
marker(locations) = mask(locations);
marker = imreconstruct(marker, mask, conn);
I2 = I | marker;
end

%memberi label pada objek
[Ilabel num] = bwlabel(Ifill,8);
Iprops=regionprops(Ilabel);
if (isempty(labels))
numLabels = 0;
else
numLabels = max(labels);
end

%untuk memisahkan label dengan matrix 
tmp = (1:numLabels)';
A = sparse([i;j;tmp], [j;i;tmp], 1, numLabels, numLabels);
[p,p,r] = dmperm(A);
sizes = diff(r);
numComponents = length(sizes); 
blocks = zeros(1,numLabels);
blocks(r(1:numComponents)) = 1;
blocks = cumsum(blocks);
blocks(p) = blocks;
labels = blocks(labels);
L = bwlabel2(sr, er, sc, labels, M, N);

%untuk mencari koordinat objek
Ibox21=[Iprops.BoundingBox]
Ibox21=reshape(Ibox2,[4 num2]);
%mendeteksi batas tinggi
[r,c]=size(Ibw);
kandi=find(Ibox1(4,:)>(0.47*r));
Ibox21=Ibox1(:,kandi);
%mendeteksi batas lebar
buang=find(Ibox21(3,:)>(0.9*c));
%mencari tinggi huruf rata-rata
verti=Ibox21(4,buang);
ting=Ibox21(4,:);
ting(buang)=[];
tinggistandar=ting;
rata2=mean(tinggistandar);
%memisahkan huruf dan garis
Ibox22=misah(Ibox21,buang,rata2);
Ibox23=imcrop(Ibw,Ibox22);
Ib=labeling_new(Ibox23);
[er,ce]=size(Ibox23);
kandid=find(Ib(4,:)>(0.47*er));
Ibox2=Ib(:,kandid);
%mencari lebar huruf rata-rata
[nilai posisis]=max(Ibox2(3,:));
lebarstandar=mean(Ibox2(3,:));
sel=(nilai)-(lebarstandar);
if sel > (nilai/3)
buanglagi=(posisis);
else
buanglagi=[]
end

%untuk memisahkan dua huruf
if isempty(buanglagi)==1
Ibox3=Ibox2;
else
Ibox3=pisah(Ibox2,lebarstandar);
end



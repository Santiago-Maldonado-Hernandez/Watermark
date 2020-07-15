%% Task 1 
% Mark image_x.jpg using a watermark included in the image image_y.jpg 
% and the MLS sequence c.mat.  

% Load the MLS (maximal lenght sequence) pseudo-random sequence of 63 
% bits {0,1}
load 'c';

% Read and convert the imgaes to double
image_xd = double(imread('image_x.jpg'));
image_yd = double(imread('image_y.jpg'));

% Normalize image_xd
imagex = image_xd/256;

% Threeshold up to 100 and normalize image_yd
imagey = zeros(size(image_yd)); 
index_1 = image_yd>100;
imagey(index_1) = 1; 

% Attenutation factor 
k=0.01;

% Size parameters 
[q, w] = size(imagex);
[e, r] = size(imagey);
[s, ~] = size(c);

L_imageX = q*w;
L_imageY = e*r;
L_exp = L_imageY*s; 

% Reshape vectors to 1-line vectors
imagex_vector = reshape(imagex, [1, L_imageX]);
imagey_vector = reshape(imagey, [1, L_imageY]);
c_vector = reshape(c, [1, s]);

% Build a zero-vector same size as the expanded vector 
water_mark = zeros(1, L_exp);

% Loop to obtein the expanded vector
for i=1:L_imageY
    for j=1:s
        water_mark(((i-1)*s)+j)=imagey_vector(i)*c_vector(j);
    end
end 

% Add the expanded image to the original
R = L_imageX-L_exp;
marked_image = imagex_vector + k*[water_mark zeros(1, R)];

% Reshape the marked image size to 'image_x.jpg' size 
marked_image = reshape(marked_image, [q w]);

% Show the images
subplot(2, 1, 1);
imagesc(imagey);
title('Image Y');

subplot(2, 1, 2);
imagesc(marked_image);
title('Marked image')

colormap('gray');

% Write the marked image to a .jpg file
imwrite(marked_image, 'Marked_image.jpg');

pause;

%% Task 2
% Watermark detection.

% detection(filename1, a, b, c) 
% Function that detects a watermark from a .jpg file
% Input parameters:
% filename: Marked image
% c: pseudo-random sequence used to expand
% output parameters:
% w_mark: watermark detected

w_mark = detection('Marked_image.jpg', c);
pause; 


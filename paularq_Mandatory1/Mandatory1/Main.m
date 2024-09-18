clc;   % Clear the command window.
clear; % Erase all existing variables.
close all; % Close all figures.

% Here we read the 2 mosaics 
mosaic1 = imread('mosaic1.png');
mosaic2 = imread('mosaic2.png');

% Normalize the images
grayscale = 16; % grayscale levels
mosaic1 = histeq(mosaic1, grayscale); % Improve the contrast 
% Round each element to the nearest integer
mosaic1 = uint8(round(double(mosaic1)*(grayscale - 1)/double(max(mosaic1(:)))));
mosaic2 = histeq(mosaic2, grayscale); % Improve the contrast 
% Round each element to the nearest integer
mosaic2 = uint8(round(double(mosaic2)*(grayscale - 1)/double(max(mosaic2(:)))));

% Divide the mosaic into different area that will represent the differents
% textures
[N,M] = size(mosaic1);
M1Area1 = mosaic1(1:N/2, 1:M/2);
M1Area2 = mosaic1(1:N/2, M/2+1:M);
M1Area3 = mosaic1(N/2+1:N, 1:M/2);
M1Area4 = mosaic1(N/2+1:N, M/2+1:M);
M2Area1 = mosaic2(1:N/2, 1:M/2);
M2Area2 = mosaic2(1:N/2, M/2+1:M);
M2Area3 = mosaic2(N/2+1:N, 1:M/2);
M2Area4 = mosaic2(N/2+1:N, M/2+1:M);

% Display of textures for mosaic 1
d = 3; % delta
theta = -45; % angle
m1t1 = GLCM(M1Area1, grayscale, d, theta);
m1t2 = GLCM(M1Area2, grayscale, d, theta);
m1t3 = GLCM(M1Area3, grayscale, d, theta);
m1t4 = GLCM(M1Area4, grayscale, d, theta);

figure(1);
subplot(2, 2, 1);
imagesc(m1t1), colorbar, title('GLCM texture 1');
subplot(2, 2, 2);
imagesc(m1t2), colorbar, title('GLCM texture 2');
subplot(2, 2, 3);
imagesc(m1t3), colorbar, title('GLCM texture 3');
subplot(2, 2, 4);
imagesc(m1t4), colorbar, title('GLCM texture 4');

% Display of textures for mosaic 2
d = 4; % delta
theta = 90; % angle
m2t1 = isoGLCM(M2Area1, grayscale, d);
m2t2 = isoGLCM(M2Area2, grayscale, d);
m2t3 = isoGLCM(M2Area3, grayscale, d);
m2t4 = isoGLCM(M2Area4, grayscale, d);

figure(2);
subplot(2, 2, 1);
imagesc(m2t1), colorbar, title('GLCM texture 1');
subplot(2, 2, 2);
imagesc(m2t2), colorbar, title('GLCM texture 2');
subplot(2, 2, 3);
imagesc(m2t3), colorbar, title('GLCM texture 3');
subplot(2, 2, 4);
imagesc(m2t4), colorbar, title('GLCM texture 4');

% Getting the feature images
windowSize = 31;
d=3;
theta=-45;
[IDM1, INR1, SHD1] = glidingGLCM(mosaic1, grayscale, d, theta, windowSize, 0);

d=4;
theta=90;
[IDM2, INR2, SHD2] = glidingGLCM(mosaic2, grayscale, d, theta, windowSize, 1);

figure(3)
colormap jet
subplot(2,2,1)
imagesc(IDM1), colorbar, title('GLCM homogeneity mosaic 1');
subplot(2,2,2)
imagesc(INR1), colorbar, title('GLCM inertia mosaic 1');
subplot(2,2,3)
imagesc(SHD1), colorbar, title('GLCM cluster shade mosaic 1');

figure(4)
colormap jet
subplot(2,2,1)
imagesc(IDM2), colorbar, title('GLCM homogeneity mosaic 2');
subplot(2,2,2)
imagesc(INR2), colorbar, title('GLCM inertia mosaic 2');
subplot(2,2,3)
imagesc(SHD2), colorbar, title('GLCM cluster shade mosaic 2');

% Applying global threshold to the GLCM feature images
% Values chosen manually in order to have the best separation between the textures
% Mosaic 1
figure(5)
colormap gray
subplot(2,2,1)
imagesc(INR1.*(INR1 <= 49 & INR1 >= 31)), title('Inertia mosaic 1 Threshold: 30 < T < 50');
subplot(2,2,2)
imagesc(INR1.*(INR1 <= 30)), title('Inertia mosaic 1 Threshold: 0 < T < 31');
subplot(2,2,3)
imagesc(INR1.*(INR1 <= 70 & INR1 >= 50)), title('Inertia mosaic 1 Threshold: 49 < T < 71');

figure(6)
colormap gray
subplot(2,2,1)
imagesc(SHD1.*(SHD1 <= -20000 & SHD1 >= -1000000)), title('Cluster Shade mosaic 1 Threshold: -1000000 < T < -20000');
subplot(2,2,2)
imagesc(SHD1.*(SHD1 >= -19000)), title('Cluster Shade mosaic 1 Threshold: -19000 < T');
% Mosaic 2
figure(7)
colormap gray
subplot(2,2,1)
imagesc(INR2.*(INR2 <= 49 & INR2 >= 31)), title('Inertia mosaic 2 Threshold: 30 < T < 50');
subplot(2,2,2)
imagesc(INR2.*(INR2 <= 30)), title('Inertia mosaic 2 Threshold: 0 < T < 31');
subplot(2,2,3)
imagesc(INR2.*(INR2 <= 70 & INR2 >= 50)), title('Inertia mosaic 2 Threshold: 49 < T < 71');

figure(8)
colormap gray
subplot(2,2,1)
imagesc(SHD2.*(SHD2 <= -200000 & SHD2 >= -1000000)), title('Cluster Shade mosaic 2 Threshold: -100000 < T < -20000');
subplot(2,2,2)
imagesc(SHD2.*(SHD2 <= -200000)), title('Cluster Shade mosaic 2 Threshold: -200000 < T');

figure(9)
colormap gray
subplot(2,2,1)
imagesc(IDM2.*(IDM2 <= 0.25)), title('Homogeneity mosaic 2 Threshold: T < 0.25');
subplot(2,2,2)
imagesc(IDM2.*(IDM2 >= 0.26 & IDM2 <= 0.5)), title('Homogeneity mosaic 2 Threshold: 0.25 < T < 0.51');
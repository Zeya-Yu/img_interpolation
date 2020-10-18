% tv_img_interp.m
% Total variation image interpolation.
% EE364a
% Defines m, n, Uorig, Known.

% Load original image.
Uorig = double(imread('tv_img_interp.png'));

[m, n] = size(Uorig);

% Create 50% mask of known pixels.
rand('state', 1029);
Known = rand(m,n) > 0.5;

%%%%% Put your solution code here

% Calculate and define Ul2 and Utv.

% Placeholder:
Ul2 = ones(m, n);
Utv = ones(m, n);

% Calculate Ul2
cvx_begin
    variables Ul2(m,n)
    U1 = Ul2(2:end,2:end) - Ul2(1:(end-1),2:end)
    U2 = Ul2(2:end,2:end) - Ul2(2:end,1:(end-1))
    minimize(norm([U1(:) ; U2(:)],2))
    subject to
        Ul2(Known) == Uorig(Known)
cvx_end

%Calculate Utv
cvx_begin
    variables Utv(m,n)
    U1 = Utv(2:end,2:end) - Utv(1:(end-1),2:end)
    U2 = Utv(2:end,2:end) - Utv(2:end,1:(end-1))
    minimize(norm([U1(:) ; U2(:)],1))
    subject to
        Utv(Known) == Uorig(Known)
cvx_end

%%%%%

% Graph everything.
figure(1); cla;
colormap gray;

subplot(221);
imagesc(Uorig)
title('Original image');
axis image;

subplot(222);
imagesc(Known.*Uorig + 256-150*Known);
title('Obscured image');
axis image;

subplot(223);
imagesc(Ul2);
title('l_2 reconstructed image');
axis image;

subplot(224);
imagesc(Utv);
title('Total variation reconstructed image');
axis image;

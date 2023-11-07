% Import data
imageDir1 = 'path/to/camera1/images';
imageDir2 = 'path/to/camera2/images';

images1 = imageSet(fullfile(imageDir1));
images2 = imageSet(fullfile(imageDir2));

% Detect corners
imagePoints1 = [];
imagePoints2 = [];

for i = 1:numel(images1)
    img1 = imread(images1.ImageLocation{i});
    img2 = imread(images2.ImageLocation{i});
    
    corners1 = corner(rgb2gray(img1), 'Harris');
    corners2 = corner(rgb2gray(img2), 'Harris');
    
    % Assume matched corners have been found
    imagePoints1 = cat(3, imagePoints1, corners1');
    imagePoints2 = cat(3, imagePoints2, corners2');
end

% Generate world coordinates
squareSize = 25; % Chessboard square size, e.g., 25 millimeters
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calculate intrinsic parameters
params1 = estimateCameraParameters(imagePoints1, worldPoints, 'ImageSize', [size(images1, 1), size(images1, 2)]);
params2 = estimateCameraParameters(imagePoints2, worldPoints, 'ImageSize', [size(images2, 1), size(images2, 2)]);

% Calculate extrinsic parameters
% Use intrinsic parameters and feature matching results, here we use a simplified version of the epipolar geometry constraint method
% Assume the fundamental matrix F has been calculated
F = estimateFundamentalMatrix(imagePoints1(:,:,1), imagePoints2(:,:,1), 'Method', 'Norm8Point');

% Calculate the essential matrix E
K1 = params1.IntrinsicMatrix';
K2 = params2.IntrinsicMatrix';
E = K2' * F * K1;

% Calculate the rotation matrix R and translation vector T from the essential matrix E
[U, ~, V] = svd(E);

if det(U) < 0
    U(:,3) = -U(:,3);
end

if det(V) < 0
    V(:,3) = -V(:,3);
end

W = [0 -1 0; 1 0 0; 0 0 1];

R = U * W * V';
T = U(:,3);

% Construct the dual-view camera parameter structure
stereoParams = struct('CameraParameters1', params1, 'CameraParameters2', params2, 'RotationOfCamera2', R, 'TranslationOfCamera2', T);

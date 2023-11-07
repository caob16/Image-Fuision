% Load stereo images
leftImg = imread('图像1.jpg');
rightImg = imread('图像2.jpg');

% Step 1: Feature Detection and Matching using SURF features
leftPoints = detectSURFFeatures(rgb2gray(leftImg));
rightPoints = detectSURFFeatures(rgb2gray(rightImg));

[featuresLeft, validLeftPoints] = extractFeatures(rgb2gray(leftImg), leftPoints);
[featuresRight, validRightPoints] = extractFeatures(rgb2gray(rightImg), rightPoints);

indexPairs = matchFeatures(featuresLeft, featuresRight, 'Unique', true);
matchedLeftPoints = validLeftPoints(indexPairs(:, 1));
matchedRightPoints = validRightPoints(indexPairs(:, 2));

% Step 2: Homography Estimation using matched features
tform = estimateGeometricTransform(matchedRightPoints, matchedLeftPoints, 'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);

% Step 3: Image Warping
outputImageSize = [size(leftImg, 1), size(leftImg, 2)*2]; % This size can be modified based on overlap and scene.
warpedRightImg = imwarp(rightImg, tform, 'OutputView', imref2d(outputImageSize));

% Step 4: Image Blending/Fusion - Here, we'll use simple averaging
blendedImg = imfuse(leftImg, warpedRightImg, 'blend', 'Scaling', 'joint');

imshow(blendedImg);
title('Blended Image');
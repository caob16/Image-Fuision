function blendedImage = blendImages(image1, image2, tform, panoramaSize)
% BLENDIMAGES 使用加权平均法融合两张图像

% 计算图像1的权重图
weightImage1 = edge(rgb2gray(image1), 'Canny');
weightImage1 = imdilate(weightImage1, strel('disk', 5));
weightImage1 = bwdist(weightImage1);
weightImage1 = weightImage1 / max(weightImage1(:));

% 变换图像2的权重图
weightImage2 = edge(rgb2gray(image2), 'Canny');
weightImage2 = imdilate(weightImage2, strel('disk', 5));
weightImage2 = bwdist(weightImage2);
weightImage2 = weightImage2 / max(weightImage2(:));
weightImage2 = imwarp(weightImage2, tform, 'OutputView', imref2d(panoramaSize), 'FillValues', 0);

% 计算归一化权重
normalizedWeight1 = weightImage1 ./ (weightImage1 + weightImage2);
normalizedWeight2 = weightImage2 ./ (weightImage1 + weightImage2);

% 计算加权平均后的图像
blendedImage = zeros(panoramaSize, 'like', image1);
for c = 1:3
    blendedImage(:, :, c) = normalizedWeight1 .* double(image1(:, :, c)) + normalizedWeight2 .* double(imwarp(image2(:, :, c), tform, 'OutputView', imref2d(panoramaSize), 'FillValues', 0));
end
blendedImage = uint8(blendedImage);

end
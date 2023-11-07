function firstFramePos = fastLocation(startFrame, endFrame, video)
    % 获取帧率和持续时间
    frameRate = video.FrameRate;
    duration = video.Duration;

    % 计算帧数
    frameCount = round(frameRate * duration);

    % 计算根号2值
    frameInterval = round(sqrt(2) * (endFrame - startFrame));

    % 初始化变量
    prevFrame = [];
    currentFrameNumber = 1;
    isFirstFrame = true;
    firstFramePos = [];

    % 跳过视频直到自定义起始帧
    video.CurrentTime = (startFrame - 1) / frameRate;
    prevFrame = readFrame(video);
    currentFrameNumber = startFrame;

    % 处理视频
    while hasFrame(video) && currentFrameNumber <= endFrame
        % 跳过指定间隔的帧数
        for i = 1:frameInterval-1
            if hasFrame(video) && currentFrameNumber < endFrame
                readFrame(video);
                currentFrameNumber = currentFrameNumber + 1;
            end
        end

        % 读取下一帧并计算帧差
        if hasFrame(video) && currentFrameNumber < endFrame
            currentFrame = readFrame(video);
            currentFrameNumber = currentFrameNumber + 1;

            % 计算帧差
            diffFrame = imabsdiff(rgb2gray(prevFrame), rgb2gray(currentFrame));

            % 在此处处理帧差，例如进行阈值分割、轮廓检测等操作
            diffThresh = graythresh(diffFrame);
            binaryDiff = imbinarize(diffFrame, diffThresh);
            binaryDiff = bwareaopen(binaryDiff, 50);
            [labels, numLabels] = bwlabel(binaryDiff);

            if numLabels > 0 && isFirstFrame
                isFirstFrame = false;
                firstFramePos = currentFrameNumber;
            end

            % 更新前一帧
            prevFrame = currentFrame;
        end
    end
end
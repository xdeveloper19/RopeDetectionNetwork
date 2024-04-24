function [result] = train_model()
model = get_model();

mainPath = 'C:\\Users\\Daria\\Documents\\MATLAB\\workspace\\models\\';

prepare_workspace();

%load the rope ground truth data
data = load(model.path);
gTruth = data.gTruth;

% Add fullpath to the local rope data folder.
source = gTruth.DataSource.Source;

% Read one of the images.
I = imread(source{18});

% Insert the ROI labels.
I = insertShape(I, 'Rectangle', gTruth.LabelData.ROPE_WIRE{18});

% Resize and display image.
I = imresize(I,3);
figure
imshow(I)

%preraring training dataset
cds = objectDetectorTrainingData(gTruth)
%--------------DESIGN THE CONVOLUTIONAL NEURAL NETWORK (CNN)---------------
% Split data into a training and test set.
idx = floor(0.8 * height(cds));
trainingData = cds(1:idx,:);
testData = cds(idx:end,:); 

net = vgg16;
%-----------------------CONFIGURE TRAINING OPTIONS----------------------------------
% Options for step 1.
optionsStage1 = trainingOptions('sgdm', ...
    'MaxEpochs', 10, ...,
    'MiniBatchSize',1,...
    'InitialLearnRate', 1e-3, ...
    'CheckpointPath', tempdir, ...
     'VerboseFrequency', 200);

% Options for step 2.
optionsStage2 = trainingOptions('sgdm', ...
    'MaxEpochs', 10, ...
    'MiniBatchSize',1,...
    'InitialLearnRate', 1e-3, ...
    'CheckpointPath', tempdir, ...
     'VerboseFrequency', 200);

% Options for step 3.
optionsStage3 = trainingOptions('sgdm', ...
    'MaxEpochs', 10, ...
    'MiniBatchSize',1,...
    'InitialLearnRate', 1e-3, ...
    'CheckpointPath', tempdir, ...
     'VerboseFrequency', 200);

% Options for step 4.
optionsStage4 = trainingOptions('sgdm', ...
    'MaxEpochs', 10, ...
    'MiniBatchSize',1,...
    'InitialLearnRate', 1e-3, ...
    'CheckpointPath', tempdir, ...
     'VerboseFrequency', 200);

options = [
    optionsStage1
    optionsStage2
    optionsStage3
    optionsStage4
    ];
%----------------------TRAIN FASTER R-CNN OBJECT DETECTOR------------------
try
    nnet.internal.cnngpu.reluForward(1);
catch ME
end
% Set random seed to ensure example training reproducibility.
rng(0);
    
% Train Faster R-CNN detector. Select a BoxPyramidScale of 1.2 to allow
% for finer resolution for multiscale object detection.
detector = trainFasterRCNNObjectDetector(trainingData, net, options, ...
   'NegativeOverlapRange', [0 0.3], ...
   'PositiveOverlapRange', [0.6 1]);

time = string(datetime('now','Format','HH-mm-ss'));
date = string(datetime('now','Format','dd-MMM-uuuu'));
    %----------------------PREDICT DATA-----------------------------------------
% Read a test image.
for i = 1:height(testData)
   % Read the image.
   I = imread(testData.imageFilename{i});
        
   title('image for predict')
        
   % Run the detector.
   [bboxes, scores] = detect(detector, I);
        
   % Annotate detections in the image.
   if (isempty(bboxes))
       continue;
   end
   I = insertObjectAnnotation(I,'rectangle',bboxes, scores);
   figure
   imshow(I)
end
%----------------------EVALUATE THE TRAINED DETECTOR---------------------
% Run detector on each image in the test set and collect results.
resultsStruct = struct([]);
for i = 1:height(testData)   
% Read the image.
    I = imread(testData.imageFilename{i});
        
    title('image for predict')
    imshow(I)
        
    % Run the detector.
    [bboxes, scores, labels] = detect(detector, I);
        
    % Collect the results.
    resultsStruct(i).Boxes = bboxes;
    resultsStruct(i).Scores = scores;
    resultsStruct(i).Labels = labels;
end
    
% Convert the results into a table.
results = struct2table(resultsStruct);
zipPath = mainPath + model.name + date + '_' + time;
save(zipPath, 'detector', 'results');

% Extract expected bounding box locations from test data.
expectedResults = testData(:, 2:end);

% Evaluate the object detector using Average Precision metric.
[ap, recall, precision] = evaluateDetectionPrecision(results, expectedResults);

save_detector(zipPath,date + '_' + time, ap);

result = op;
    
% Plot precision/recall curve
figure
plot(recall,precision)
xlabel('Recall')
ylabel('Precision')
grid on
title(sprintf('Average Precision = %.2f', ap))
end


function [bboxes, scores] = detect(imgPath)
 % Read the image.
 I = imread(imgPath);
 title('image for predict')
        
 model = load('models\detector_23-Apr-2021_13-34-15.mat')
 % Run the detector.
 [bboxes, scores] = detect(model.detector, I);
        
 % Annotate detections in the image.
 if (isempty(bboxes))
     return;
 end
       
 I = insertObjectAnnotation(I,'rectangle',bboxes, scores);
 figure
 imshow(I)
end


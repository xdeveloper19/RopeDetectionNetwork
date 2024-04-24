function [bboxes, scores] = predict_model(imgPath)
 model = get_model();
 
 % Read the image.
 I = imread(imgPath);
 title('image for predict')
        
 model = load(model.zipPath);
 % Run the detector.
 [bboxes, scores] = detect(model.detector, I);
        
 % Annotate detections in the image.
 if (isempty(bboxes))
     return;
 end
 
 save_prediction(max(scores),imgPath);   
 
 I = insertObjectAnnotation(I,'rectangle',bboxes, scores);
 figure
 imshow(I)
end


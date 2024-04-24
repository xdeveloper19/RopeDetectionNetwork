function [message] = save_prediction(maxScore, path)
import matlab.net.*;
import matlab.net.http.*;

token = auth();

model = get_model();

httpUrl = URI('http://localhost:5000/api/MatlabObjectDetection/SavePrediction?modelId=' + model.id + '&maxScore=' + maxScore + '&filePath=' + path + '&predictedLabel=' + '');
json = '{"userName": "admin@mail.ru","userPassword": "Admin_123"}';

% Manually set Authorization header field in weboptions
opts = weboptions('HeaderFields',{'Authorization',...
    ['Bearer ' token]});

opts.Timeout = 25;
opts.MediaType = 'application/json';
response = webwrite(httpUrl, json, opts);

if (response.status == 'OK')
    message = 'Succeded.';
else message = 'Error occured.';
end


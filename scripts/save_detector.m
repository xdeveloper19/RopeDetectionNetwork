function [message] = save_detector(path, duration)
token = auth();

model = get_model();

httpUrl = URI('http://localhost:5000/api/MatlabObjectDetection/SaveDetector?modelId=' + model.id + '&zipPath=' + path + '&trainTime=' + duration);
json = '{"userName": "admin@mail.ru","userPassword": "Admin_123"}';

% Manually set Authorization header field in weboptions
opts = weboptions('HeaderFields',{'Authorization',...
    ['Bearer ' token]});

opts.Timeout = 25;
opts.MediaType = 'application/json';
response = webwrite(httpUrl, json, opts);

message = response.message;
end


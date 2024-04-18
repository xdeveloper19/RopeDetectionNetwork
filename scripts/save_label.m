function [message] = save_label(path)
import matlab.net.*;
import matlab.net.http.*;

token = auth();

model = get_model();

httpUrl = URI('http://localhost:5000/api/MatlabObjectDetection/SaveLabel?modelId=' + model.id + '&path=' + path);
json = '{"userName": "admin@mail.ru","userPassword": "Admin_123"}';

% Manually set Authorization header field in weboptions
opts = weboptions('HeaderFields',{'Authorization',...
    ['Bearer ' token]});

opts.Timeout = 25;
opts.MediaType = 'application/json';
response = webread(httpUrl, json, opts);

if (response.status == 'OK')
    message = '??????? ??????? ???????.';
else message = '?????? ???????';
end


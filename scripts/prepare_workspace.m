function [message] = prepare_workspace()
import matlab.net.*;
import matlab.net.http.*;

token = auth();

model = get_model();

httpUrl = URI('http://localhost:5000/api/matlabobjectdetection/prepareworkspace?modelId=' + model.id);
json = '{"userName": "admin@mail.ru","userPassword": "Admin_123"}';

% Manually set Authorization header field in weboptions
opts = weboptions('HeaderFields',{'Authorization',...
    ['Bearer ' token]});

opts.Timeout = 25;
opts.MediaType = 'application/json';
response = webread(httpUrl, json, opts);

if (response.status == 'OK')
    message = 'Success';
else message = 'Error';
    
end


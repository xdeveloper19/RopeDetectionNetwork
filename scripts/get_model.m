function [response] = get_model()
import matlab.net.*;
import matlab.net.http.*;

token = auth();

httpUrl = URI('http://localhost:5000/api/model/getactualmodel');
json = '{"userName": "admin@mail.ru","userPassword": "Admin_123"}';

% Manually set Authorization header field in weboptions
opts = weboptions('HeaderFields',{'Authorization',...
    ['Bearer ' token]});

opts.Timeout = 25;
opts.MediaType = 'application/json';
response = webread(httpUrl, json, opts);
end


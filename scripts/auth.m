function [token] = auth()
import matlab.net.*;
import matlab.net.http.*;

% authorize
httpUrl = URI('http://localhost:5000/api/auth/loginuser?username=admin@mail.ru&userpassword=Admin_123');
opts.Timeout = 25;
opts.MediaType = 'application/json';
response = webwrite(httpUrl, json, opts);
token = response.token;
end


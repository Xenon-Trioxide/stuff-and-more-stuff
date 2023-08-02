-- Working decompiler for Fluxus
-- do loadstring() then and decompiler:decompile(scriptpath)

local decompiler = {}
local open_ai_url = "https://free.churchless.tech/v1/chat/completions";
local api_key = "MyDiscord";
local http_service = game:GetService("HttpService");

local format = string.format;

local json_encode,json_decode = function(...)return http_service:JSONEncode(...)end,function(...)return http_service:JSONDecode(...)end;
local api = {}; do
    function get(url, ...)
        return request({Url=url,Method="GET"}).Body;
    end
    function post(...)
    	local post_args = ...;
        return request({
        	Url=open_ai_url,
        	Method="POST",
        	Headers={
        		["Content-Type"]="application/json",
        		["Authorization"]="MyDiscord",
        	},
        	Body=json_encode(post_args.body),
        })
    end

    api.get = get;
    api.post = post;
end

loadstring(api.get("https://raw.githubusercontent.com/Xenon-Trioxide/stuff-and-more-stuff/main/Disassembler.lua"))()

function decompiler:decompile(path)
    local res = post({
        body={
            ["model"]="gpt-3.5-turbo",
            ["messages"]={
            	[1] = {
                	["role"]="user",
                	["content"]=format("%s\n```lua\n%s\n```", "convert these luau instructions into readable luau code and simplify it.", disassemble(path))
                }
            }
        }
    });
    
    local decoded_response = json_decode(res.Body);
    local real_res = (decoded_response.choices and decoded_response.choices[1].message.content or "failed to decompile");
	
    return real_res;
end
return decompiler

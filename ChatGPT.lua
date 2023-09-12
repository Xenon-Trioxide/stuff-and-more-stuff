local HTTP = game:GetService("HttpService")
local module = { -- customizable parameters fpr chatgpt (can be changed anytime)
        endpoint = "https://ai.fakeopen.com/v1/chat/completions",
        key = "pk-this-is-a-real-free-pool-token-for-everyone",
        payload = {
                model = "gpt-3.5-turbo",
                messages = {
                        {
                                ["role"] = "system", 
                                ["content"] = "You are ChatGPT, a Large Language Model trained by OpenAI. Carefully heed the user's intructions."
                        }
                }
        },
        
        temperature = 1,
        max_tokens = 4000,
        top_p = 1,
        frequency_penalty = 0,
        presence_penalty = 0
        }
}

function module:MakeRequest() -- returns decoded completion message
        return HTTP:JSONDecode(request({
                Url = module.endpoint,
                Method = "POST",
                Headers = {
                        ["Content-Type"] = "application/json",
                        ["Authorization"] = module.key,
                },
                Body = HTTP:JSONEncode(module.payload)
        }))
end

function module:AddMessage(content,name,role) -- add custom message
        table.insert(module.payload.messages,{
                ["role"] = role or "user", 
                ["content"] = content,
                ["name"] = name or nil
        })
end

function module:NewChat(initialprompt) -- make/reset chat with optional initial prompt
        if initialprompt then
                module.payload.messages = {
                        {
                                ["role"] = "system",
                                ["content"] = initialprompt
                        }
                }
        else
                module.payload.messages = {}
        end
end

return module

local HTTP = game:GetService("HttpService")
local module = {
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
        max_tokens = 4000, --150
        top_p = 1,
        frequency_penalty = 0,
        presence_penalty = 0
        }
}

function module:MakeRequest()
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

function module:AddMessage(content,name,role)
        table.insert(module.payload.messages,{
                ["role"] = role or "user", 
                ["content"] = content,
                ["name"] = name or nil
        })
end

function module:NewChat(initialprompt)
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

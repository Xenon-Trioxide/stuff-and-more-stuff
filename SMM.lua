local keymodule = {}

local _, library = pcall(loadstring(game:HttpGet("https://raw.githubusercontent.com/XploitSDS/XploitHub/main/XPloitHubLibrary.lua")))
local http = game:GetService("HttpService")
local keydata = game:HttpGet("https://dev-xploitsds.pantheonsite.io/wp-json/wp/v2/pages/164")
local keyval = ""

function keymodule:CheckKey()
    local keycorrect = false
    if isfile("xploit-key.txt") and readfile("xploit-key.txt") == http:JSONDecode(keydata).content.rendered then 
        return true
    else
        local keywindow = library:CreateWindow("Please insert key")
        local keytab = keywindow:CreateTab("Key")
        local keyinput = keytab:CreateTextbox("Insert key", function(val)
            keyval = val
        end)
        local summit = keytab:CreateButton("Summit", function()
            print(string.sub(http:JSONDecode(keydata).content.rendered,4,35))
            if keyval == string.sub(http:JSONDecode(keydata).content.rendered,4,35) then
                keycorrect = true
                writefile("xploit-key.txt",keyval)
                keywindow:Destroy()
                
            else
          	    local keylabel = keytab:CreateLabel("Key invalid")
            end
        end)
    local copybutton, copyelement = keytab:CreateButton("Copy link",function()
    	setclipboard("https://link-target.net/854230/xploit-checkpoint-1")
    end)
    local urlbox, _, urlelement = keytab:CreateTextbox("Url (manual copy):",function()
    end,url)
    urlelement.ClearTextOnFocus = false
    urlelement.Text = "https://link-target.net/854230/xploit-checkpoint-1"
    
        repeat wait() until keycorrect
        print("works")
        return true
    end
end
return keymodule

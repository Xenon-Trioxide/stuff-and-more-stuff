local keymodule = {}

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/Libraries/normal/quake/src"))()
local http = game:GetService("HttpService")
local keydata = game:HttpGet("https://dev-xploitsds.pantheonsite.io/wp-json/wp/v2/pages/164")
local keyval = ""

function CheckMobile()
    if game:GetService("UserInputService").MouseEnabled and not game:GetService("UserInputService").TouchEnabled then
        return false
    else return true end
end

local test = false

function keymodule:CheckKey()
    local keycorrect = false
    if isfile("xploit-key.txt") and readfile("xploit-key.txt") == string.sub(http:JSONDecode(keydata).content.rendered,4,35) and not test then 
		return true
    else
        local keywindow = library:Window({
			Title = "Please enter key!",
			isMobile = CheckMobile(),
			Size = {
				X = 550,
				Y = 400
			},
			CustomTheme = { -- [OPTIONAL]
				defaultTab = Color3.fromHex("ffb144"),
				background = Color3.fromRGB(30,30,30),
				secondaryBackground = Color3.fromRGB(35,35,35),
				tertiaryBackground = Color3.fromRGB(25,25,25),
				text = Color3.fromRGB(255,255,255),
				image = Color3.fromRGB(225,225,225),
				placeholder = Color3.fromRGB(225,225,225),
				close = Color3.fromRGB(190, 100, 105)
			},
			KeyCode = Enum.KeyCode.RightAlt
		})
        local keytab = keywindow:Tab({
			Name = "Key",
			Image = "rbxassetid://6031082533"
		})
		local keyinput = keytab:TextBox({
			Name = "Insert key",
			Callback = function(val)
				keyval = val
			end
		})
		local submit = keytab:Button({
			Name = "Submit",
			Callback = function()
				if keyval == string.sub(http:JSONDecode(keydata).content.rendered,4,35) then
					keycorrect = true
					writefile("xploit-key.txt",keyval)
					for i,v in pairs(game.CoreGui:GetChildren()) do
						if string.find(v.Name,"Please enter key!") then
							v:Destroy()
						end
					end
					
				else
					local keylabel = keytab:Label("Key invalid")
				end
			end
		})
		local copybutton = keytab:Button({
			Name = "Copy link",
			Callback = function()
				setclipboard("https://lootdest.org/s?00efc826")
			end
		})
    
        repeat wait() until keycorrect
        print("key correct")
        return true
    end
end

return keymodule

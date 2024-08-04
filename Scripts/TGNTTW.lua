local nokey = false --Change this to true to remove key system

local SERVICES = {
	VIM_S = game:GetService("VirtualInputManager"),
	RUN_S = game:GetService("RunService"),
	TELEPORT_S = game:GetService("TeleportService")
}

local quake = loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/Libraries/normal/quake/src"))()

local plr = game.Players.LocalPlayer
local games = { -- gameid = name, startplaceid
	["6211067578"] = {"The Games","18320910606"},
	["5156590883"] = {"Watermelon GO","14970015233"},
	["111958650"] = {"Arsenal", "286090429"},
}
local Shines_EVENTS = {}
local Silver_EVENTS = {}

function CheckMobile()
    if game:GetService("UserInputService").MouseEnabled and not game:GetService("UserInputService").TouchEnabled then
        return false
    else return true end
end

local FUNCTIONS = {}
local numname = {"One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Zero"}
function FUNCTIONS:GetInvSlot(itemname)
	hotbar = game:GetService("CoreGui").RobloxGui.Backpack.Hotbar
	for i,v in pairs(hotbar:GetChildren()) do
		if v.ToolName.Text == itemname then
			return numname[tonumber(v.Name)]
		end
	end
end

function FUNCTIONS:PressKey(keycode, delay)
	SERVICES.VIM_S:SendKeyEvent(true, keycode, false, game)
	wait(delay or .01)
	SERVICES.VIM_S:SendKeyEvent(false, keycode, false, game)
end


function main()
	local window = quake:Window({
		Title = "The Games: No Time To Waste",
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
	
	Home_T = window:Tab({
		Name = "Home",
		Image = "rbxassetid://6026568198"
	})
	
	Games_T = window:Tab({
		Name = "The hub",
		Image = "rbxassetid://6034848748"
	})
	
	Home_T:Label("Welcome to The Games event!")
	Home_T:Paragraph({
		Title = "[2/8/2024] Welcome to The Games event!",
		Body = [[
			
			There's so many things to do in The Games event, but don't you think there's too many? In order to complete the event, you will need to collect 1,310 of these silver coins. If you were to collect all 60 silver coins per game, you would still need to visit 22 games out of the 50, and that is a lot.
	
			But Code_Xploit is here to save the day. Introducing The Games: No Time To Waste - a collection of exploits that will complete the event for you! Simply hop into a game and run the script, you will be done in no time!

			This script currently supports:
				- The Games (hub)
				- Watermelon Go
				- Arsenal
	
			I will be actively working on adding more games for the duration of this event. Be sure to stay tuned and Happy Xploiting!
		]]
	})
	Home_T:Paragraph({
		Title = "Credits",
		Body = [[
	
			Scripting: Code_Xploit
			https://youtube.com/@xploitsds
	
			GUI: Quake by idonthaveoneatm (Github)
			https://github.com/idonthaveoneatm/Libraries/blob/normal/quake
		]]
	})
	
	-- Games
	Games_T:Label("Here you can teleport to supported games! More games will be added soon!")
	
	
	if games[tostring(game.GameId)] then
		Games_T:Label("You are currently in "..games[tostring(game.GameId)][1].." (supported!)")

		local urlizedgamename = games[tostring(game.GameId)][1]
		if string.find(games[tostring(game.GameId)][1]," ") then
			urlizedgamename = games[tostring(game.GameId)][1]:gsub(" ","%%20")
		end
		local gamefunctions = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xenon-Trioxide/stuff-and-more-stuff/main/Scripts/The%20Games/"..urlizedgamename..".lua"))()
		--print(gamefunctions)
	
		-- Main
	
		-- Shines
		local Shines_T = window:Tab({
			Name = "Shines",
			Image = "rbxassetid://14738461299"
		})
		gamefunctions:LoadShines(plr, window, Shines_T, SERVICES, Shines_EVENTS, FUNCTIONS)
	
		-- Silver
		local Silver_T = window:Tab({
			Name = "Silver",
			Image = "rbxassetid://14738461299"
		})
		gamefunctions:LoadSilver(plr, window, Silver_T, SERVICES, Silver_EVENTS, FUNCTIONS)
	else
		Games_T:Label("You are not in a supported game!")
	end
	
	local selectedgame = ""
	local gamenames = {}
	local inversegames = {}
	for i,v in pairs(games) do
		table.insert(gamenames, v[1])
		inversegames[v[1]] = v[2]
	end
	
	Games_T:Dropdown({
		Name = "Select supported game",
		Items = gamenames,
		Default = "The Games",
		Callback = function(val)
			selectedgame = val
		end
	})
	Games_T:Button({
		Name = "Teleport to game",
		Callback = function()
			window:Notify({
				Title = "Teleporting in process!",
				Body = "You should be there soon!",
				Duration = 10
			})
	
			SERVICES.TELEPORT_S:Teleport(tonumber(inversegames[selectedgame]), plr)
		end
	})
	
	for i,v in pairs(game.CoreGui:GetChildren()) do
		if string.find(v.Name,"The Games") then
			v.Destroying:Connect(function()
				for i,v in pairs(Shines_EVENTS) do
					v:Disconnect()
				end
				for i,v in pairs(Silver_EVENTS) do
					v:Disconnect()
				end
				print("done disconnecting events")
			end)
		end
	end

end

if nokey then
	main()
else
	local _, keysys = pcall(loadstring(game:HttpGet("https://raw.githubusercontent.com/Xenon-Trioxide/stuff-and-more-stuff/main/SMM.lua")))
	if keysys:CheckKey() then
	    main()
	end
end

local nokey = true --Change this to true to remove key system
local lplayer = game.Players.LocalPlayer

local _, library = pcall(loadstring(game:HttpGet("https://raw.githubusercontent.com/XploitSDS/XploitHub/main/XPloitHubLibrary.lua")))

-- get main table from reg stuff
local func
local index
local maintable 
for i,v in pairs(debug.getregistry()) do
    if type(v) == "function" and not is_synapse_function(v) and getinfo(v).name and not func then
        for j, w in pairs(getupvalues(v)) do
            if type(w) == "table" and w["aimassist"] then
                func = v
                index = j
                maintable = w
                break
            end
        end
    end
end

--update the table lol
function updateTable()
    if func then
        setupvalue(func,index,maintable)
    end
end

function CheckMobile()
    if game:GetService("UserInputService").MouseEnabled and not game:GetService("UserInputService").TouchEnabled then
        return false
    else return true end
end

local toggles = {
	spamdeathtoggle = false,
	autofarmtoggle = false,
	farmbosstoggle = false,
	zignoretoggle = false,
	autopackagetoggle = false,
	autopowerupstoggle = false
}

local ownedguns = {}
for i,v in pairs(game.ReplicatedStorage.Stats[lplayer.Name].Owned:GetChildren()) do
	if game:GetService("ReplicatedStorage").Assets.GunModels:FindFirstChild(v.Name) then
		table.insert(ownedguns, v.Name)
	end
end
local guns = {}
for i,v in pairs(game.ReplicatedStorage.Assets.GunModels:GetChildren()) do
	table.insert(guns, v.Name)
end
local perks = {}
for i,v in pairs(maintable["weaponmodule"]["Weapons"]) do
	for j,w in pairs(v["List"]) do
		if w["Class"] == "Perk" then
			table.insert(perks, w["Name"])
		end
	end
end

local grenades = {}
for i,v in pairs(game.ReplicatedStorage.Assets.Grenades:GetChildren()) do
	table.insert(grenades, v.Name)
end
local players = {}
for i,v in pairs(workspace:GetChildren()) do
	if game.Players:FindFirstChild(v.Name) and v:FindFirstChild("Deployed") then
		table.insert(players, v.Name)
	end
end
local skins = {}
for i,v in pairs(maintable["customisation"]["SkinPack"]) do
	skins[i] = i
end
local colors = {}
for i,v in pairs(maintable["customisation"]["Module"]["Colours"]) do
	for j,w in ipairs(v["List"]) do
		colors[w] = w
	end
end
local attachments = {
	Optic = {
		["Canted Iron Sights"] = "Canted Iron Sights"
	},
	Grip = {},
	Barrel = {},
	Side = {},
	Ammunition = {},
	Capacity = {},
	Weight = {
		["Barrel Weight"] = "Barrel Weight",
		["Bayonet"] = "Bayonet"
	}
}
for i,v in pairs(require(game:GetService("ReplicatedStorage").ModuleScripts.Attachments)) do
	if attachments[i] then
		for j,w in pairs(v) do
			if i == "Barrel" then
				attachments["Weight"][w.Name] = w.Name
			end
			attachments[i][w.Name] = w.Name
		end
	end
end


local selectedautofarmgun = "M4"
local selectedgunforskins = ""
local selectedgunforattachments = ""
local selectedskins = {}
local selectedcolors = {}

local inputhatid = 0
local speedval = 16
local jumpval = 50

local zombies = {}
local character = nil
local deployed = false

function RainbowGUI(gui)
	if gui then
		local hue = 0
	
	    local function updateColor()
	        hue = (hue + 1) % 360
	        local color = Color3.fromHSV(hue / 360, 1, 1)
	        gui.BackgroundColor3 = color
	    end
	
	    local connection = game:GetService("RunService").RenderStepped:Connect(function()
	        updateColor()
	    end)
		function stopRainbow()
	        connection:Disconnect()
	    end

	    return stopRainbow
    end
end

--magic
function CombineGun(gun1,gun2,slot)
	maintable.mala[slot] = gun1 -- base gun: base stat, kills are credited to this gun if user havent unlocked target gun
	updateTable()
	
	spawn(function() -- equip the gun to complete the combination process
		repeat wait() until deployed
		maintable.savedmala[slot] = gun2 -- target gun: replace base stat with target stat except for ammo capacity and reserve ammo capacity
		updateTable()
		keypress("0x3"..tostring(slot))
	end)
end

function SpawnExplosion(spawnpart,launcher,direction) -- abusing launcher remote to spawn explosion where ever you want, really cool
	local ohString1 = "RPG"
	local ohInstance2 = spawnpart
	local ohVector33 = direction or Vector3.new(0,-1,0)
	local ohNumber4 = 10078797426
	local ohString5 = "Explosive"
	local ohString6 = launcher or "M79 Thumper"
					            
	game:GetService("ReplicatedStorage").RemoteEvent3:FireServer(ohString1, ohInstance2, ohVector33, ohNumber4, ohString5, ohString6)
	game:GetService("ReplicatedStorage").RemoteEvent:FireServer("Reloaded", "3")
end

function DeployToGame()
    local screensize = workspace.CurrentCamera.ViewportSize
	if lplayer.PlayerGui.ScreenGui.MainMenu.Bar1.Deploy.Text == "Play" then
	    mousemoveabs(screensize.X*0.1,screensize.Y*0.03)
	    wait()
	    mousemoveabs(screensize.X*0.1,screensize.Y*0.03+1)
	    mouse1click()
	    wait(0.5)
    end
end

-- add zombie to the zombie table
game.Workspace.Zombies.ChildAdded:Connect(function(child)
    if child:FindFirstChild("Humanoid") then
        zombies[child.Name] = child
	end
end)

-- deploy/players manager
workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("BoolValue") and descendant.Name == "Deployed" then
    	if descendant.Parent.Name == lplayer.Name then
    		character = descendant.Parent
	        wait(1)
	        deployed = true
	        character.Humanoid.Died:Connect(function()
	        	character = nil
	        	deployed = false
	        end)
    	elseif game.Players:FindFirstChild(descendant.Parent.Name) then
    		table.insert(players, descendant.Parent.Name)
        end
    end
end)

workspace.ChildRemoved:Connect(function(child)
	if players[child.Name] then
		table.remove(players, table.find(players, descendant.Parent.Name))
	end
end)


--the next 3 functions are for the teapawt
Spaw = false
function FireShield()
	function GetX(t)
	return 41 * math.cos(t) - 18 * math.sin(t) - 83 * math.cos(2 * t) - 11 * math.cos(3 * t) + 27 * math.sin(3 * t)
	end
	
	function GetY(t)
		return 36 * math.cos(t) + 27 * math.sin(t) - 113 * math.cos(2 * t) + 30 * math.sin(2 * t) + 11 * math.cos(3 * t) - 27 * math.sin(3 * t)
	end
	
	function GetZ(t)
		return 45 * math.sin(t) - 30 * math.cos(2 * t) + 113 * math.sin(2 * t) - 11 * math.cos(3 * t) + 27 * math.sin(3 * t)
	end
	Spaw = not Spaw
	local i = 0
	if Spaw then
		while Spaw and character do
			i = (i + 0.15)
			SpawnExplosion(character.HumanoidRootPart,launcher, Vector3.new(GetX(i) / 5, GetY(i) / 5, GetZ(i) / 5))
			SpawnExplosion(character.HumanoidRootPart,launcher, -Vector3.new(GetX(i) / 5, GetY(i) / 5, GetZ(i) / 5))
			wait(0.025)
		end
	else
		
	end
end

function SpinFire()
	local Direction = CFrame.new(character.Head.Position,lplayer:GetMouse().Hit.p)
	for i = 0, 75 do
		local x = math.sin(i / 3) * 8 * (75 - i) / 75
		local y = math.cos(i / 3) * 8 * (75 - i) / 75
		local Helix = Direction * CFrame.new(x, y, -i)
		SpawnExplosion(character.Head, "M79 Thumper", Helix.p - character.Head.Position)
		x = -math.sin(i / 3) * 8 * (75 - i) / 75
		y = -math.cos(i / 3) * 8 * (75 - i) / 75
		Helix = Direction * CFrame.new(x, y, -i)
		SpawnExplosion(character.Head, "M79 Thumper", Helix.p - character.Head.Position)
		wait(.02)
	end
end

function Katon() -- autoclicker moment
	for i = 0, 75 do
		local Direction = (lplayer:GetMouse().Hit.p - character.Head.Position).Unit
		SpawnExplosion(character.Head, "M79 Thumper", Direction)
		wait(0.05)
	end
end

function main()
	local window = library:CreateWindow("Xploit's Zombie Annihilation Protocol")
	
	local main = window:CreateTab("Main") -- auto reload, auto carepackage
    local autofarmtab = window:CreateTab("Autofarm") -- m79/minigun autofarm, gun level farm
    local playertab = window:CreateTab("Player") -- speed, auto revive, auto powerup, auto buff
    local loadouttab = window:CreateTab("Loadout") -- uses mala to edit and combine loadout
    local avatartab = window:CreateTab("Avatar") -- customize avatar
    local skinstab = window:CreateTab("Skins") -- crack skins
    local attachmentstab = window:CreateTab("Attachments") -- bypass attachments requirements
    local misctab = window:CreateTab("Misc") -- downed spam, teapawt
	local cred = window:CreateTab("Credits")

	--main
	local label = main:CreateLabel("<font size=\"48\">Welcome!</font>")
	local label = main:CreateLabel("Zombie Uprising is a pretty cool game", "However, at a certain point it does get a little bit <font color=\"#FF0000\">grindy</font>...\nThe most powerful autofarm for this game up to this point is your average esp and aimbot from April -_-")
	local label = main:CreateLabel("<font size=\"18\">Introducing the <font weight=\"heavy\">Zombie Annihilation Protocol</font>!</font>", "The best GUI in Zombie Uprising! \nFeaturing: \n	- An autofarm <font size=\"5\">duh</font> \n	- Combining guns using <font color=\"#000032\">dark magic</font> \n	- Free skins \n	- Teapot?")
	
	--autofarm
	local label = autofarmtab:CreateLabel("Autofarm","For general autofarm to work, <font color=\"#FFFF00\">you must toggle the farm first in menu!</font>")
	local autopackage = autofarmtab:CreateToggle("Auto care package", false, function(on)
		if on then
			toggles.autopackagetoggle = true
			while toggles.autopackagetoggle and wait(5) do
				if character and workspace.Ignore.Rewards:FindFirstChild("Carepackage") then
					character.HumanoidRootPart.CFrame = workspace.Ignore.Rewards.Carepackage.PrimaryPart.CFrame
				end
			end
		else
			toggles.autopackagetoggle = false
		end
	end)
	
	local autopowerups = autofarmtab:CreateToggle("Auto powerups", false, function(on)
		if on then
			toggles.autopowerupstoggle = true
			while toggles.autopowerupstoggle and wait(1) do
				for i,v in pairs(workspace.Ignore.PowerUps:GetChildren()) do
					if character then
						v.CFrame = character.HumanoidRootPart.CFrame
					end
				end
			end
		else
			toggles.autopowerupstoggle = false
		end
	end)
	
	local farmboss = autofarmtab:CreateToggle("Autofarm boss", false, function(on)
		if on then
			toggles.farmbosstoggle = true
		else
			toggles.farmbosstoggle = false
		end
	end)
	
	local zombiefarm = autofarmtab:CreateToggle("General autofarm", false, function(on)
		if on then
			toggles.autofarmtoggle = true
			if not deployed then
				CombineGun(selectedautofarmgun,"M79 Thumper",3)
				DeployToGame()
			end
			--workspace.Map.BossFolder.Boss
			while toggles.autofarmtoggle and wait() do
				if toggles.farmbosstoggle then
					workspace.Map.DescendantAdded:Connect(function(descendant)
						while descendant.Name == "Boss" and descendant:FindFirstChild("Humanoid") do
							wait(0.1)
						    SpawnExplosion(descendant:FindFirstChild("Head"))
						end
					end)
				end
				
				for i,v in pairs(zombies) do
					while v and v:FindFirstChild("Humanoid") and character and v.Humanoid.Health > 0 and deployed do
					    wait(0.1)
					    SpawnExplosion(v:FindFirstChild("Head"))
					end
		    	end
			end
		else
			toggles.autofarmtoggle = false
		end
	end)
	local label = autofarmtab:CreateLabel("Change gun below to minigun if you owned it","Minigun and high ammo capacity perks are effective and highly recommended \nSelect a gun first then press general autofarm above")
	local autofarmgun = autofarmtab:CreateDropdown("Gun level farm", ownedguns, function(val)
		selectedautofarmgun = val
	end)
	
	--player
	local speedslider = playertab:CreateSlider("Change speed", 0, 200, function(speed)
		speedval = speed
	end)
	
	local jumpslider = playertab:CreateSlider("Change jump power", 0, 200, function(jp)
		jumpval = jp
	end)
	
	local zignore = playertab:CreateToggle("Zombie ignore (after revive)", false, function(on)
		if on then
			toggles.zignoretoggle = true
			while toggles.zignoretoggle and wait() do
				if character and maintable["downed"] == true then
					wait(0.1)
					maintable["downed"] = false
					updateTable()
				end
			end
		else
			toggles.zignoretoggle = false
		end
	end)
	
	local reviveall = playertab:CreateButton("TP Revive all", function()
		if character then
			for i,v in pairs(players) do
				character.HumanoidRootPart.CFrame = workspace[v].HumanoidRootPart.CFrame
				game:GetService("ReplicatedStorage").RemoteEvent:FireServer("Revive", game.Players[v])
				wait(0.2)
			end
		end
	end)
	
	game:GetService("RunService").RenderStepped:Connect(function()
		if character then
			character.Humanoid.WalkSpeed = speedval
			character.Humanoid.JumpPower = jumpval
		end
	end)
	
	--loadout
	local label = loadouttab:CreateLabel("Change your loadout", "Choose any guns in the game then deploy \nUnowned guns will be combined with last-equipped guns when selected \n<font color=\"#FFFF00\">Launchers and melees will not work on slots other than their respective slot</font>")
	local selectprimary = loadouttab:CreateDropdown("Select primary", guns, function(val)
		maintable["mala"][1] = val
	end)
	local selectsecondary = loadouttab:CreateDropdown("Select secondary", guns, function(val)
		maintable["mala"][2] = val
	end)
	local selecttertiary = loadouttab:CreateDropdown("Select tertiary", guns, function(val)
		maintable["mala"][3] = val
	end)
	local selectmelee = loadouttab:CreateDropdown("Select melee", guns, function(val)
		maintable["mala"][4] = val
	end)
	local selectperk = loadouttab:CreateDropdown("Select perk", perks, function (val)
		maintable["perk"] = val
	end)
	local selectgrenade = loadouttab:CreateDropdown("Select grenade", grenades, function (val)
		maintable["grenade"] = val
	end)
	
	--[[local label = loadouttab:CreateLabel("<font color=\"#FFFF00\">[ADVANCED] </font>Combine guns", "Below this section is for advanced use only, you will need a good understanding to proceed \nTo combine guns, first select a base gun and a target gun \nThen select a slot to combine gun \nThe next time you deploy it will automatically combine guns for you")
	local selectbasegun = loadouttab:CreateDropdown("Select base gun", guns, function(val)
		selectedbasegun = val
	end)
	local selecttargetgun = loadouttab:CreateDropdown("Select target gun", guns, function(val)
		selectedtargetgun = val
	end)
	local selectgunslot = loadouttab:CreateDropdown("Select gun slot", {1,2,3,4}, function(val)
		selectedgunslot = val
	end)]]
	
	
	--avatar
	local hatid = avatartab:CreateTextbox("Accessory Id", function(text)
		if text then
			inputhatid = tonumber(text)
		end
	end,"Id here")
	local wearhat = avatartab:CreateButton("Wear Accessory", function()
		if inputhatid > 0 then
			table.insert(maintable["avatar"]["Hat"],inputhatid)
			updateTable()
		end
	end)
	local label = avatartab:CreateLabel("To unequip accessories go into the Avatar tab in the main menu")
	
	--skins
	local label = skinstab:CreateLabel("Modify gun skin", "Select skins and colors then press Update gun skin \n<font color=\"#00FF00\">Skins will be saved to your gun</font>")
	local selectguncustomize = skinstab:CreateDropdown("Select owned gun", ownedguns, function(val)
		selectedgunforskins = val
		maintable["mala"][1] = val
	end)
	local selectskin1 = skinstab:CreateDropdown("Select skin 1", skins, function(val)
		selectedskins[1] = val
	end)
	local selectcolor1 = skinstab:CreateDropdown("Select color 1", colors, function(val)
		selectedcolors[1] = val
	end)
	local selectskin2 = skinstab:CreateDropdown("Select skin 2", skins, function(val)
		selectedskins[2] = val
	end)
	local selectcolor2 = skinstab:CreateDropdown("Select color 2", colors, function(val)
		selectedcolors[2] = val
	end)
	local skincustomize = skinstab:CreateButton("Update gun skin", function()
		for i = 1,2 do
			maintable["customisation"]["SkinPack"][selectedskins[1]] = "Purchasable Skins" -- set the gamepass skins to normal skin type
			maintable["customisation"]["Module"]["Colours"][1]["List"][1] = selectedcolors[i] -- change the free color black to input color
			maintable["customisation"]["Module"]["Order"][1]["List"][1]["List"][1] = selectedskins[i] -- change the free US Army Desert skin into input skin
			firesignal(lplayer.PlayerGui.ScreenGui.MainMenu.Loadout.Menu.Skins.Bar1["Section"..tostring(i)].Activated)-- change sections for input
			firesignal(lplayer.PlayerGui.ScreenGui.MainMenu.Loadout.Menu.Skins.Frame.Free["US Army Desert"].Activated) -- simulate a click on the free skin
			firesignal(lplayer.PlayerGui.ScreenGui.MainMenu.Loadout.Menu.Skins.ColourSpectrum.Black.Activated) -- simulate a click on the free color
		end
	end)
	
	--attachments
	local selectablevalues = {
		["Optics"] = nil,
		["Barrel"] = nil,
		["Side"] = nil,
		["Grip"] = nil,
		["Weight"] = nil
	}
	
	function AssignAttachments(val,attachment)
		maintable["attachments"][1][attachment] = val
		firesignal(lplayer.PlayerGui.ScreenGui.MainMenu.Loadout.Buttons.Primary["Attachments Primary"].Activated)
		firesignal(lplayer.PlayerGui.ScreenGui.MainMenu.Loadout.Buttons.Primary["Attachments Primary"].Activated)
		updateTable()
	end
	
	local label = attachmentstab:CreateLabel("Select a gun and select attachments","Attachments will not save with your gun \n<font color=\"#FFFF00\">Barrel weight attachments (barrel weight and bayonet) are cosmetics and can break your game as they are unused and not supported for all guns \nIf your game breaks then rejoin</font>")
	local selectgun = attachmentstab:CreateDropdown("Select owned gun", ownedguns, function(val)
		selectedgunforattachments = val
		maintable["mala"][1] = val
		for i,v in pairs(attachments) do
			maintable["attachments"][1][i] = ""
		end
		firesignal(lplayer.PlayerGui.ScreenGui.MainMenu.Loadout.Buttons.Primary["Attachments Primary"].Activated)
		firesignal(lplayer.PlayerGui.ScreenGui.MainMenu.Loadout.Buttons.Primary["Attachments Primary"].Activated)
		
		for i,v in pairs(selectablevalues) do
			if game.ReplicatedStorage.Assets.GunModels[val]:FindFirstChild("Connector"..i) then
				v.Visible = true
				if i == "Weight" then
					selectablevalues["Barrel"].Visible = false
				end
			else
				v.Visible = false
			end
		end
	end)
	selectablevalues["Optics"] = attachmentstab:CreateDropdown("Select optic", attachments["Optic"], function(val)
		AssignAttachments(val,"Optic")
	end)
	selectablevalues["Grip"] = attachmentstab:CreateDropdown("Select grip", attachments["Grip"], function(val)
		AssignAttachments(val,"Grip")
	end)
	selectablevalues["Barrel"] = attachmentstab:CreateDropdown("Select barrel", attachments["Barrel"], function(val)
		AssignAttachments(val,"Barrel")
	end)
	selectablevalues["Weight"] = attachmentstab:CreateDropdown("Select barrel", attachments["Weight"], function(val) -- same as barrel but with unused barrel weights
		AssignAttachments(val,"Barrel")
	end)
	selectablevalues["Side"] = attachmentstab:CreateDropdown("Select side", attachments["Side"], function(val)
		AssignAttachments(val,"Side")
	end)
	local ammunition = attachmentstab:CreateDropdown("Select ammunition", attachments["Ammunition"], function(val)
		AssignAttachments(val,"Ammunition")
	end)
	local capacity = attachmentstab:CreateDropdown("Select capacity", attachments["Capacity"], function(val)
		AssignAttachments(val,"Capacity")
	end)
	for i,v in pairs(selectablevalues) do
		v.Visible = false
	end
	
	
	--misc
	local spamdeath = misctab:CreateToggle("Spam downed noise", false, function(on)
		if on then
			toggles.spamdeathtoggle = true
			while toggles.spamdeathtoggle and wait() do
				game:GetService("ReplicatedStorage").RemoteEvent:FireServer("Downed")
			end
		else
			toggles.spamdeathtoggle = false
		end
	end)
	
	local tptoapoc = misctab:CreateButton("Teleport to Apocalypse server (bypass level)", function()
		game:GetService("TeleportService"):Teleport(7092693227, lplayer)
	end)
	
	local element
    local wearteapot
    if CheckMobile() then
        wearteapot = misctab:CreateLabel("Teapot Turret is only available on PC!")
    else
        wearteapot = misctab:CreateButton("Tea time anyone?", function() -- ever heard of "Teapot Turret"?
		table.insert(maintable["avatar"]["Hat"],1055299)--teapawt
		if not deployed then
			CombineGun(selectedautofarmgun,"M79 Thumper",3)
			DeployToGame()
		end
		Spaw = false
		
		wait(5)
		RainbowGUI(lplayer.PlayerGui.ScreenGui.Deployed.Tools.Frame["3"])
		lplayer.PlayerGui.ScreenGui.Deployed.Tools.Frame["3"].Text = "Teapot Turret"
		lplayer.PlayerGui.ScreenGui.Deployed.Tools.Frame["3"].TextLabel2.Text = "Over-powered"
		local keyinput = game:GetService("UserInputService").InputBegan:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.Q then -- Katon Goukakyou No Jutsu
				Katon()
			elseif input.KeyCode == Enum.KeyCode.E then -- SpinFire
				SpinFire()
			elseif input.KeyCode == Enum.KeyCode.T then -- Toggle Fire Shield
				FireShield()
			end
		end)
		element.Visible = true
		repeat wait() until not deployed
		table.remove(maintable["avatar"]["Hat"],table.find(maintable["avatar"]["Hat"],1055299))
		keyinput:Disconnect()
	end)
    end
	label, element = misctab:CreateLabel("Teapot Turret controls (MUST EQUIP SLOT 3)","Q: Katon Goukakyou No Jutsu \nE: SpinFire \nT: Fire Shield")
	element.Visible = false
	
	--cred
	local label = cred:CreateLabel("Interface : Xploit Library made by Code_Xploit")
	local label = cred:CreateLabel("Scripting : Xploit SDS Team")
	local label = cred:CreateLabel("More features will be added on request!")
	
	while wait() do
		if window:GetCurrentState() == library.WindowState.Destroyed then
			for i,v in pairs(toggles) do
				v = false
			end
			
		    return
		end
	end
end


if nokey then
	main()
else
	local _, keysys = pcall(loadstring(game:HttpGet("https://raw.githubusercontent.com/XploitSDS/Xploit-Scripts-Warehouse/main/Additional_setup")))
	if keysys:CheckKey() then
	    main()
	end
end

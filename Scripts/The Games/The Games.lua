local module = {}

function module:LoadShines(plr, window, tab, SERVICES, EVENTS, FUNCTIONS)
  tab:Button({
		Name = "Collect treasures",
		Callback = function()
			treasures = workspace.BuriedTreasure.BuriedTreasure
			for i = 1, #treasures:GetChildren() do
				if treasures[i]:FindFirstChild("ProximityPrompt") then
					plr.Character:PivotTo(CFrame.new(treasures[i].Position))
					wait(0.2)
					SERVICES.VIM_S:SendKeyEvent(true,Enum.KeyCode.E,false,workspace)
					wait(1.2)
					SERVICES.VIM_S:SendKeyEvent(false,Enum.KeyCode.E,false,workspace)
					wait(11)
				end
			end
			--Click(screensize.X/2,screensize.Y/2)
		end
	})

end

function module:LoadSilver(plr, window, tab, SERVICES, EVENTS, FUNCTIONS)
	  -- Quest coins
	coinpos = {
		CoilObby = CFrame.new(-777.6221313476562, 680.4069213867188, -1229.9202880859375),
		OnlyUpObby = CFrame.new(-1366.342041015625, 363.0050354003906, 421.07574462890625),
		SizeObby = CFrame.new(-1123.864501953125, 191.3951873779297, -270.8232421875),
	}
	
	tab:Button({
		Name = "Collect quest coins",
		Callback = function()
			for i,v in pairs(workspace.QuestCoins:GetChildren()) do
				plr.Character:PivotTo(coinpos[v.Name] * CFrame.new(0,2,0))
				wait(0.2)
				if v:FindFirstChild("ProximityPrompt") then
					SERVICES.VIM_S:SendKeyEvent(true,Enum.KeyCode.E,false,workspace)
					wait(1.2)
					SERVICES.VIM_S:SendKeyEvent(false,Enum.KeyCode.E,false,workspace)
					wait(1)
					--Click(screensize.X/2,screensize.Y/2)
				end
			end
		end
	})
	
	-- Selfie
	teamleaders = {
		["Angry Canary"] = CFrame.new(-569.6300048828125, 68.69573974609375, -187.701904296875),
		["Crimson Cats"] = CFrame.new(-893.4041137695312, -16.553871154785156, 505.7377014160156),
		["Giant Feet"] = CFrame.new(-944.6176147460938, 41.07493591308594, 271.311279296875),
		["Mighty Ninjas"] = CFrame.new(-569.6300048828125, 68.69573974609375, -187.701904296875),
		["Pink Warriors"] = CFrame.new(-740.6978759765625, 11.263547897338867, 43.86173629760742)
	}
	if not plr.Team then
		window:Notify({
			Title = "Pick a team!",
			Body = "Script won't work until you pick a team!",
			Duration = 10
		})
	end
	
	tab:Button({
		Name = "Take selfie",
		Callback = function()
			if plr.Team then
				local leadercf = teamleaders[plr.Team.Name]
				plr.Character:PivotTo(leadercf * CFrame.new(0,0,-5))
	
				workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
				workspace.CurrentCamera.CFrame = CFrame.new((leadercf * CFrame.new(0,0,-15)).Position, leadercf.Position)
	
				if not plr.Character:FindFirstChild("Camera") then
					SERVICES.VIM_S:SendKeyEvent(true, Enum.KeyCode.One, false, workspace)
					wait()
					SERVICES.VIM_S:SendKeyEvent(false, Enum.KeyCode.One, false, workspace)
				end
	
				window:Notify({
					Title = "Press the top button",
					Body = "and save the image",
					Duration = 10
				})
	
				local scbutton = plr.PlayerGui.PhotoMode.Toggles.Screenshot
				scbutton.Activated:Once(function()
					workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
				end)
			end
		end
	})

	-- Show aura
	tab:Button({
		Name = "Show aura (BUY AURA FROM SHOP!)",
		Callback = function()
			if plr.Backpack:FindFirstChild("Aura") then
				FUNCTIONS:PressKey(Enum.KeyCode[FUNCTIONS:GetInvSlot("Aura")], .01)
				wait(0.1)
				plr.Character:PivotTo(workspace:FindFirstChild("DialogUsed",true).Parent.HumanoidRootPart.CFrame)
				FUNCTIONS:PressKey(Enum.KeyCode[FUNCTIONS:GetInvSlot("Aura")], 1.2)
			elseif plr.Character:FindFirstChild("Aura") then
				plr.Character:PivotTo(workspace:FindFirstChild("DialogUsed",true).Parent.HumanoidRootPart.CFrame)
				FUNCTIONS:PressKey(Enum.KeyCode[FUNCTIONS:GetInvSlot("Aura")], 1.2)
			else
				window:Notify({
					Title = "You don't have aura!",
					Body = "Go buy aura from shop!",
					Duration = 10
				})
			end
		end
	})
end

return module

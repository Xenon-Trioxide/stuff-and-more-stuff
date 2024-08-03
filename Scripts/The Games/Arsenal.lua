local module = {}

function module:LoadShines(plr, window, tab, SERVICES, EVENTS, FUNCTIONS)
  tab:Button({
    Name = "Collect Shines",
    Callback = function()
      for i,v in pairs(workspace.Map.Geometry.Start.Geometry.Items:GetChildren()) do
        if v:IsA("BasePart") then
          plr.Character:PivotTo(v.CFrame * CFrame.new(0,2,0))
          wait(0.2)
        end
      end
    end
  })

end

function module:LoadSilver(plr, window, tab, SERVICES, EVENTS, FUNCTIONS)
	local bigheadtoggle = false
	local speed = 22.4
	local oldcf = nil
	local platform
	local enemies = {}

	tab:Slider({
		Name = "Speed",
		Min = 0,
		Max = 200,
		InitialValue = 22.4,
		Callback = function(val)
			speed = val
		end
	})

	tab:Slider({
		Name = "Jump power",
		Min = 0,
		Max = 200,
		InitialValue = 35,
		Callback = function(val)
			plr.Character.Humanoid.UseJumpPower = true
			plr.Character.Humanoid.JumpPower = val
		end
	})

	tab:Label("You will need the shotgun for the farm to work!")
	tab:Toggle({
		Name = "Kill enemy",
		Callback = function(val)
			bigheadtoggle = val
			while bigheadtoggle do
				repeat wait() until #workspace.Map.Enemies:GetChildren() > 0 or not bigheadtoggle
				oldcf = plr.Character.HumanoidRootPart.CFrame
				if bigheadtoggle then
					platform = Instance.new("Part",workspace)
					platform.CFrame = oldcf*CFrame.new(0,95,0)
					platform.Size = Vector3.new(50, 2, 50)
					platform.Anchored = true
					spawn(function()
						wait(3)
						plr.Character:PivotTo(oldcf*CFrame.new(0,100,0))
					end)
				end
				repeat 
					if not bigheadtoggle then
						plr.Character:PivotTo(oldcf)
						return
					end
					wait() 
				until #workspace.Map.Enemies:GetChildren() == 0 or not bigheadtoggle
				if platform then
					plr.Character:PivotTo(oldcf)
					platform:Destroy()
				end
				enemies = {}
			end
		end
	})

	for i,v in pairs(workspace.Map.Enemies:GetChildren()) do
		if v:IsA("Model") then
			table.insert(enemies, v)
			local index = #enemies
		end
	end

	EVENTS["EnemyAdded"] = workspace.Map.Enemies.ChildAdded:Connect(function(child)
		if child:IsA("Model") then
			table.insert(enemies, child)
			local index = #enemies
		end
	end)

	EVENTS["Speed"] = plr.Character.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		plr.Character.Humanoid.WalkSpeed = speed
	end)

	EVENTS["RenderStepped"] = SERVICES.RUN_S.RenderStepped:Connect(function()
		if plr.Character then
			if bigheadtoggle then
				for i,v in ipairs(enemies) do
					pcall(function()
						if v.Name ~= "AI_Material Man" then
							v.Head.Size = Vector3.new(10,10,10)
						end
						v:PivotTo(plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-30))
					end)
				end
			end
		end
	end)
end

return module

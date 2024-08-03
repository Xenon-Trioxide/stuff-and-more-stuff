local module = {}

function module:LoadShines(plr, window, tab, SERVICES, EVENTS, FUNCTIONS)
  local toggle = false
  local found = false

  tab:Label("Enable this in the main menu!")
  tab:Toggle({
    Name = "Show all shines",
    Callback = function(val)
      toggle = val
      if toggle then repeat
        for i,v in ipairs(plr.PlayerGui.MainUI:GetDescendants()) do
            if string.find(v.Name,"FAKE_ITEM") and v.Visible then
              found = true
              v.Parent = plr.PlayerGui.MainUI
              v.Size = UDim2.new(0.5, 0, 0.5, 0)
              v.Position = UDim2.new(0.5, 0, 0.5, 0)
              v.BackgroundTransparency = 0
              v.ZIndex = 10000000
              v.Activated:Wait()
              wait(2)
              v:Destroy()
            end
        end
        if not found then
          toggle = false
        else
          found = false
        end
        wait(0.1)
      until not toggle end
    end
  })

end

function module:LoadSilver(plr, window, tab, SERVICES, EVENTS, FUNCTIONS)
  toggle = false
  
  tab:Label("Make sure you are in a match before enabling this!")
  tab:Label("After you enable just spam click and watch your score go up!")
  tab:Toggle({
      Name = "Auto merge balls",
      Callback = function(val)
        toggle = val
        if toggle then
          workspace.Playspaces.SinglePlayer.LocalBoxParts.LeftWall.CanCollide = false
          workspace.Playspaces.SinglePlayer.LocalBoxParts.RightWall.CanCollide = false
          
          EVENTS["ChildAdded1"] = workspace.Playspaces.Duels.ActiveFruits.ChildAdded:Connect(function()
          	for i,v in pairs(workspace.Playspaces.Duels.ActiveFruits:GetChildren()) do
          		if v:IsA("BasePart") then
          			v.CFrame = CFrame.new(-46.36000061035156, 11.983068466186523, -44.77533721923828)
          		end
          	end
          end)
          EVENTS["ChildAdded2"] = workspace.Playspaces.SinglePlayer.ActiveFruits.ChildAdded:Connect(function()
          	for i,v in pairs(workspace.Playspaces.SinglePlayer.ActiveFruits:GetChildren()) do
          		if v:IsA("BasePart") then
          			v.CFrame = CFrame.new(-46.36000061035156, 11.983068466186523, -44.77533721923828)
          		end
          	end
          end)
        else
          for i,v in pairs(EVENTS) do
            v:Disconnect()
          end
        end
      end
  })
end

return module

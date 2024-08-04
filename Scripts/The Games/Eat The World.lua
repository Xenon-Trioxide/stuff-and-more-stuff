local module = {}

function module:LoadShines(plr, window, tab, SERVICES, EVENTS, FUNCTIONS)
  if game.PlaceId == 18504777118 then
    tab:Button({
      Name = "Collect Shines",
      Callback = function()
        for i,v in pairs(workspace.TheGames.Shines:GetChildren()) do
          if v:IsA("BasePart") and v.Transparency ~= 1 then
            plr.Character:PivotTo(v.CFrame)
            wait(1)
          end
        end
      end
    })
  else
    tab:Label("You must join the event first!")
  end
end

function module:LoadSilver(plr, window, tab, SERVICES, EVENTS, FUNCTIONS)
	if game.PlaceId == 18504777118 then
    local remoteevents = plr.Character.Events
    local autocollecttoggle = false
    local autofarmtoggle = false
    local breaktoggle = false
    local stoptoggle = false
    local antianchor = false

    local chunk = nil
    local shift = 0

    tab:Toggle({
      Name = "Stop Autofarm when max size",
      Callback = function(val)
        stoptoggle = val
      end
    })

    tab:Toggle({
      Name = "Autofarm",
      Callback = function(val)
        autofarmtoggle = val

        while autofarmtoggle and wait(0.5) do
          if chunk then
            repeat 
              if not plr.PlayerGui.ScreenGui.Sell.SellText.Visible then
                remoteevents.Eat:FireServer()
              elseif not stoptoggle then
                remoteevents.Sell:FireServer()
              else
                autofarmtoggle = false
              end
              wait(0.5)
            until not chunk or not autofarmtoggle
          else
            plr.Character:PivotTo(CFrame.new(-100 + shift, 3, -8))
            remoteevents.Grab:FireServer()
            shift += 1
          end
        end
        shift = 0
      end
    })

    -- quest 1
    tab:Button({
      Name = "Race",
      Callback = function()
        if plr.leaderstats.Size.Value >= 300 then
          plr.Character:PivotTo(workspace.TheGames.Stripe.Prompt.CFrame)
          FUNCTIONS:PressKey(Enum.KeyCode.E, 0.1)
          
          repeat wait(1) until workspace:FindFirstChild("Folder")
          while workspace:FindFirstChild("Folder") and wait(0.2) do
            if workspace.Folder:FindFirstChild("Checkpoint") then
              plr.Character:PivotTo(workspace.Folder.Checkpoint.Hitbox.CFrame)
            end
          end
        else
          window:Notify({
            Title = "You are not big enough!",
            Body = "Get to size 300 first!",
            Duration = 10
          })
        end
      end
    })

    -- quest 2
    tab:Toggle({
      Name = "Auto collect cubes",
      Callback = function(val)
        autocollecttoggle = val
      end

    })

    tab:Toggle({
      Name = "Break targets",
      Callback = function(val)
        breaktoggle = val
        while breaktoggle and wait(2) do
          if chunk then
            local target = workspace.TheGames.Targets:FindFirstChild("Target")
            local platform = Instance.new("Part",workspace)
            platform.CFrame = target.Visual.CFrame * CFrame.new(0,-5,10)
            platform.Size = Vector3.new(10,2,10)
            platform.Anchored = true

            plr.Character:PivotTo(target.Visual.CFrame * CFrame.new(0,0,10))
            wait(1)
            remoteevents.Throw:FireServer()

            repeat wait() until not target.Parent or not breaktoggle
            platform:Destroy()
          else
            plr.Character:PivotTo(CFrame.new(-100 + shift, 3, -8))
            remoteevents.Grab:FireServer()
            shift += 1
          end
        end
        shift = 0
      end
    })

    EVENTS["CubeAdded"] = workspace.ChildAdded:Connect(function(child)
      if autocollecttoggle and child:IsA("BasePart") and child.Name == "Cube" then
        child.CFrame = plr.Character.HumanoidRootPart.CFrame
        child.Size = Vector3.new(10,10,10)
      end 
    end)

    EVENTS["ChunkAdded"] = workspace.Chunks.ChildAdded:Connect(function(child)
      wait()
      if (autofarmtoggle or breaktoggle) and child.Parent and child.Owner.Value == plr then
        chunk = child
        chunk.Destroying:Connect(function()
          chunk = nil
        end)
      end
    end)

    --[[EVENTS["AntiAnchor"] = plr.Character.HumanoidRootPart:GetPropertyChangedSignal("Anchored"):Connect(function()
      if antianchor then
        plr.Character.HumanoidRootPart.Anchored = false
      end
    end)]]
  else
    tab:Label("You must join the event first!")
  end
end

return module

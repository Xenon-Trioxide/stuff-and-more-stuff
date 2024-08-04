local module = {}

function module:LoadShines(plr, window, tab, SERVICES, EVENTS, FUNCTIONS)
  tab:Button({
		Name = "Collect Shines",
		Callback = function()
			for i,v in pairs(workspace.Coins:GetChildren()) do
				if v:IsA("BasePart") and v.Transparency ~= 1 then
					plr.Character:PivotTo(v.CFrame * CFrame.new(0,2,0))
					wait(0.2)
					FUNCTIONS:PressKey(Enum.KeyCode.E, 0.1)
					wait(1)
				end
			end
		end
	})
end

function module:LoadSilver(plr, window, tab, SERVICES, EVENTS, FUNCTIONS)
	function GetOnHorse(horse)
		if not horse.Seat.Occupant then
			plr.Character:PivotTo(horse.Seat.CFrame)
			FUNCTIONS:PressKey(Enum.KeyCode.E, 0.1)
			window:Notify({
				Title = "Get on the horse",
				Body = "Please get on the horse to proceed",
				Duration = 10
			})
			repeat wait(1) until horse.Seat.Occupant
		end
	end
	local horse = plr.Character.Animals:FindFirstChildWhichIsA("Model")
	local tamehorsetoggle = false
	local readytotame = false
	local wildhorse = nil

	tab:Toggle({
		Name = "Tame a horse (complete tutorial)",
		Callback = function(val)
			tamehorsetoggle = val
			if tamehorsetoggle then
				horse = plr.Character.Animals:FindFirstChildWhichIsA("Model")
				GetOnHorse(horse)

				if plr.Backpack:FindFirstChild("TornLasso") then
					FUNCTIONS:PressKey(Enum.KeyCode[FUNCTIONS:GetInvSlot("TornLasso")], .01)
				end
				readytotame = true
				window:Notify({
					Title = "Click on the untammed horse!",
					Body = "Please get on the horse to proceed",
					Duration = 10
				})
			end
		end
	})
	tab:Label("Make sure you completed the second quest before the race!")
	tab:Label("You just need to ride your horse around for a while")

	if game.PlaceId == 16618922530 then
		tab:Slider({
			Name = "Horse speed",
			Min = 0,
			Max = 200,
			InitialValue = 38.85,
			Callback = function(val)
				if horse then
					horse:FindFirstChild("Data"):SetAttribute("ss", val)
				end
			end
		})
	else
		tab:Label("Press the button below to tp to racing place")
	end

	tab:Button({
		Name = "Race",
		Callback = function()
			if game.PlaceId == 16618922530 then
				GetOnHorse(horse)
				plr.Character:PivotTo(workspace.Interactions.Races.Race1.QueueZone.QueuePart.CFrame)
				window:Notify({
					Title = "Win the race for the final badge!",
					Body = "You can change the horse speed!",
					Duration = 10
				})
			else
				window:Notify({
					Title = "Teleporting to race place",
					Body = "So you don't have to wait for players",
					Duration = 10
				})

				SERVICES.TELEPORT_S:Teleport(16618922530, plr)
			end
		end
	})

	EVENTS["RenderStepped"] = SERVICES.RUN_S.RenderStepped:Connect(function()

		if tamehorsetoggle and horse then
			if not wildhorse then
				wildhorse = workspace.MobFolder:FindFirstChild("Horse")
			elseif wildhorse and readytotame then
				if wildhorse.Parent == workspace.MobFolder then
					plr.Character:PivotTo(wildhorse.CFrame)
				else
					tamehorsetoggle = false
					readytotame = false
				end
			end


		end
	end)
end

return module

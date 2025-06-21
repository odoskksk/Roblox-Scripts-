-- "Cole Is A W Script" GUI - Mobile Friendly, Enhanced
-- For educational purposes only

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- GUI SETUP
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ColeIsAW_GUI"

-- TOGGLE BUTTON
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "≡"
toggleBtn.TextSize = 22
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

-- MAIN GUI FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 270)
frame.Position = UDim2.new(0, 60, 0, 60)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Cole Is A W Script"
title.Font = Enum.Font.FredokaOne
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
title.TextSize = 18

-- BUTTON FUNCTION
local function makeBtn(text, yPos, color)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.85, 0, 0, 32)
	btn.Position = UDim2.new(0.075, 0, 0, yPos)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.BackgroundColor3 = color or Color3.fromRGB(0, 170, 0)
	btn.TextColor3 = Color3.new(1, 1, 1)
	return btn
end

-- BUTTONS
local farmBtn = makeBtn("Start Coin Farm", 40)
local killBtn = makeBtn("Kill All (Murderer)", 80, Color3.fromRGB(255, 60, 60))
local espBtn = makeBtn("ESP Roles", 120, Color3.fromRGB(60, 200, 255))
local aimbotBtn = makeBtn("Sheriff Aimbot", 160, Color3.fromRGB(255, 160, 60))
local muteBtn = makeBtn("Mute Game", 200, Color3.fromRGB(100, 100, 100))

-- Hide/show toggle
local visible = true
toggleBtn.MouseButton1Click:Connect(function()
	visible = not visible
	frame.Visible = visible
end)

-- ANTI-AFK
player.Idled:Connect(function()
	local vu = game:GetService("VirtualUser")
	vu:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
	wait(1)
	vu:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
end)

-- COIN FARM
local farming = false
farmBtn.MouseButton1Click:Connect(function()
	farming = not farming
	farmBtn.Text = farming and "Stop Coin Farm" or "Start Coin Farm"
	coroutine.wrap(function()
		while farming do
			local folder = workspace:FindFirstChild("Coins") or workspace:FindFirstChildOfClass("Folder")
			if folder then
				for _, coin in pairs(folder:GetChildren()) do
					if coin:IsA("Part") and coin.Name:lower():find("coin") then
						pcall(function()
							player.Character:MoveTo(coin.Position + Vector3.new(0, 2, 0))
						end)
						wait(0.2)
					end
				end
			end
			wait(0.5)
		end
	end)()
end)

-- KILL ALL
killBtn.MouseButton1Click:Connect(function()
	local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
	if not tool then warn("No weapon equipped!") return end
	for _, target in pairs(game.Players:GetPlayers()) do
		if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			pcall(function()
				player.Character:MoveTo(target.Character.HumanoidRootPart.Position)
			end)
			wait(0.3)
		end
	end
end)

-- ESP
local espEnabled = false
espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	for _, p in ipairs(game.Players:GetPlayers()) do
		if p ~= player and p.Character then
			local existing = p.Character:FindFirstChild("ColeESP")
			if existing then existing:Destroy() end
			if espEnabled then
				local gui = Instance.new("BillboardGui", p.Character)
				gui.Name = "ColeESP"
				gui.Adornee = p.Character:FindFirstChild("Head")
				gui.Size = UDim2.new(0, 100, 0, 40)
				gui.AlwaysOnTop = true
				local txt = Instance.new("TextLabel", gui)
				txt.Size = UDim2.new(1, 0, 1, 0)
				txt.BackgroundTransparency = 1
				txt.Text = p.Name .. " (Unknown)"
				txt.Font = Enum.Font.GothamBold
				txt.TextSize = 14
				txt.TextColor3 = Color3.new(1, 0, 0)
			end
		end
	end
end)

-- AIMBOT
local aimbot = false
aimbotBtn.MouseButton1Click:Connect(function()
	aimbot = not aimbot
	aimbotBtn.Text = aimbot and "Aimbot: ON" or "Sheriff Aimbot"
end)

game:GetService("RunService").RenderStepped:Connect(function()
	if not aimbot then return end
	for _, p in pairs(game.Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") then
			if p.Character:FindFirstChildOfClass("Tool") then
				local aimPart = p.Character:FindFirstChild("Torso") or p.Character:FindFirstChild("UpperTorso")
				if aimPart then
					mouse.TargetFilter = workspace
					mouse.Hit = CFrame.new(aimPart.Position)
				end
			end
		end
	end
end)

-- MUTE
local muted = false
muteBtn.MouseButton1Click:Connect(function()
	muted = not muted
	for _, s in ipairs(game:GetDescendants()) do
		if s:IsA("Sound") then
			s.Volume = muted and 0 or 0.5
		end
	end
	muteBtn.Text = muted and "Unmute Game" or "Mute Game"
end)

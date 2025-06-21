-- Coles Script | MM2 GUI | Delta Mobile Compatible
-- Created for Cole by ChatGPT

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ColesScriptUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.Text = "≡"
ToggleButton.Font = Enum.Font.FredokaOne
ToggleButton.TextSize = 24
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Parent = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 500)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "📜 Coles Script"
Title.Font = Enum.Font.FredokaOne
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 32
Title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Title.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = MainFrame

-- Toggle GUI
ToggleButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- Auto Coin Farm (Core)
local CoinFarmEnabled = false
local CoinCount = 0

local function createButton(name, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -20, 0, 35)
	button.Position = UDim2.new(0, 10, 0, 0)
	button.Text = name
	button.Font = Enum.Font.GothamBold
	button.TextSize = 16
	button.TextColor3 = Color3.new(1, 1, 1)
	button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	button.Parent = MainFrame
	button.MouseButton1Click:Connect(callback)
end

-- Coin ESP
local function highlightCoins()
	for _, v in pairs(Workspace:GetDescendants()) do
		if v:IsA("Part") and v.Name == "Coin" and not v:FindFirstChild("ColesCoinESP") then
			local bill = Instance.new("BillboardGui", v)
			bill.Name = "ColesCoinESP"
			bill.Size = UDim2.new(0, 100, 0, 40)
			bill.AlwaysOnTop = true
			local label = Instance.new("TextLabel", bill)
			label.Text = "💰 Coin"
			label.Size = UDim2.new(1, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.TextColor3 = Color3.new(1, 1, 0)
			label.Font = Enum.Font.GothamBold
			label.TextScaled = true
		end
	end
end

-- Coin Farming Logic
local function autoFarmCoins()
	while CoinFarmEnabled do
		if Workspace:FindFirstChild("Coins") then
			for _, coin in pairs(Workspace.Coins:GetChildren()) do
				if coin:IsA("Part") then
					pcall(function()
						LocalPlayer.Character:PivotTo(coin.CFrame + Vector3.new(0, 2, 0))
						task.wait(0.3)
						CoinCount += 1
						if CoinCount >= 40 then
							LocalPlayer.Character:BreakJoints()
							CoinCount = 0
						end
					end)
				end
			end
		end
		task.wait(1)
	end
end

-- Kill All (Murderer Only)
local function killAll()
	local knife = LocalPlayer.Backpack:FindFirstChild("Knife") or LocalPlayer.Character:FindFirstChild("Knife")
	if knife then
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				pcall(function()
					LocalPlayer.Character:PivotTo(player.Character.HumanoidRootPart.CFrame)
					task.wait(0.2)
				end)
			end
		end
	end
end

-- Sheriff Aimbot (Basic Lock-On)
local function sheriffAimbot()
	local gun = LocalPlayer.Backpack:FindFirstChild("Gun") or LocalPlayer.Character:FindFirstChild("Gun")
	if not gun then return end
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Knife") then
			local hrp = player.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				LocalPlayer.Character:PivotTo(hrp.CFrame * CFrame.new(0, 0, -10))
			end
		end
	end
end

-- ESP Roles
local function roleESP()
	for _, player in pairs(Players:GetPlayers()) do
		if player.Character and not player.Character:FindFirstChild("ColesESP") then
			local tag = Instance.new("BillboardGui", player.Character:FindFirstChild("Head"))
			tag.Name = "ColesESP"
			tag.Size = UDim2.new(0, 100, 0, 40)
			tag.AlwaysOnTop = true
			local label = Instance.new("TextLabel", tag)
			label.Size = UDim2.new(1, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.Text = player.Name
			label.TextColor3 = Color3.fromRGB(255, 255, 255)
			label.Font = Enum.Font.GothamBold
			label.TextScaled = true
		end
	end
end

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
	local vu = game:GetService("VirtualUser")
	vu:Button2Down(Vector2.new())
	task.wait(1)
	vu:Button2Up(Vector2.new())
end)

-- Add buttons
createButton("💰 Toggle Auto Coin Farm", function()
	CoinFarmEnabled = not CoinFarmEnabled
	if CoinFarmEnabled then
		autoFarmCoins()
	end
end)

createButton("🧲 Highlight Coins", function()
	highlightCoins()
end)

createButton("🔪 Kill All (Murderer)", function()
	killAll()
end)

createButton("🎯 Sheriff Aimbot", function()
	sheriffAimbot()
end)

createButton("👁️ ESP Roles", function()
	roleESP()
end)

-- Done
print("[Coles Script] Loaded successfully.")

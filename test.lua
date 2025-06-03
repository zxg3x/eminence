local KeyGuardLibrary = loadstring(game:HttpGet("https://cdn.keyguardian.org/library/v1.0.0.lua"))()
local trueData = "2c5eb12879d04e4086e471227ff3271b"
local falseData = "cf2d7c5577b7449aa37a4451a5477bcd"

KeyGuardLibrary.Set({
	publicToken = "1672c85e0999448ca99b1b0ca0b5c166",
	privateToken = "5d33d3eda383487cadce7b702ff25dab",
	trueData = trueData,
	falseData = falseData,
})

local key = "test"

local getkey = KeyGuardLibrary.getLink()
print(getkey)

local response = KeyGuardLibrary.validateDefaultKey(key)
print(response)

if response == trueData then
	local UserInputService = game:GetService("UserInputService")

local StatsManagerUI = Instance.new("ScreenGui")
StatsManagerUI.Name = "StatsManagerUI"
StatsManagerUI.Parent = game.CoreGui
StatsManagerUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Parent = StatsManagerUI
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -90)
MainFrame.Size = UDim2.new(0, 220, 0, 160)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.ClipsDescendants = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(60, 60, 60)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "EMINENCE STATS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code
Title.TextSize = 20
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 5)

local dragging = false
local dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
		MainFrame.Visible = not MainFrame.Visible
	end
end)

local StatsFrame = Instance.new("Frame", MainFrame)
StatsFrame.Size = UDim2.new(1, -20, 1, -45)
StatsFrame.Position = UDim2.new(0, 10, 0, 40)
StatsFrame.BackgroundTransparency = 1

local function createStatRow(parent, statName, yPos)
	local box = Instance.new("TextBox")
	box.Parent = parent
	box.Size = UDim2.new(0.7, 0, 0, 22)
	box.Position = UDim2.new(0, 0, 0, yPos)
	box.PlaceholderText = statName .. " Stats"
	box.Font = Enum.Font.Code
	box.TextColor3 = Color3.new(1, 1, 1)
	box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	box.TextSize = 14
	box.Text = ""
	box.BorderSizePixel = 0
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

	local addBtn = Instance.new("TextButton")
	addBtn.Parent = parent
	addBtn.Size = UDim2.new(0, 24, 0, 22)
	addBtn.Position = UDim2.new(0.7, 5, 0, yPos)
	addBtn.Text = "+"
	addBtn.Font = Enum.Font.Code
	addBtn.TextSize = 14
	addBtn.TextColor3 = Color3.new(1, 1, 1)
	addBtn.BackgroundColor3 = Color3.fromRGB(60, 150, 60)
	Instance.new("UICorner", addBtn).CornerRadius = UDim.new(0, 6)

	local subBtn = Instance.new("TextButton")
	subBtn.Parent = parent
	subBtn.Size = UDim2.new(0, 24, 0, 22)
	subBtn.Position = UDim2.new(0.7, 34, 0, yPos)
	subBtn.Text = "-"
	subBtn.Font = Enum.Font.Code
	subBtn.TextSize = 14
	subBtn.TextColor3 = Color3.new(1, 1, 1)
	subBtn.BackgroundColor3 = Color3.fromRGB(160, 60, 60)
	Instance.new("UICorner", subBtn).CornerRadius = UDim.new(0, 6)

	addBtn.MouseButton1Click:Connect(function()
		local amt = tonumber(box.Text)
		if not amt then return end
		local rs = game:GetService("ReplicatedStorage")
		local event = rs:WaitForChild("Events"):WaitForChild("AddPoint")
		event:FireServer("Free", -amt)
		event:FireServer(statName, amt)
	end)
	subBtn.MouseButton1Click:Connect(function()
		local amt = tonumber(box.Text)
		if not amt then return end
		local rs = game:GetService("ReplicatedStorage")
		local event = rs:WaitForChild("Events"):WaitForChild("AddPoint")
		event:FireServer(statName, -amt)
		event:FireServer("Free", amt)
	end)
end

local stats = { "Power", "Defense", "Agility", "Trion" }
local y = 0
for _, stat in ipairs(stats) do
	createStatRow(StatsFrame, stat, y)
	y = y + 28
end

else
	print("Key is invalid")
end

--[[
	KeyGuardLibrary.validateDefaultKey(key) - Validate key
	KeyGuardLibrary.validatePremiumKey(key) - Validate premium key
	KeyGuardLibrary.getService() - Get service
	KeyGuardLibrary.getLink() - Get link
]]
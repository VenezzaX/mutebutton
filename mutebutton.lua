local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- === Find the best place to put the GUI ===
local targetGui
local success = pcall(function()
	targetGui = CoreGui -- Executors can access this
end)

if not success or not targetGui then
	targetGui = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui")
end

-- Prevent duplicates if executed multiple times
if targetGui:FindFirstChild("MuteGui") then
	targetGui.MuteGui:Destroy()
end

-- === 1. Create the UI Elements ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MuteGui"
screenGui.ResetOnSpawn = false 

local button = Instance.new("ImageButton")
button.Name = "MuteButton"
button.AnchorPoint = Vector2.new(0, 0.5)
button.Position = UDim2.new(0, 20, 0.5, 0)
button.Size = UDim2.new(0, 50, 0, 50)

-- Setting transparency to 0.5 temporarily so you can see a dark box if the image fails to load
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.BackgroundTransparency = 0.5 
button.Parent = screenGui

-- Parent the GUI last to ensure it loads cleanly
screenGui.Parent = targetGui

-- === 2. Configuration & Logic ===
local MUTED_ID = "rbxassetid://176572749"
local UNMUTED_ID = "rbxassetid://176572848"

local isMuted = false

local function handleSound(obj)
	if obj:IsA("Sound") then
		pcall(function()
			if isMuted then
				obj.Volume = 0
			else
				obj.Volume = 0.5 
			end
		end)
	end
end

local function toggleMute()
	isMuted = not isMuted
	button.Image = isMuted and MUTED_ID or UNMUTED_ID
	
	for _, obj in ipairs(workspace:GetDescendants()) do
		handleSound(obj)
	end
end

workspace.DescendantAdded:Connect(function(obj)
	if isMuted then
		handleSound(obj)
	end
end)

button.MouseButton1Click:Connect(toggleMute)
button.Image = UNMUTED_ID

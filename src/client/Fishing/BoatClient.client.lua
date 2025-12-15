--[[
	BOAT CLIENT (COMBINED)
	Combines: BoatHandler + BoatSpawnerClient
	Place in StarterPlayerScripts > Fishing
	
	Handles:
	- ProximityPrompt creation for BoatArea
	- Camera adjustments when driving
	- Local player boat state
	- Floating button UI to open boat spawner
	- List of available boats with stats
	- Spawn button for each boat
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- Modules
local BoatConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("BoatConfig"))

-- ==================== CONSTANTS ====================
local PROMPT = BoatConfig.Prompt
local FOLDERS = BoatConfig.Folders
local DEBUG = BoatConfig.Debug

-- ==================== STATE ====================
local detectedBoats = {} -- [boatModel] = {prompt, connections}
local currentBoat = nil  -- Boat player is currently driving
local isDriving = false

-- ================================================================================
--                             SECTION: BOAT HANDLER
-- ================================================================================

local function getCharacter()
	return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoid()
	local char = getCharacter()
	return char and char:FindFirstChildOfClass("Humanoid")
end

-- ==================== PROXIMITY PROMPT ====================

local function createProximityPrompt(boatArea, boatModel)
	local existingPrompt = boatArea:FindFirstChildOfClass("ProximityPrompt")
	if existingPrompt then
		return existingPrompt
	end
	
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = PROMPT.DriveActionText or "Drive"
	prompt.ObjectText = PROMPT.ObjectText or boatModel.Name
	prompt.HoldDuration = PROMPT.HoldDuration or 0
	prompt.MaxActivationDistance = PROMPT.MaxDistance or 10
	prompt.RequiresLineOfSight = PROMPT.RequiresLineOfSight or false
	prompt.Parent = boatArea
	
	return prompt
end

-- ==================== CAMERA ====================

local originalCameraSettings = nil

local function setupDrivingCamera(seat)
	originalCameraSettings = {
		minZoom = player.CameraMinZoomDistance,
		maxZoom = player.CameraMaxZoomDistance,
		cameraType = camera.CameraType,
		cameraSubject = camera.CameraSubject
	}
	
	player.CameraMinZoomDistance = 8
	player.CameraMaxZoomDistance = 25
	camera.CameraSubject = seat
end

local function restoreCamera()
	if originalCameraSettings then
		player.CameraMinZoomDistance = originalCameraSettings.minZoom
		player.CameraMaxZoomDistance = originalCameraSettings.maxZoom
		camera.CameraSubject = getHumanoid()
		originalCameraSettings = nil
	end
end

-- ==================== BOAT SETUP ====================

local function setupBoat(boatModel)
	if detectedBoats[boatModel] then return end
	
	task.wait(0.1)
	
	local boatArea = boatModel:FindFirstChild(FOLDERS.BoatAreaName, true)
	local driverSeat = boatModel:FindFirstChild(FOLDERS.DriverSeatName, true)
	
	if not boatArea or not driverSeat then
		task.wait(0.5)
		boatArea = boatModel:FindFirstChild(FOLDERS.BoatAreaName, true)
		driverSeat = boatModel:FindFirstChild(FOLDERS.DriverSeatName, true)
	end
	
	if not boatArea then
		if driverSeat then
			boatArea = driverSeat
			if DEBUG.Enabled then
				print(string.format("📝 [BOAT CLIENT] %s using DriverSeat as prompt location", boatModel.Name))
			end
		else
			if DEBUG.Enabled then
				warn(string.format("⚠️ [BOAT CLIENT] %s has no BoatArea or DriverSeat", boatModel.Name))
			end
			return
		end
	end
	
	if not driverSeat or not driverSeat:IsA("VehicleSeat") then
		if DEBUG.Enabled then
			warn(string.format("⚠️ [BOAT CLIENT] %s missing VehicleSeat '%s'", boatModel.Name, FOLDERS.DriverSeatName))
		end
		return
	end
	
	local prompt = createProximityPrompt(boatArea, boatModel)
	local connections = {}
	
	table.insert(connections, prompt.Triggered:Connect(function(triggerPlayer)
		if triggerPlayer ~= player then return end
		
		if not driverSeat.Occupant then
			local humanoid = getHumanoid()
			if humanoid then
				driverSeat:Sit(humanoid)
			end
		end
	end))
	
	local function updatePromptState()
		if driverSeat.Occupant then
			prompt.Enabled = false
		else
			prompt.ActionText = PROMPT.DriveActionText or "Drive"
			prompt.Enabled = true
		end
	end
	
	table.insert(connections, driverSeat:GetPropertyChangedSignal("Occupant"):Connect(updatePromptState))
	updatePromptState()
	
	detectedBoats[boatModel] = {
		prompt = prompt,
		connections = connections,
		driverSeat = driverSeat,
		boatArea = boatArea
	}
	
	if DEBUG.Enabled then
		print(string.format("✅ [BOAT CLIENT] Setup complete for %s", boatModel.Name))
	end
end

local function cleanupBoat(boatModel)
	local boatData = detectedBoats[boatModel]
	if not boatData then return end
	
	for _, conn in ipairs(boatData.connections) do
		if conn then conn:Disconnect() end
	end
	
	if boatData.prompt then
		boatData.prompt:Destroy()
	end
	
	detectedBoats[boatModel] = nil
	
	if DEBUG.Enabled then
		print(string.format("🚤 [BOAT CLIENT] Cleaned up %s", boatModel.Name))
	end
end

-- ==================== PLAYER SEATED DETECTION ====================

local function onSeated(isSeated, seatPart)
	if isSeated and seatPart then
		for boatModel, boatData in pairs(detectedBoats) do
			if seatPart == boatData.driverSeat then
				currentBoat = boatModel
				isDriving = true
				setupDrivingCamera(seatPart)
				break
			end
		end
	else
		if currentBoat then
			restoreCamera()
			currentBoat = nil
			isDriving = false
		end
	end
end

-- ==================== BOATS FOLDER DETECTION ====================

local function scanBoatsFolder()
	local boatsFolder = workspace:FindFirstChild(FOLDERS.BoatsFolder)
	if not boatsFolder then
		if DEBUG.Enabled then
			warn(string.format("⚠️ [BOAT CLIENT] Folder '%s' not found in Workspace", FOLDERS.BoatsFolder))
		end
		return
	end
	
	for _, child in ipairs(boatsFolder:GetChildren()) do
		if child:IsA("Model") then
			setupBoat(child)
		end
	end
	
	boatsFolder.ChildAdded:Connect(function(child)
		if child:IsA("Model") then
			task.wait()
			setupBoat(child)
		end
	end)
	
	boatsFolder.ChildRemoved:Connect(function(child)
		if child:IsA("Model") then
			cleanupBoat(child)
		end
	end)
end

-- ==================== CHARACTER SETUP ====================

local function setupCharacter(character)
	local humanoid = character:WaitForChild("Humanoid", 10)
	if humanoid then
		humanoid.Seated:Connect(onSeated)
	end
end

local character = player.Character
if character then
	setupCharacter(character)
end

player.CharacterAdded:Connect(setupCharacter)

-- ==================== BOAT HANDLER INITIALIZATION ====================

local function waitForBoatsFolderHandler()
	local boatsFolder = workspace:FindFirstChild(FOLDERS.BoatsFolder)
	if boatsFolder then
		scanBoatsFolder()
	else
		local conn
		conn = workspace.ChildAdded:Connect(function(child)
			if child.Name == FOLDERS.BoatsFolder then
				conn:Disconnect()
				scanBoatsFolder()
			end
		end)
		
		task.delay(30, function()
			if conn and conn.Connected then
				conn:Disconnect()
				if DEBUG.Enabled then
					warn(string.format("⚠️ [BOAT CLIENT] Timeout waiting for '%s' folder", FOLDERS.BoatsFolder))
				end
			end
		end)
	end
end

waitForBoatsFolderHandler()

-- ================================================================================
--                         SECTION: BOAT SPAWNER UI
-- ================================================================================

-- Wait for remote events
local BoatSpawnerFolder = ReplicatedStorage:WaitForChild("BoatSpawner", 10)

-- Spawner remotes (nil if not available)
local SpawnBoatEvent = BoatSpawnerFolder and BoatSpawnerFolder:FindFirstChild("SpawnBoat")
local GetBoatsEvent = BoatSpawnerFolder and BoatSpawnerFolder:FindFirstChild("GetBoats")

-- ==================== UI COLORS ====================
local Colors = {
	Background = Color3.fromRGB(20, 25, 35),
	Panel = Color3.fromRGB(30, 35, 50),
	Card = Color3.fromRGB(40, 45, 65),
	CardHover = Color3.fromRGB(50, 55, 80),
	Accent = Color3.fromRGB(65, 150, 255),
	AccentHover = Color3.fromRGB(85, 170, 255),
	Text = Color3.fromRGB(255, 255, 255),
	TextDim = Color3.fromRGB(180, 185, 200),
	Success = Color3.fromRGB(80, 200, 120),
	Warning = Color3.fromRGB(255, 180, 50),
}

-- ==================== CREATE SPAWNER UI ====================

local function createSpawnerUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "BoatSpawnerUI"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui
	
	-- Floating Button
	local floatButton = Instance.new("ImageButton")
	floatButton.Name = "SpawnerButton"
	floatButton.Size = UDim2.new(0, 60, 0, 60)
	floatButton.Position = UDim2.new(0, 20, 0.5, -100)
	floatButton.BackgroundColor3 = Colors.Accent
	floatButton.BorderSizePixel = 0
	floatButton.Image = ""
	floatButton.AutoButtonColor = false
	floatButton.Parent = screenGui
	
	local floatCorner = Instance.new("UICorner")
	floatCorner.CornerRadius = UDim.new(0, 30)
	floatCorner.Parent = floatButton
	
	local floatIcon = Instance.new("TextLabel")
	floatIcon.Size = UDim2.new(1, 0, 1, 0)
	floatIcon.BackgroundTransparency = 1
	floatIcon.Text = "🚤"
	floatIcon.TextSize = 28
	floatIcon.Font = Enum.Font.GothamBold
	floatIcon.TextColor3 = Colors.Text
	floatIcon.Parent = floatButton
	
	local floatShadow = Instance.new("ImageLabel")
	floatShadow.Name = "Shadow"
	floatShadow.Size = UDim2.new(1, 20, 1, 20)
	floatShadow.Position = UDim2.new(0, -10, 0, -5)
	floatShadow.BackgroundTransparency = 1
	floatShadow.Image = "rbxassetid://5554236805"
	floatShadow.ImageColor3 = Color3.new(0, 0, 0)
	floatShadow.ImageTransparency = 0.6
	floatShadow.ZIndex = 0
	floatShadow.Parent = floatButton
	
	-- Main Popup Frame
	local popup = Instance.new("Frame")
	popup.Name = "Popup"
	popup.Size = UDim2.new(0, 400, 0, 500)
	popup.Position = UDim2.new(0.5, -200, 0.5, -250)
	popup.BackgroundColor3 = Colors.Background
	popup.BorderSizePixel = 0
	popup.Visible = false
	popup.Parent = screenGui
	
	local popupCorner = Instance.new("UICorner")
	popupCorner.CornerRadius = UDim.new(0, 16)
	popupCorner.Parent = popup
	
	local popupStroke = Instance.new("UIStroke")
	popupStroke.Color = Colors.Accent
	popupStroke.Thickness = 2
	popupStroke.Transparency = 0.5
	popupStroke.Parent = popup
	
	-- Header
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 60)
	header.BackgroundColor3 = Colors.Panel
	header.BorderSizePixel = 0
	header.Parent = popup
	
	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 16)
	headerCorner.Parent = header
	
	local headerFix = Instance.new("Frame")
	headerFix.Size = UDim2.new(1, 0, 0, 20)
	headerFix.Position = UDim2.new(0, 0, 1, -20)
	headerFix.BackgroundColor3 = Colors.Panel
	headerFix.BorderSizePixel = 0
	headerFix.Parent = header
	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -60, 1, 0)
	title.Position = UDim2.new(0, 20, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "🚤 Boat Spawner"
	title.TextSize = 22
	title.Font = Enum.Font.GothamBold
	title.TextColor3 = Colors.Text
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header
	
	-- Close Button
	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "CloseButton"
	closeBtn.Size = UDim2.new(0, 40, 0, 40)
	closeBtn.Position = UDim2.new(1, -50, 0, 10)
	closeBtn.BackgroundColor3 = Colors.Card
	closeBtn.BorderSizePixel = 0
	closeBtn.Text = "✕"
	closeBtn.TextSize = 18
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextColor3 = Colors.TextDim
	closeBtn.AutoButtonColor = false
	closeBtn.Parent = header
	
	local closeBtnCorner = Instance.new("UICorner")
	closeBtnCorner.CornerRadius = UDim.new(0, 8)
	closeBtnCorner.Parent = closeBtn
	
	-- Boat List Container
	local listContainer = Instance.new("ScrollingFrame")
	listContainer.Name = "BoatList"
	listContainer.Size = UDim2.new(1, -40, 1, -80)
	listContainer.Position = UDim2.new(0, 20, 0, 70)
	listContainer.BackgroundTransparency = 1
	listContainer.BorderSizePixel = 0
	listContainer.ScrollBarThickness = 6
	listContainer.ScrollBarImageColor3 = Colors.Accent
	listContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	listContainer.Parent = popup
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 12)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = listContainer
	
	return {
		screenGui = screenGui,
		floatButton = floatButton,
		popup = popup,
		listContainer = listContainer,
		closeBtn = closeBtn,
	}
end

-- ==================== CREATE BOAT CARD ====================

local function createBoatCard(boatData, parent)
	local card = Instance.new("Frame")
	card.Name = boatData.Name
	card.Size = UDim2.new(1, 0, 0, 120)
	card.BackgroundColor3 = Colors.Card
	card.BorderSizePixel = 0
	card.Parent = parent
	
	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 12)
	cardCorner.Parent = card
	
	-- Boat Icon
	local iconFrame = Instance.new("Frame")
	iconFrame.Size = UDim2.new(0, 80, 0, 80)
	iconFrame.Position = UDim2.new(0, 15, 0, 20)
	iconFrame.BackgroundColor3 = Colors.Panel
	iconFrame.BorderSizePixel = 0
	iconFrame.Parent = card
	
	local iconCorner = Instance.new("UICorner")
	iconCorner.CornerRadius = UDim.new(0, 10)
	iconCorner.Parent = iconFrame
	
	local iconText = Instance.new("TextLabel")
	iconText.Size = UDim2.new(1, 0, 1, 0)
	iconText.BackgroundTransparency = 1
	iconText.Text = "🚤"
	iconText.TextSize = 36
	iconText.Font = Enum.Font.GothamBold
	iconText.TextColor3 = Colors.Text
	iconText.Parent = iconFrame
	
	-- Boat Name
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0, 180, 0, 25)
	nameLabel.Position = UDim2.new(0, 110, 0, 15)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = boatData.DisplayName
	nameLabel.TextSize = 18
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextColor3 = Colors.Text
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	nameLabel.Parent = card
	
	-- Stats
	local statsText = string.format("⚡ Speed: %d  |  🚀 Accel: %.2f", boatData.MaxSpeed, boatData.Acceleration)
	local statsLabel = Instance.new("TextLabel")
	statsLabel.Size = UDim2.new(0, 180, 0, 20)
	statsLabel.Position = UDim2.new(0, 110, 0, 42)
	statsLabel.BackgroundTransparency = 1
	statsLabel.Text = statsText
	statsLabel.TextSize = 12
	statsLabel.Font = Enum.Font.Gotham
	statsLabel.TextColor3 = Colors.TextDim
	statsLabel.TextXAlignment = Enum.TextXAlignment.Left
	statsLabel.Parent = card
	
	-- Price
	local priceLabel = Instance.new("TextLabel")
	priceLabel.Size = UDim2.new(0, 180, 0, 20)
	priceLabel.Position = UDim2.new(0, 110, 0, 62)
	priceLabel.BackgroundTransparency = 1
	priceLabel.Text = boatData.Price == 0 and "🆓 Free" or string.format("💰 $%d", boatData.Price)
	priceLabel.TextSize = 14
	priceLabel.Font = Enum.Font.GothamBold
	priceLabel.TextColor3 = boatData.Price == 0 and Colors.Success or Colors.Warning
	priceLabel.TextXAlignment = Enum.TextXAlignment.Left
	priceLabel.Parent = card
	
	-- Spawn Button
	local spawnBtn = Instance.new("TextButton")
	spawnBtn.Name = "SpawnButton"
	spawnBtn.Size = UDim2.new(0, 80, 0, 35)
	spawnBtn.Position = UDim2.new(1, -95, 0.5, -17)
	spawnBtn.BackgroundColor3 = Colors.Accent
	spawnBtn.BorderSizePixel = 0
	spawnBtn.Text = "Spawn"
	spawnBtn.TextSize = 14
	spawnBtn.Font = Enum.Font.GothamBold
	spawnBtn.TextColor3 = Colors.Text
	spawnBtn.AutoButtonColor = false
	spawnBtn.Parent = card
	
	local spawnBtnCorner = Instance.new("UICorner")
	spawnBtnCorner.CornerRadius = UDim.new(0, 8)
	spawnBtnCorner.Parent = spawnBtn
	
	-- Button Hover Effects
	spawnBtn.MouseEnter:Connect(function()
		TweenService:Create(spawnBtn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.AccentHover}):Play()
	end)
	
	spawnBtn.MouseLeave:Connect(function()
		TweenService:Create(spawnBtn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent}):Play()
	end)
	
	-- Spawn Click
	spawnBtn.MouseButton1Click:Connect(function()
		spawnBtn.Text = "..."
		spawnBtn.BackgroundColor3 = Colors.Success
		
		if SpawnBoatEvent then
			SpawnBoatEvent:FireServer(boatData.Name)
		end
		
		task.delay(1, function()
			spawnBtn.Text = "Spawn"
			spawnBtn.BackgroundColor3 = Colors.Accent
		end)
	end)
	
	return card
end

-- ==================== SPAWNER UI MAIN ====================

local ui = nil
local isSpawnerOpen = false

local function toggleSpawnerPopup()
	if not ui then return end
	
	isSpawnerOpen = not isSpawnerOpen
	
	if isSpawnerOpen then
		-- Load boats
		local boats = {}
		if GetBoatsEvent then
			local success, result = pcall(function()
				return GetBoatsEvent:InvokeServer()
			end)
			if success then
				boats = result or {}
			end
		end
		
		-- Clear existing cards
		for _, child in ipairs(ui.listContainer:GetChildren()) do
			if child:IsA("Frame") then
				child:Destroy()
			end
		end
		
		-- Create cards
		if #boats > 0 then
			for _, boatData in ipairs(boats) do
				createBoatCard(boatData, ui.listContainer)
			end
			
			local layout = ui.listContainer:FindFirstChildOfClass("UIListLayout")
			if layout then
				ui.listContainer.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
			end
		else
			local noBoats = Instance.new("TextLabel")
			noBoats.Size = UDim2.new(1, 0, 0, 100)
			noBoats.BackgroundTransparency = 1
			noBoats.Text = "No boats available!\n\nAdd boat models to:\nServerStorage/BoatTemplates"
			noBoats.TextSize = 14
			noBoats.Font = Enum.Font.Gotham
			noBoats.TextColor3 = Colors.TextDim
			noBoats.TextWrapped = true
			noBoats.Parent = ui.listContainer
		end
		
		-- Show popup with animation
		ui.popup.Visible = true
		ui.popup.Position = UDim2.new(0.5, -200, 0.5, -220)
		ui.popup.BackgroundTransparency = 1
		
		TweenService:Create(ui.popup, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.5, -200, 0.5, -250),
			BackgroundTransparency = 0
		}):Play()
	else
		-- Hide popup with animation
		local tween = TweenService:Create(ui.popup, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(0.5, -200, 0.5, -220),
			BackgroundTransparency = 1
		})
		tween:Play()
		tween.Completed:Connect(function()
			if not isSpawnerOpen then
				ui.popup.Visible = false
			end
		end)
	end
end

-- Initialize spawner UI if remotes exist
if BoatSpawnerFolder then
	ui = createSpawnerUI()
	
	ui.floatButton.MouseButton1Click:Connect(toggleSpawnerPopup)
	ui.closeBtn.MouseButton1Click:Connect(function()
		if isSpawnerOpen then toggleSpawnerPopup() end
	end)
	
	-- Button hover effect
	ui.floatButton.MouseEnter:Connect(function()
		TweenService:Create(ui.floatButton, TweenInfo.new(0.2), {
			BackgroundColor3 = Colors.AccentHover,
			Size = UDim2.new(0, 65, 0, 65)
		}):Play()
	end)
	
	ui.floatButton.MouseLeave:Connect(function()
		TweenService:Create(ui.floatButton, TweenInfo.new(0.2), {
			BackgroundColor3 = Colors.Accent,
			Size = UDim2.new(0, 60, 0, 60)
		}):Play()
	end)
	
	print("🚤 [BOAT SPAWNER CLIENT] Initialized")
else
	print("🚤 [BOAT CLIENT] BoatSpawner folder not found - spawner UI disabled")
end

-- ==================== PUBLIC API ====================

_G.BoatHandler = {
	GetCurrentBoat = function()
		return currentBoat
	end,
	
	IsDriving = function()
		return isDriving
	end,
	
	GetDetectedBoats = function()
		return detectedBoats
	end
}

print("🚤 [BOAT CLIENT] Initialized (Combined Handler + Spawner)")

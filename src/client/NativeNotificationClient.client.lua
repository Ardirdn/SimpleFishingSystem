--[[
    NATIVE NOTIFICATION CLIENT
    Place in StarterPlayerScripts
    
    Mendengarkan RemoteEvent notifikasi dan menampilkan menggunakan
    sistem notifikasi bawaan Roblox (StarterGui:SetCore)
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

-- Wait for SetCore to be available
local function waitForCore()
	local success = false
	repeat
		success = pcall(function()
			StarterGui:SetCore("SendNotification", {
				Title = "Test",
				Text = "Test",
				Duration = 0.01
			})
		end)
		if not success then
			task.wait(0.5)
		end
	until success
end

-- Initialize SetCore
task.spawn(waitForCore)

-- Listen for notifications from all remote folders
local function listenToRemoteFolder(folderName)
	local remoteFolder = ReplicatedStorage:WaitForChild(folderName, 10)
	if not remoteFolder then return end
	
	local notifEvent = remoteFolder:FindFirstChild("NativeNotification")
	if notifEvent and notifEvent:IsA("RemoteEvent") then
		notifEvent.OnClientEvent:Connect(function(data)
			if not data then return end
			
			pcall(function()
				StarterGui:SetCore("SendNotification", {
					Title = data.Title or "Notification",
					Text = data.Text or data.Message or "",
					Icon = data.Icon or "",
					Duration = data.Duration or 3
				})
			end)
		end)
		print("✅ [NATIVE NOTIF] Listening to", folderName)
	end
end

-- Wait a bit for remotes to be created
task.wait(1)

-- Listen to known remote folders
listenToRemoteFolder("RodShopRemotes")
listenToRemoteFolder("FishermanShopRemotes")

print("✅ [NATIVE NOTIFICATION CLIENT] Loaded - Using Roblox built-in notifications")

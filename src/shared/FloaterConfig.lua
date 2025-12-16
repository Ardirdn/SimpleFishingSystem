--[[
    FLOATER CONFIG
    Place in ReplicatedStorage/Modules/FloaterConfig.lua
    
    SINGLE SOURCE OF TRUTH untuk semua data floater.
    Semua script lain (shop, fishing, client) harus ambil data dari sini.
    
    Setiap floater memiliki:
    - FloaterId: ID unik floater (harus sama dengan nama model di FishingRods/Floaters)
    - DisplayName: Nama yang ditampilkan di UI
    - Description: Deskripsi item
    - Price: Harga dalam game currency (0 = gratis)
    - Category: Kategori floater (Basic, Themed, Advanced, Legendary)
    - Rarity: Rarity floater (Common, Uncommon, Rare, Epic, Legendary)
    - LuckBonus: Bonus luck dalam persen
    - Thumbnail: Asset ID untuk thumbnail
    - IsPremium: Apakah item premium (beli dengan Robux)
    - ProductId: Developer Product ID jika premium
]]

local FloaterConfig = {}

-- Rarity colors (untuk reference)
FloaterConfig.RarityColors = {
	Common = Color3.fromRGB(200, 200, 200),
	Uncommon = Color3.fromRGB(100, 255, 100),
	Rare = Color3.fromRGB(80, 150, 255),
	Epic = Color3.fromRGB(200, 100, 255),
	Legendary = Color3.fromRGB(255, 170, 0)
}

-- Default floater ID (gratis untuk semua pemain baru)
FloaterConfig.DefaultFloater = "Floater_Doll"

-- ==================== FLOATER DATA ====================
FloaterConfig.Floaters = {
	-- ==================== BASIC FLOATERS ====================
	["Floater_Doll"] = {
		FloaterId = "Floater_Doll",
		DisplayName = "Doll Floater",
		Description = "Cute doll floater. Perfect for beginners!",
		Price = 0, -- Free starter
		Category = "Basic",
		Rarity = "Common",
		LuckBonus = 0,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["Floater_Cooper"] = {
		FloaterId = "Floater_Cooper",
		DisplayName = "Copper Floater",
		Description = "Durable copper floater that shines in the water.",
		Price = 500,
		Category = "Basic",
		Rarity = "Uncommon",
		LuckBonus = 10,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	
	-- ==================== THEMED FLOATERS ====================
	["Floater_Candy"] = {
		FloaterId = "Floater_Candy",
		DisplayName = "Candy Floater",
		Description = "Sweet candy-shaped floater that fish love!",
		Price = 800,
		Category = "Themed",
		Rarity = "Rare",
		LuckBonus = 15,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["Floater_skeleton"] = {
		FloaterId = "Floater_skeleton",
		DisplayName = "Skeleton Floater",
		Description = "Spooky skeleton floater for Halloween fishing!",
		Price = 1200,
		Category = "Themed",
		Rarity = "Rare",
		LuckBonus = 20,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["Floater_Fish_Bone"] = {
		FloaterId = "Floater_Fish_Bone",
		DisplayName = "Fish Bone Floater",
		Description = "Ironic fish bone floater. Fish find it intimidating!",
		Price = 1500,
		Category = "Themed",
		Rarity = "Rare",
		LuckBonus = 25,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["Floater_Pinguin"] = {
		FloaterId = "Floater_Pinguin",
		DisplayName = "Penguin Floater",
		Description = "Adorable penguin floater for arctic waters!",
		Price = 2000,
		Category = "Themed",
		Rarity = "Rare",
		LuckBonus = 30,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	
	-- ==================== ADVANCED FLOATERS ====================
	["Floater_Fantasy"] = {
		FloaterId = "Floater_Fantasy",
		DisplayName = "Fantasy Floater",
		Description = "Magical fantasy floater with mystical properties.",
		Price = 3000,
		Category = "Advanced",
		Rarity = "Epic",
		LuckBonus = 40,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["Floater_Scorpio"] = {
		FloaterId = "Floater_Scorpio",
		DisplayName = "Scorpio Floater",
		Description = "Zodiac-powered scorpion floater!",
		Price = 4000,
		Category = "Advanced",
		Rarity = "Epic",
		LuckBonus = 50,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	
	-- ==================== LEGENDARY FLOATERS ====================
	["Floater_Space"] = {
		FloaterId = "Floater_Space",
		DisplayName = "Space Floater",
		Description = "Cosmic space floater from another galaxy!",
		Price = 8000,
		Category = "Legendary",
		Rarity = "Legendary",
		LuckBonus = 75,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["Floater_Shark"] = {
		FloaterId = "Floater_Shark",
		DisplayName = "Shark Floater",
		Description = "Fierce shark floater that attracts big fish!",
		Price = 12000,
		Category = "Legendary",
		Rarity = "Legendary",
		LuckBonus = 100,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
}

-- ==================== HELPER FUNCTIONS ====================

-- Get floater by ID
function FloaterConfig.GetFloaterById(floaterId)
	return FloaterConfig.Floaters[floaterId]
end

-- Get all floaters as array (for shop display, ordered by price)
function FloaterConfig.GetFloatersArray()
	local floatersArray = {}
	for floaterId, floaterData in pairs(FloaterConfig.Floaters) do
		table.insert(floatersArray, floaterData)
	end
	
	-- Sort by price
	table.sort(floatersArray, function(a, b)
		return a.Price < b.Price
	end)
	
	return floatersArray
end

-- Get floaters by category
function FloaterConfig.GetFloatersByCategory(category)
	local result = {}
	for floaterId, floaterData in pairs(FloaterConfig.Floaters) do
		if floaterData.Category == category then
			table.insert(result, floaterData)
		end
	end
	return result
end

-- Get floater price
function FloaterConfig.GetPrice(floaterId)
	local floater = FloaterConfig.Floaters[floaterId]
	return floater and floater.Price or 0
end

-- Get floater luck bonus
function FloaterConfig.GetLuckBonus(floaterId)
	local floater = FloaterConfig.Floaters[floaterId]
	return floater and floater.LuckBonus or 0
end

-- Check if floater exists
function FloaterConfig.Exists(floaterId)
	return FloaterConfig.Floaters[floaterId] ~= nil
end

-- Get rarity color
function FloaterConfig.GetRarityColor(floaterId)
	local floater = FloaterConfig.Floaters[floaterId]
	if floater then
		return FloaterConfig.RarityColors[floater.Rarity] or FloaterConfig.RarityColors.Common
	end
	return FloaterConfig.RarityColors.Common
end

return FloaterConfig

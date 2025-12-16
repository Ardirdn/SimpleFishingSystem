--[[
    FISHING ROD CONFIG
    Place in ReplicatedStorage/Modules/FishingRod.config.lua
    
    SINGLE SOURCE OF TRUTH untuk semua data fishing rod.
    Semua script lain (shop, fishing, client) harus ambil data dari sini.
    
    Setiap rod memiliki:
    - FISHING STATS:
      - ToolName, ToolObject: Nama tool
      - FloaterObject: Default floater yang digunakan
      - MaxThrowDistance, ThrowHeight: Jarak dan tinggi lempar
      - BobSpeed, BobHeight: Animasi bobbing floater
      - LineStyle: Warna dan style tali pancing
    
    - SHOP DATA:
      - DisplayName: Nama yang ditampilkan di UI
      - Description: Deskripsi item
      - Price: Harga dalam game currency (0 = gratis)
      - Category: Kategori rod (Starter, Basic, Themed, Advanced, Legendary)
      - Rarity: Rarity rod (Common, Uncommon, Rare, Epic, Legendary)
      - CatchBonus: Bonus catch rate dalam persen
      - Thumbnail: Asset ID untuk thumbnail
      - IsPremium: Apakah item premium (beli dengan Robux)
      - ProductId: Developer Product ID jika premium
]]

local FishingRodConfig = {}

-- Rarity colors (untuk reference)
FishingRodConfig.RarityColors = {
	Common = Color3.fromRGB(200, 200, 200),
	Uncommon = Color3.fromRGB(100, 255, 100),
	Rare = Color3.fromRGB(80, 150, 255),
	Epic = Color3.fromRGB(200, 100, 255),
	Legendary = Color3.fromRGB(255, 170, 0)
}

-- Default rod ID (gratis untuk semua pemain baru)
FishingRodConfig.DefaultRod = "FishingRod_Wood1"

-- Default Line Style (used if not specified per rod)
FishingRodConfig.DefaultLineStyle = {
	Color = Color3.fromRGB(0, 255, 255),
	Width = 0.16,
	Transparency = 0.12,
	LightEmission = 10,
	IsNeon = true
}

FishingRodConfig.Rods = {
	-- ==================== STARTER RODS ====================
	["FishingRod_Wood1"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Wood1",
		ToolObject = "FishingRod_Wood1",
		FloaterObject = "Floater_Doll",
		MaxThrowDistance = 35,
		ThrowHeight = 9,
		BobSpeed = 2.5,
		BobHeight = 0.4,
		LineStyle = {
			Color = Color3.fromRGB(139, 90, 43), -- Brown (wooden)
			Width = 0.12,
			Transparency = 0.2,
			LightEmission = 0,
			IsNeon = false
		},
		-- Shop Data
		DisplayName = "Wooden Rod",
		Description = "Basic wooden fishing rod. Perfect for beginners!",
		Price = 0, -- Free starter
		Category = "Starter",
		Rarity = "Common",
		CatchBonus = 0,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["FishingRod_Bamboo"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Bamboo",
		ToolObject = "FishingRod_Bamboo",
		FloaterObject = "Floater_Doll",
		MaxThrowDistance = 40,
		ThrowHeight = 10,
		BobSpeed = 2.2,
		BobHeight = 0.4,
		LineStyle = {
			Color = Color3.fromRGB(107, 142, 35), -- Olive green (bamboo)
			Width = 0.12,
			Transparency = 0.2,
			LightEmission = 0,
			IsNeon = false
		},
		-- Shop Data
		DisplayName = "Bamboo Rod",
		Description = "Lightweight bamboo rod with decent range.",
		Price = 250,
		Category = "Starter",
		Rarity = "Common",
		CatchBonus = 5,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},

	-- ==================== BASIC RODS ====================
	["FishingRod_Copper"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Copper",
		ToolObject = "FishingRod_Copper",
		FloaterObject = "Floater_Cooper",
		MaxThrowDistance = 55,
		ThrowHeight = 16,
		BobSpeed = 2,
		BobHeight = 0.5,
		LineStyle = {
			Color = Color3.fromRGB(184, 115, 51), -- Copper orange
			Width = 0.14,
			Transparency = 0.15,
			LightEmission = 2,
			IsNeon = false
		},
		-- Shop Data
		DisplayName = "Copper Rod",
		Description = "Durable copper rod with improved casting.",
		Price = 500,
		Category = "Basic",
		Rarity = "Uncommon",
		CatchBonus = 10,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["FishingRod_Anchor"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Anchor",
		ToolObject = "FishingRod_Anchor",
		FloaterObject = "Floater_Cooper",
		MaxThrowDistance = 45,
		ThrowHeight = 12,
		BobSpeed = 2.5,
		BobHeight = 0.4,
		LineStyle = {
			Color = Color3.fromRGB(70, 70, 80), -- Dark steel
			Width = 0.18,
			Transparency = 0.1,
			LightEmission = 0,
			IsNeon = false
		},
		-- Shop Data
		DisplayName = "Anchor Rod",
		Description = "Heavy-duty rod inspired by ship anchors.",
		Price = 750,
		Category = "Basic",
		Rarity = "Uncommon",
		CatchBonus = 12,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["FishingRod_Tribe"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Tribe",
		ToolObject = "FishingRod_Tribe",
		FloaterObject = "Floater_skeleton",
		MaxThrowDistance = 46,
		ThrowHeight = 12,
		BobSpeed = 2.2,
		BobHeight = 0.4,
		LineStyle = {
			Color = Color3.fromRGB(139, 69, 19), -- Saddle brown
			Width = 0.16,
			Transparency = 0.15,
			LightEmission = 1,
			IsNeon = false
		},
		-- Shop Data
		DisplayName = "Tribal Rod",
		Description = "Ancient tribal design with mystical powers.",
		Price = 850,
		Category = "Basic",
		Rarity = "Uncommon",
		CatchBonus = 15,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},

	-- ==================== THEMED RODS ====================
	["FishingRod_Banana"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Banana",
		ToolObject = "FishingRod_Banana",
		FloaterObject = "Floater_Candy",
		MaxThrowDistance = 48,
		ThrowHeight = 13,
		BobSpeed = 2,
		BobHeight = 0.5,
		LineStyle = {
			Color = Color3.fromRGB(255, 225, 53), -- Bright yellow
			Width = 0.14,
			Transparency = 0.12,
			LightEmission = 3,
			IsNeon = true
		},
		-- Shop Data
		DisplayName = "Banana Rod",
		Description = "A-peel-ing rod that's perfect for tropical fishing!",
		Price = 1200,
		Category = "Themed",
		Rarity = "Rare",
		CatchBonus = 20,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["FishingRod_Bacon"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Bacon",
		ToolObject = "FishingRod_Bacon",
		FloaterObject = "Floater_Candy",
		MaxThrowDistance = 50,
		ThrowHeight = 14,
		BobSpeed = 2,
		BobHeight = 0.5,
		LineStyle = {
			Color = Color3.fromRGB(200, 80, 60), -- Bacon red-brown
			Width = 0.14,
			Transparency = 0.15,
			LightEmission = 2,
			IsNeon = false
		},
		-- Shop Data
		DisplayName = "Bacon Rod",
		Description = "Crispy and delicious... wait, for fishing?!",
		Price = 1300,
		Category = "Themed",
		Rarity = "Rare",
		CatchBonus = 22,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["FishingRod_Love"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Love",
		ToolObject = "FishingRod_Love",
		FloaterObject = "Floater_Candy",
		MaxThrowDistance = 54,
		ThrowHeight = 15,
		BobSpeed = 1.8,
		BobHeight = 0.6,
		LineStyle = {
			Color = Color3.fromRGB(255, 105, 180), -- Hot pink
			Width = 0.16,
			Transparency = 0.1,
			LightEmission = 8,
			IsNeon = true
		},
		-- Shop Data
		DisplayName = "Love Rod",
		Description = "Spread love while catching fish! ❤️",
		Price = 1500,
		Category = "Themed",
		Rarity = "Rare",
		CatchBonus = 25,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["FishingRod_Bat"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Bat",
		ToolObject = "FishingRod_Bat",
		FloaterObject = "Floater_skeleton",
		MaxThrowDistance = 52,
		ThrowHeight = 15,
		BobSpeed = 2.3,
		BobHeight = 0.5,
		LineStyle = {
			Color = Color3.fromRGB(75, 0, 130), -- Dark purple
			Width = 0.16,
			Transparency = 0.1,
			LightEmission = 5,
			IsNeon = true
		},
		-- Shop Data
		DisplayName = "Bat Rod",
		Description = "Perfect for night fishing and spooky vibes.",
		Price = 1600,
		Category = "Themed",
		Rarity = "Rare",
		CatchBonus = 28,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["FishingRod_Crab"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Crab",
		ToolObject = "FishingRod_Crab",
		FloaterObject = "Floater_Fish_Bone",
		MaxThrowDistance = 50,
		ThrowHeight = 14,
		BobSpeed = 2.1,
		BobHeight = 0.5,
		LineStyle = {
			Color = Color3.fromRGB(255, 99, 71), -- Tomato red (crab)
			Width = 0.15,
			Transparency = 0.12,
			LightEmission = 3,
			IsNeon = false
		},
		-- Shop Data
		DisplayName = "Crab Rod",
		Description = "Pinch your way to victory!",
		Price = 1800,
		Category = "Themed",
		Rarity = "Rare",
		CatchBonus = 30,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},

	-- ==================== ADVANCED RODS ====================
	["FishingRod_Seal"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Seal",
		ToolObject = "FishingRod_Seal",
		FloaterObject = "Floater_Pinguin",
		MaxThrowDistance = 52,
		ThrowHeight = 14,
		BobSpeed = 2,
		BobHeight = 0.5,
		LineStyle = {
			Color = Color3.fromRGB(176, 224, 230), -- Powder blue (arctic)
			Width = 0.16,
			Transparency = 0.1,
			LightEmission = 5,
			IsNeon = true
		},
		-- Shop Data
		DisplayName = "Seal Rod",
		Description = "Arctic-inspired rod for cold water fishing.",
		Price = 2500,
		Category = "Advanced",
		Rarity = "Epic",
		CatchBonus = 35,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["FishingRod_Mercusuar"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Mercusuar",
		ToolObject = "FishingRod_Mercusuar",
		FloaterObject = "Floater_Pinguin",
		MaxThrowDistance = 56,
		ThrowHeight = 16,
		BobSpeed = 2.1,
		BobHeight = 0.5,
		LineStyle = {
			Color = Color3.fromRGB(255, 255, 0), -- Bright yellow (lighthouse)
			Width = 0.18,
			Transparency = 0.05,
			LightEmission = 10,
			IsNeon = true
		},
		-- Shop Data
		DisplayName = "Lighthouse Rod",
		Description = "Guide your catches like a beacon in the night.",
		Price = 2800,
		Category = "Advanced",
		Rarity = "Epic",
		CatchBonus = 38,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["FishingRod_Knight"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Knight",
		ToolObject = "FishingRod_Knight",
		FloaterObject = "Floater_Cooper",
		MaxThrowDistance = 58,
		ThrowHeight = 16,
		BobSpeed = 2.2,
		BobHeight = 0.5,
		LineStyle = {
			Color = Color3.fromRGB(192, 192, 192), -- Silver (armor)
			Width = 0.18,
			Transparency = 0.1,
			LightEmission = 3,
			IsNeon = false
		},
		-- Shop Data
		DisplayName = "Knight Rod",
		Description = "Medieval power for honorable anglers.",
		Price = 3000,
		Category = "Advanced",
		Rarity = "Epic",
		CatchBonus = 40,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["FishingRod_Dryad"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Dryad",
		ToolObject = "FishingRod_Dryad",
		FloaterObject = "Floater_Doll",
		MaxThrowDistance = 60,
		ThrowHeight = 17,
		BobSpeed = 2,
		BobHeight = 0.5,
		LineStyle = {
			Color = Color3.fromRGB(34, 139, 34), -- Forest green
			Width = 0.16,
			Transparency = 0.1,
			LightEmission = 6,
			IsNeon = true
		},
		-- Shop Data
		DisplayName = "Dryad Rod",
		Description = "Nature's blessing in rod form.",
		Price = 3500,
		Category = "Advanced",
		Rarity = "Epic",
		CatchBonus = 45,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["FishingRod_Dryad2"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Dryad2",
		ToolObject = "FishingRod_Dryad2",
		FloaterObject = "Floater_Doll",
		MaxThrowDistance = 62,
		ThrowHeight = 17,
		BobSpeed = 2,
		BobHeight = 0.5,
		LineStyle = {
			Color = Color3.fromRGB(0, 255, 127), -- Spring green
			Width = 0.16,
			Transparency = 0.08,
			LightEmission = 8,
			IsNeon = true
		},
		-- Shop Data
		DisplayName = "Dryad Rod II",
		Description = "Enhanced nature rod with deeper connection.",
		Price = 4000,
		Category = "Advanced",
		Rarity = "Epic",
		CatchBonus = 48,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["FishingRod_Scorpio"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Scorpio",
		ToolObject = "FishingRod_Scorpio",
		FloaterObject = "Floater_Scorpio",
		MaxThrowDistance = 64,
		ThrowHeight = 18,
		BobSpeed = 2,
		BobHeight = 0.5,
		LineStyle = {
			Color = Color3.fromRGB(128, 0, 0), -- Maroon (scorpion)
			Width = 0.16,
			Transparency = 0.1,
			LightEmission = 5,
			IsNeon = true
		},
		-- Shop Data
		DisplayName = "Scorpio Rod",
		Description = "Strike with the precision of a scorpion!",
		Price = 4500,
		Category = "Advanced",
		Rarity = "Epic",
		CatchBonus = 50,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["FishingRod_Alien"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Alien",
		ToolObject = "FishingRod_Alien",
		FloaterObject = "Floater_Fantasy",
		MaxThrowDistance = 65,
		ThrowHeight = 18,
		BobSpeed = 2,
		BobHeight = 0.5,
		LineStyle = {
			Color = Color3.fromRGB(0, 255, 0), -- Alien green
			Width = 0.18,
			Transparency = 0.05,
			LightEmission = 10,
			IsNeon = true
		},
		-- Shop Data
		DisplayName = "Alien Rod",
		Description = "Out-of-this-world fishing technology!",
		Price = 5000,
		Category = "Advanced",
		Rarity = "Epic",
		CatchBonus = 55,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["FishingRod_Marlin"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Marlin",
		ToolObject = "FishingRod_Marlin",
		FloaterObject = "Floater_Fish_Bone",
		MaxThrowDistance = 68,
		ThrowHeight = 19,
		BobSpeed = 2,
		BobHeight = 0.5,
		LineStyle = {
			Color = Color3.fromRGB(0, 191, 255), -- Deep sky blue (ocean)
			Width = 0.16,
			Transparency = 0.1,
			LightEmission = 6,
			IsNeon = true
		},
		-- Shop Data
		DisplayName = "Marlin Rod",
		Description = "Built for catching the biggest marlins.",
		Price = 5500,
		Category = "Advanced",
		Rarity = "Epic",
		CatchBonus = 58,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},

	-- ==================== LEGENDARY RODS ====================
	["FishingRod_Angel"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Angel",
		ToolObject = "FishingRod_Angel",
		FloaterObject = "Floater_Fantasy",
		MaxThrowDistance = 70,
		ThrowHeight = 22,
		BobSpeed = 1.8,
		BobHeight = 0.6,
		LineStyle = {
			Color = Color3.fromRGB(255, 255, 255), -- Pure white (divine)
			Width = 0.18,
			Transparency = 0.05,
			LightEmission = 10,
			IsNeon = true
		},
		-- Shop Data
		DisplayName = "Angel Rod",
		Description = "Divine rod blessed by the heavens.",
		Price = 7000,
		Category = "Legendary",
		Rarity = "Legendary",
		CatchBonus = 65,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["FishingRod_Angel2"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Angel2",
		ToolObject = "FishingRod_Angel2",
		FloaterObject = "Floater_Fantasy",
		MaxThrowDistance = 72,
		ThrowHeight = 22,
		BobSpeed = 1.8,
		BobHeight = 0.6,
		LineStyle = {
			Color = Color3.fromRGB(255, 250, 205), -- Golden white
			Width = 0.18,
			Transparency = 0.05,
			LightEmission = 10,
			IsNeon = true
		},
		-- Shop Data
		DisplayName = "Angel Rod II",
		Description = "Enhanced divine rod with heavenly power.",
		Price = 8500,
		Category = "Legendary",
		Rarity = "Legendary",
		CatchBonus = 70,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["FishingRod_Angel3"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Angel3",
		ToolObject = "FishingRod_Angel3",
		FloaterObject = "Floater_Fantasy",
		MaxThrowDistance = 75,
		ThrowHeight = 23,
		BobSpeed = 1.8,
		BobHeight = 0.6,
		LineStyle = {
			Color = Color3.fromRGB(255, 215, 0), -- Golden
			Width = 0.20,
			Transparency = 0.03,
			LightEmission = 10,
			IsNeon = true
		},
		-- Shop Data
		DisplayName = "Angel Rod III",
		Description = "Ultimate divine rod, closest to the heavens.",
		Price = 9500,
		Category = "Legendary",
		Rarity = "Legendary",
		CatchBonus = 75,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["FishingRod_Robot"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Robot",
		ToolObject = "FishingRod_Robot",
		FloaterObject = "Floater_Space",
		MaxThrowDistance = 70,
		ThrowHeight = 20,
		BobSpeed = 1.9,
		BobHeight = 0.6,
		LineStyle = {
			Color = Color3.fromRGB(0, 255, 255), -- Cyan (electric)
			Width = 0.18,
			Transparency = 0.05,
			LightEmission = 10,
			IsNeon = true
		},
		-- Shop Data
		DisplayName = "Robot Rod",
		Description = "Cutting-edge robotic fishing technology.",
		Price = 10000,
		Category = "Legendary",
		Rarity = "Legendary",
		CatchBonus = 80,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["FishingRod_Shark"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Shark",
		ToolObject = "FishingRod_Shark",
		FloaterObject = "Floater_Shark",
		MaxThrowDistance = 75,
		ThrowHeight = 21,
		BobSpeed = 1.8,
		BobHeight = 0.6,
		LineStyle = {
			Color = Color3.fromRGB(70, 130, 180), -- Steel blue (shark)
			Width = 0.20,
			Transparency = 0.08,
			LightEmission = 5,
			IsNeon = true
		},
		-- Shop Data
		DisplayName = "Shark Rod",
		Description = "Harness the power of the ocean's apex predator!",
		Price = 12000,
		Category = "Legendary",
		Rarity = "Legendary",
		CatchBonus = 85,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["FishingRod_Space"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Space",
		ToolObject = "FishingRod_Space",
		FloaterObject = "Floater_Space",
		MaxThrowDistance = 80,
		ThrowHeight = 24,
		BobSpeed = 1.7,
		BobHeight = 0.7,
		LineStyle = {
			Color = Color3.fromRGB(138, 43, 226), -- Blue violet (cosmic)
			Width = 0.20,
			Transparency = 0.05,
			LightEmission = 10,
			IsNeon = true
		},
		-- Shop Data
		DisplayName = "Space Rod",
		Description = "Fish among the stars with cosmic power!",
		Price = 15000,
		Category = "Legendary",
		Rarity = "Legendary",
		CatchBonus = 95,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	},
	["FishingRod_Dragon"] = {
		-- Fishing Stats
		ToolName = "FishingRod_Dragon",
		ToolObject = "FishingRod_Dragon",
		FloaterObject = "Floater_Fantasy",
		MaxThrowDistance = 85,
		ThrowHeight = 25,
		BobSpeed = 1.5,
		BobHeight = 0.7,
		LineStyle = {
			Color = Color3.fromRGB(255, 69, 0), -- Orange red (dragon fire)
			Width = 0.22,
			Transparency = 0.03,
			LightEmission = 10,
			IsNeon = true
		},
		-- Shop Data
		DisplayName = "Dragon Rod",
		Description = "The ultimate rod. Legendary dragon power!",
		Price = 20000,
		Category = "Legendary",
		Rarity = "Legendary",
		CatchBonus = 100,
		Thumbnail = "rbxassetid://7733764811",
		IsPremium = false,
		ProductId = nil
	}
}

-- ==================== HELPER FUNCTIONS ====================

-- Get rod config by ID
function FishingRodConfig.GetRodById(rodId)
	return FishingRodConfig.Rods[rodId]
end

-- Get LineStyle for a rod
function FishingRodConfig.GetLineStyle(rodName)
	local rodConfig = FishingRodConfig.Rods[rodName]
	if rodConfig and rodConfig.LineStyle then
		return rodConfig.LineStyle
	end
	return FishingRodConfig.DefaultLineStyle
end

-- Get all rods as array (for shop display, ordered by price)
function FishingRodConfig.GetRodsArray()
	local rodsArray = {}
	for rodId, rodData in pairs(FishingRodConfig.Rods) do
		-- Create a copy with RodId field for compatibility
		local rodWithId = {}
		for k, v in pairs(rodData) do
			rodWithId[k] = v
		end
		rodWithId.RodId = rodId
		table.insert(rodsArray, rodWithId)
	end
	
	-- Sort by price
	table.sort(rodsArray, function(a, b)
		return a.Price < b.Price
	end)
	
	return rodsArray
end

-- Get rods by category
function FishingRodConfig.GetRodsByCategory(category)
	local result = {}
	for rodId, rodData in pairs(FishingRodConfig.Rods) do
		if rodData.Category == category then
			local rodWithId = {}
			for k, v in pairs(rodData) do
				rodWithId[k] = v
			end
			rodWithId.RodId = rodId
			table.insert(result, rodWithId)
		end
	end
	return result
end

-- Get rod price
function FishingRodConfig.GetPrice(rodId)
	local rod = FishingRodConfig.Rods[rodId]
	return rod and rod.Price or 0
end

-- Get catch bonus
function FishingRodConfig.GetCatchBonus(rodId)
	local rod = FishingRodConfig.Rods[rodId]
	return rod and rod.CatchBonus or 0
end

-- Check if rod exists
function FishingRodConfig.Exists(rodId)
	return FishingRodConfig.Rods[rodId] ~= nil
end

-- Get rarity color
function FishingRodConfig.GetRarityColor(rodId)
	local rod = FishingRodConfig.Rods[rodId]
	if rod then
		return FishingRodConfig.RarityColors[rod.Rarity] or FishingRodConfig.RarityColors.Common
	end
	return FishingRodConfig.RarityColors.Common
end

-- Get default floater for a rod
function FishingRodConfig.GetDefaultFloater(rodId)
	local rod = FishingRodConfig.Rods[rodId]
	return rod and rod.FloaterObject or "Floater_Doll"
end

return FishingRodConfig

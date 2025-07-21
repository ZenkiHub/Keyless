local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PetHatchGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local petTable = {
	["Common Egg"] = { "Dog", "Bunny", "Golden Lab" },
	["Uncommon Egg"] = { "Chicken", "Black Bunny", "Cat", "Deer" },
	["Common Summer Egg"] = { "Starfish", "Seagull", "Crab" },
	["Rare Egg"] = { "Pig", "Monkey", "Rooster", "Orange Tabby", "Spotted Deer" },
	["Legendary Egg"] = { "Cow", "Polar Bear", "Sea Otter", "Turtle", "Silver Monkey" },
	["Mythical Egg"] = { "Grey Mouse", "Brown Mouse", "Squirrel", "Red Giant Ant" },
	["Bug Egg"] = { "Snail", "Caterpillar", "Giant Ant", "Praying Mantis" },
	["Night Egg"] = { "Frog", "Hedgehog", "Mole", "Echo Frog", "Night Owl" },
	["Bee Egg"] = { "Bee", "Honey Bee", "Bear Bee", "Petal Bee" },
	["AntiBee Egg"] = { "Wasp", "Moth", "Tarantula Hawk" },
	["Oasis Egg"] = { "Meerkat", "Sand Snake", "Axolotl" },
	["Paradise Egg"] = { "Ostrich", "Peacock", "Capybara" },
	["Dinosaurs Egg"] = { "Raptor", "Triceratops", "Stegosaurus" },
	["Primal Egg"] = { "Parasaurolophus", "Iguanodon", "Pachycephalosaurus" },
	["Zen Egg"] = { "Shiba Inu", "Nihonzaru", "Tanuki", "Tanchozuru", "Kappa", "Kitsune" },
}

local truePetMap = {}
local espEnabled = true

local function glitchLabelEffect(label)
	coroutine.wrap(function()
		local original = label.TextColor3
		for i = 1, 2 do
			label.TextColor3 = Color3.new(1, 0, 0)
			wait(0.07)
			label.TextColor3 = original
			wait(0.07)
		end
	end)()
end

local function applyEggESP(eggModel, petName)
	local label = eggModel:FindFirstChild("PetBillboard", true)
	if label then label:Destroy() end
	local highlight = eggModel:FindFirstChild("ESPHighlight")
	if highlight then highlight:Destroy() end
	if not espEnabled then return end

	local basePart = eggModel:FindFirstChildWhichIsA("BasePart")
	if not basePart then return end

	local ready = true
	local hatchTime = eggModel:FindFirstChild("HatchTime")
	local readyFlag = eggModel:FindFirstChild("ReadyToHatch")
	if (hatchTime and hatchTime.Value > 0) or (readyFlag and not readyFlag.Value) then
		ready = false
	end

	local billboard = Instance.new("BillboardGui", basePart)
	billboard.Name = "PetBillboard"
	billboard.Size = UDim2.new(0, 270, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 4.5, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 500

	local textLabel = Instance.new("TextLabel", billboard)
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = eggModel.Name .. " | " .. petName
	textLabel.TextColor3 = ready and Color3.new(1, 1, 1) or Color3.fromRGB(160, 160, 160)
	textLabel.TextStrokeTransparency = ready and 0 or 0.5
	textLabel.TextScaled = true
	textLabel.Font = Enum.Font.FredokaOne

	glitchLabelEffect(textLabel)

	local hl = Instance.new("Highlight", eggModel)
	hl.Name = "ESPHighlight"
	hl.FillColor = Color3.fromRGB(255, 200, 0)
	hl.OutlineColor = Color3.new(1, 1, 1)
	hl.FillTransparency = 0.7
end

-- 🧱 Main Frame
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 270, 0, 300)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 128)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- 🌈 Rainbow Glow Border (Enhanced Loop)
local stroke = Instance.new("UIStroke")
stroke.Thickness = 2 -- Stronger border
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.LineJoinMode = Enum.LineJoinMode.Round
stroke.Transparency = 5
stroke.Parent = frame

-- Optional: Add glow-style inner stroke with transparency for extra glow
local innerGlow = Instance.new("UIStroke")
innerGlow.Thickness = 100
innerGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
innerGlow.LineJoinMode = Enum.LineJoinMode.Round
innerGlow.Transparency = 0.5 -- Semi-transparent glow
innerGlow.Parent = frame

RunService.RenderStepped:Connect(function()
	local hue = tick() % 5 / 5
	local rainbowColor = Color3.fromHSV(hue, 1, 1)
	stroke.Color = ColorSequence.new(rainbowColor)
	innerGlow.Color = ColorSequence.new(rainbowColor)
end)

-- 🏷️ Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🦝Pet Randomizer X\nMutation🐉"
title.Font = Enum.Font.FredokaOne
title.TextSize = 19
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextWrapped = true

-- 🧰 Utility Functions
local function createBtn(text, yPos, color)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.BackgroundColor3 = color
	btn.Text = text
	btn.TextSize = 18
	btn.Font = Enum.Font.FredokaOne
	btn.TextColor3 = Color3.new(1, 1, 1)
	return btn
end

local function flashEffect(button)
	local orig = button.BackgroundColor3
	for i = 1, 3 do
		button.BackgroundColor3 = Color3.new(1, 1, 1)
		wait(0.05)
		button.BackgroundColor3 = orig
		wait(0.05)
	end
end

local function getPlayerGardenEggs(radius)
	local eggs = {}
	local char = player.Character or player.CharacterAdded:Wait()
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return eggs end

	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("Model") and petTable[obj.Name] then
			local dist = (obj:GetModelCFrame().Position - root.Position).Magnitude
			if dist <= (radius or 60) then
				if not truePetMap[obj] then
					local pets = petTable[obj.Name]
					truePetMap[obj] = pets[math.random(#pets)]
				end
				table.insert(eggs, obj)
			end
		end
	end
	return eggs
end

local function randomizeNearbyEggs()
	for _, egg in ipairs(getPlayerGardenEggs()) do
		local pets = petTable[egg.Name]
		truePetMap[egg] = pets[math.random(#pets)]
		applyEggESP(egg, truePetMap[egg])
	end
end

local function countdownAndRandomize(btn)
	for i = 10, 1, -1 do
		btn.Text = "🔄 Randomize in " .. i
		wait(1)
	end
	flashEffect(btn)
	randomizeNearbyEggs()
	btn.Text = "🎲 Randomize Pets"
end

-- 🎲 Randomize Button
local btnRand = createBtn("🎲 Randomize Pets", 40, Color3.fromRGB(0, 102, 204))
btnRand.MouseButton1Click:Connect(function()
	countdownAndRandomize(btnRand)
end)

-- 👁 ESP Toggle Button
local btnToggle = createBtn("👁 ESP: ON", 90, Color3.fromRGB(255, 215, 0))
btnToggle.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	btnToggle.Text = espEnabled and "👁 ESP: ON" or "👁 ESP: OFF"
	for _, egg in ipairs(getPlayerGardenEggs()) do
		if espEnabled then
			applyEggESP(egg, truePetMap[egg])
		else
			local b = egg:FindFirstChild("PetBillboard", true)
			if b then b:Destroy() end
			local h = egg:FindFirstChild("ESPHighlight")
			if h then h:Destroy() end
		end
	end
end)

-- 🔁 Auto Random Button
local autoRunning = false
local btnAuto = createBtn("🔁 Auto Randomize: OFF", 140, Color3.fromRGB(128, 0, 0))
local bestPets = {
	["Raccoon"] = true, ["Kitsune"] = true, ["Queen Bee"] = true,
	["T-Rex"] = true, ["Spinosaurus"] = true
}
btnAuto.MouseButton1Click:Connect(function()
	autoRunning = not autoRunning
	btnAuto.Text = autoRunning and "🔁 Auto Randomize: ON" or "🔁 Auto Randomize: OFF"
	coroutine.wrap(function()
		while autoRunning do
			countdownAndRandomize(btnRand)
			for _, name in pairs(truePetMap) do
				if bestPets[name] then
					autoRunning = false
					btnAuto.Text = "🔁 Auto Randomize: OFF"
					break
				end
			end
			wait(1)
		end
	end)()
end)

-- 🧬 Mutation Section
local mutations = {
	"Shiny", "Inverted", "Frozen", "Windy", "Golden", "Mega", "Tiny",
	"Tranquil", "IronSkin", "Radiant", "Rainbow", "Shocked", "Ascended"
}
local currentMutation = mutations[math.random(#mutations)]
local espVisible = true
local mutationLabel = nil

local function findMachine()
	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("Model") and obj.Name:lower():find("mutation") then
			return obj
		end
	end
end

local function createMutationESP()
	local machine = findMachine()
	if not machine then return end
	local base = machine:FindFirstChildWhichIsA("BasePart")
	if not base then return end

	local gui = Instance.new("BillboardGui", base)
	gui.Name = "MutationESP"
	gui.Adornee = base
	gui.Size = UDim2.new(0, 200, 0, 40)
	gui.StudsOffset = Vector3.new(0, 3, 0)
	gui.AlwaysOnTop = true

	local label = Instance.new("TextLabel", gui)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.TextSize = 24
	label.TextStrokeTransparency = 0.3
	label.TextStrokeColor3 = Color3.new(0, 0, 0)
	label.Text = currentMutation

	RunService.RenderStepped:Connect(function()
		if espVisible then
			label.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
		end
	end)

	return label
end

-- 👁 Mutation ESP Toggle
local btnFinder = createBtn("👁 Toggle Mutation ESP", 190, Color3.fromRGB(255, 215, 0))
btnFinder.MouseButton1Click:Connect(function()
	if mutationLabel then
		espVisible = not espVisible
		mutationLabel.Visible = espVisible
	else
		mutationLabel = createMutationESP()
	end
end)

-- 🎲 Mutation Reroll
local btnReroll = createBtn("🎲 Mutation Reroll", 235, Color3.fromRGB(0, 102, 204))
btnReroll.MouseButton1Click:Connect(function()
	btnReroll.Text = "⏳ Rerolling..."
	for i = 1, 20 do
		mutationLabel.Text = mutations[math.random(#mutations)]
		wait(0.05)
	end
	currentMutation = mutations[math.random(#mutations)]
	mutationLabel.Text = currentMutation
	btnReroll.Text = "🎲 Mutation Reroll"
end)

-- ❌ Close Button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -28, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.Text = "❌"
closeBtn.Font = Enum.Font.FredokaOne
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

-- 🔁 Reopen Button
local reopenBtn = Instance.new("TextButton", screenGui)
reopenBtn.Size = UDim2.new(0, 50, 0, 30)
reopenBtn.Position = UDim2.new(0, 10, 0, 10)
reopenBtn.BackgroundColor3 = Color3.fromRGB(0, 128, 255)
reopenBtn.Text = "🔁"
reopenBtn.TextSize = 20
reopenBtn.Font = Enum.Font.FredokaOne
reopenBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", reopenBtn).CornerRadius = UDim.new(0, 8)
reopenBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- 🖋 Credit
local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1, 0, 0, 20)
credit.Position = UDim2.new(0, 0, 0, 275)
credit.BackgroundTransparency = 1
credit.Text = "Made by - Zenkiii"
credit.Font = Enum.Font.FredokaOne
credit.TextSize = 14
credit.TextColor3 = Color3.fromRGB(200, 200, 200)
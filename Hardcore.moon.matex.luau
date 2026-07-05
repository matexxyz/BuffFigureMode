local Spawner = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"
))()

local EntityList = {
    {
        Weight = 30,
        Data = {
            Name = "Depth",
            Asset = "https://github.com/MateiDaBest/Utilities/raw/refs/heads/main/Doors/Other/DepthMoving.rbxm",
            Speed = 100,
            Rebounds = 1
        }
    },
    {
        Weight = 30,
        Data = {
            Name = "STUPID HORSE",
            Asset = "https://github.com/MateiDaBest/Utilities/raw/refs/heads/main/Doors/Other/Stupid%20Horse.rbxm",
            Speed = 100,
            Rebounds = 1
        }
    },
    {
        Weight = 9,
        Data = {
            Name = "OG Ambush",
            Asset = "https://github.com/MateiDaBest/Utilities/raw/refs/heads/main/Doors/Other/AmbushMoving.rbxm",
            Speed = 100,
            Rebounds = math.random(2,4)
        }
    },
    {
        Weight = 15,
        Data = {
            Name = "A-60",
            Asset = "https://github.com/Idk-lol2/a-60aa/blob/main/11379072534.rbxm?raw=true",
            Speed = 135,
            Rebounds = 0
        }
    }
}

-- MUST come BEFORE Spawn
local function Choose()
    local total = 0

    for _, v in ipairs(EntityList) do
        total += v.Weight
    end

    local pick = math.random() * total
    local current = 0

    for _, v in ipairs(EntityList) do
        current += v.Weight
        if pick <= current then
            return v.Data
        end
    end
end

-- ONLY ONE Spawn FUNCTION
local function Spawn()

    local E = Choose()
    if not E then return end

    Spawner.Create({

        Entity = {
            Name = E.Name,
            Asset = E.Asset,
            HeightOffset = 0
        },

        Lights = {
            Flicker = {Enabled = true, Duration = 3},
            Shatter = true,
            Repair = false
        },

        CameraShake = {
            Enabled = true,
            Range = 100,
            Values = {2,20,0.2,1}
        },

        Movement = {
            Speed = E.Speed,
            Delay = 2,
            Reversed = false
        },

        Rebounding = {
            Enabled = E.Rebounds > 0,
            Type = "Ambush",
            Min = E.Rebounds,
            Max = E.Rebounds,
            Delay = 2
        },

        Damage = {
            Enabled = true,
            Range = 40,
            Amount = 125
        },

        Crucifixion = {
            Enabled = true,
            Range = 40,
            Resist = false,
            Break = true
        }

    }):Run()
end

-- BUFF FIGURE [ SEEK ]

local function ApplySeekFix(model)

    if not model then return end

    for _, obj in ipairs(model:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Decal") then
            obj.Transparency = 1
        end
    end

    local Figure = game:GetObjects("rbxassetid://17147503424")[1]
    if not Figure then return end

    Figure.Body.Weld.C0 =
        CFrame.new(0,0,0) *
        CFrame.Angles(0, math.rad(180), 0)

    if model:FindFirstChild("SeekRig") and model.SeekRig:FindFirstChild("UpperTorso") then
        Figure.Body.Weld.Part1 = model.SeekRig.UpperTorso
        Figure.Parent = model.SeekRig
    end
end

-- existing ones
task.spawn(function()
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name == "SeekMoving" or v.Name == "SeekMovingNewClone" then
            ApplySeekFix(v)
        end
    end
end)

-- future ones
workspace.ChildAdded:Connect(function(v)
    if v.Name == "SeekMoving" or v.Name == "SeekMovingNewClone" then
        task.wait(0.1)
        ApplySeekFix(v)
    end
end)

-- BUFF FIGURE [ RAINBOW FIGURE ]

-- FIGURE SYSTEM

local RunService = game:GetService("RunService")

local function Rainbowify(model)
    local parts = {}

    for _, obj in ipairs(model:GetDescendants()) do
        if obj:IsA("BasePart") then
            table.insert(parts, obj)
        end
    end

    task.spawn(function()
        local t = 0

        while model and model.Parent do
            t += 0.02

            local color = Color3.fromHSV(t % 1, 1, 1)

            for _, part in ipairs(parts) do
                if part and part.Parent then
                    part.Color = color
                end
            end

            RunService.Heartbeat:Wait()
        end
    end)
end


local function Setup(room)

    local Figure = room:FindFirstChild("FigureSetup")
    if not Figure then return end

    local rig = Figure:FindFirstChild("FigureRig")
    if not rig then return end

    if rig:GetAttribute("FigureDone") then return end
    rig:SetAttribute("FigureDone", true)

    for _, obj in ipairs(rig:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Decal") then
            obj.Transparency = 1
        end
    end

    local BigFigure = game:GetObjects("rbxassetid://80300729404499")[1]
    if not BigFigure or not BigFigure:FindFirstChild("Body") then return end

    BigFigure.Parent = rig

    Rainbowify(BigFigure)

    task.spawn(function()
        while rig and rig.Parent and BigFigure and BigFigure.Parent do
            if rig:FindFirstChild("Torso") then
                BigFigure.Body.CFrame =
                    rig.Torso.CFrame *
                    CFrame.Angles(0, math.rad(180), 0)
            end
            task.wait()
        end
    end)
end

-- existing rooms (run once)
task.spawn(function()
    for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
        task.wait(0.1)
        Setup(room)
    end
end)

-- future rooms (run once ONLY)
workspace.CurrentRooms.ChildAdded:Connect(function(room)
    task.wait(3)
    Setup(room)
end)

-------------------------------------------------
-- CARPET / EYES / SCREECH COLORS
-------------------------------------------------

local RunService = game:GetService("RunService")

local PINK = Color3.fromRGB(255, 80, 180)
local RED = Color3.fromRGB(180, 0, 0)
local SEEK_RED = Color3.fromRGB(150, 20, 20)

local CarpetColors = {
    Color3.fromRGB(95, 55, 20),   -- Brown
    Color3.fromRGB(120, 80, 25),  -- Dark Gold
    Color3.fromRGB(110, 25, 25),  -- Dark Red
    Color3.fromRGB(90, 40, 10),   -- Dark Brown
    Color3.fromRGB(140, 90, 20),  -- Yellow-Brown
}

local function recolorCarpet(room)
    local color = CarpetColors[math.random(#CarpetColors)]

    for _, v in ipairs(room:GetDescendants()) do
        local name = string.lower(v.Name)

        if string.find(name, "rug") or string.find(name, "carpet") then

            if v:IsA("BasePart") then
                v.Color = color
            end

            for _, obj in ipairs(v:GetDescendants()) do
                if obj:IsA("BasePart") then
                    obj.Color = color
                end
            end
        end
    end
end

local function applyColor(model, color)
    for _, v in ipairs(model:GetDescendants()) do

        if v:IsA("BasePart") then
            v.Color = color

        elseif v:IsA("Decal") then
            v.Color3 = color

        elseif v:IsA("Texture") then
            v.Color = color

        elseif v:IsA("ParticleEmitter") then
            v.Color = ColorSequence.new(color)

        elseif v:IsA("Beam") or v:IsA("Trail") then
            v.Color = ColorSequence.new(color)

        elseif v:IsA("Highlight") then
            v.FillColor = color
            v.OutlineColor = color

        elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
            v.ImageColor3 = color
        end
    end
end

local AnimatedEyes = {}

local function AnimateEyes(model)
    if AnimatedEyes[model] then
        return
    end

    AnimatedEyes[model] = true

    task.spawn(function()

        local t = 0

        while model and model.Parent do

            t += RunService.Heartbeat:Wait()

            local alpha = (math.sin(t * 2) + 1) / 2
            local color = PINK:Lerp(RED, alpha)

            applyColor(model, color)

        end

        AnimatedEyes[model] = nil

    end)
end

local function hookEntity(model)

    if not model:IsA("Model") then
        return
    end

    -- Screech = Pink
    if model.Name == "Screech" or model.Name == "_Screech" then

        applyColor(model, PINK)

        model.DescendantAdded:Connect(function()
            task.wait()
            applyColor(model, PINK)
        end)

    end

    -- Seek = Red
    if model.Name == "SeekMoving"
    or model.Name == "SeekMovingNewClone" then

        applyColor(model, SEEK_RED)

        model.DescendantAdded:Connect(function()
            task.wait()
            applyColor(model, SEEK_RED)
        end)

    end

    -- Eyes = Pink <-> Red
    if model.Name == "Eye"
    or model.Name == "Eyes" then

        AnimateEyes(model)

        model.DescendantAdded:Connect(function()
            task.wait()
            AnimateEyes(model)
        end)

    end

end

-- Existing rooms
for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
    recolorCarpet(room)
end

-- Future rooms
workspace.CurrentRooms.ChildAdded:Connect(function(room)
    task.wait(0.1)
    recolorCarpet(room)
end)

-- Existing entities
for _, obj in ipairs(workspace:GetDescendants()) do
    hookEntity(obj)
end

-- Future entities
workspace.DescendantAdded:Connect(function(obj)
    hookEntity(obj)
end)

-------------------------------------------------
-- Kardin Hong ATMOSPHERE req 
-------------------------------------------------

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- 🌫️ PERMANENT ATMOSPHERE
local Atmosphere = Instance.new("Atmosphere")
Atmosphere.Density = 0.75
Atmosphere.Parent = Lighting

-- 🔵 NEON COLOR OVERRIDE
local NEON_COLOR = Color3.new(0.333333, 0.666667, 1)

local function applyNeon(obj)
    if obj:IsA("BasePart") and obj.Name == "Neon" then
        obj.Color = NEON_COLOR
    end
end

-- apply existing rooms
task.spawn(function()
    local rooms = Workspace:WaitForChild("CurrentRooms")
    for _, obj in ipairs(rooms:GetDescendants()) do
        applyNeon(obj)
    end
end)

-- apply future rooms
Workspace:WaitForChild("CurrentRooms").DescendantAdded:Connect(function(obj)
    applyNeon(obj)
end)

-------------------------------------------------
-- Kardin Hongs white window remix les goooo ez skid
-------------------------------------------------

-------------------------------------------------
-- CHAIRS / WINDOWS SYSTEM
-------------------------------------------------

local WINDOW_NAMES = {"Window", "Windows"}
local CHAIR_NAME = "regal_chair"

local DARK_RED = Color3.fromRGB(80, 0, 0)
local WHITE = Color3.fromRGB(255, 255, 255)

local function lerpColor(part, t)
	part.Color = DARK_RED:Lerp(WHITE, t)
end

local function updateWindows()
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") then
			for _, name in ipairs(WINDOW_NAMES) do
				if obj.Name == name then
					obj.Color = WHITE
					obj.Material = Enum.Material.SmoothPlastic
				end
			end
		end
	end
end

local function updateChairs()
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name == CHAIR_NAME then
			for i = 0, 1, 0.05 do
				lerpColor(obj, i)
				task.wait(0.05)
			end
			obj.Material = Enum.Material.SmoothPlastic
		end
	end
end

task.spawn(function()
	while true do
		updateWindows()
		updateChairs()
		task.wait(2)
	end
end)

--spawn looper
task.spawn(function()
    while true do
        task.wait(102)
        pcall(Spawn)
    end
end)

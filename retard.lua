-- Create the ScreenGUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ExploitGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

-- Create the Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 510, 0, 300)
mainFrame.Position = UDim2.new(0.5, -255, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Create the Top Bar Frame
local topBarFrame = Instance.new("Frame")
topBarFrame.Name = "TopBarFrame"
topBarFrame.Size = UDim2.new(1, 0, 0, 50)
topBarFrame.Position = UDim2.new(0, 0, 0, 0)
topBarFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
topBarFrame.Parent = mainFrame

-- Add the Title Label to Top Bar
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0, 150, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "NoorHub"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBarFrame

-- Create the Tab Buttons for Sections
local sections = {"Weapon", "Gunmods", "Fun", "Player", "Farming"}
local buttons = {}
local pages = {}  -- Store the pages here

local remainingWidth = 510 - 160
local buttonWidth = math.floor(remainingWidth / #sections)
local usedWidth = buttonWidth * #sections
local extraSpace = remainingWidth - usedWidth

for i, section in ipairs(sections) do
    local button = Instance.new("TextButton")
    button.Name = section .. "Button"
    if i == #sections then
        buttonWidth = buttonWidth + extraSpace
    end
    button.Size = UDim2.new(0, buttonWidth, 1, 0)
    button.Position = UDim2.new(0, 160 + (i - 1) * buttonWidth, 0, 0)
    button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    button.Text = section
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Parent = topBarFrame
    buttons[section] = button

    -- Create a page for each section
    local page = Instance.new("Frame")
    page.Name = section .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false  -- All pages are hidden by default
    page.Parent = mainFrame
    pages[section] = page

    -- Functionality to switch pages
    button.MouseButton1Click:Connect(function()
        -- Hide all pages
        for _, p in pairs(pages) do
            p.Visible = false
        end
        -- Show the selected page
        pages[section].Visible = true
    end)
end

-- Farming Page Content
local farmingPage = pages["Farming"]

-- Global variable for ClickTP toggle
local clickTPEnabled = false

-- Follow Enemy Toggle Button
local followToggleButton = Instance.new("TextButton")
followToggleButton.Name = "FollowToggle"
followToggleButton.Size = UDim2.new(0, 200, 0, 40)
followToggleButton.Position = UDim2.new(0, 10, 0, 20)
followToggleButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
followToggleButton.Text = "Follow Enemy: OFF"
followToggleButton.Font = Enum.Font.Gotham
followToggleButton.TextSize = 14
followToggleButton.TextColor3 = Color3.new(1, 1, 1)
followToggleButton.Parent = farmingPage

followToggleButton.MouseButton1Click:Connect(function()
    followEnemy = not followEnemy
    followToggleButton.Text = "Follow Enemy: " .. (followEnemy and "ON" or "OFF")
    if followEnemy then
        maintainPositionBehindHead()
    else
        if followConnection then followConnection:Disconnect() end
    end
end)

-- Autofarm Toggle Button
local autofarmToggleButton = Instance.new("TextButton")
autofarmToggleButton.Name = "AutofarmToggle"
autofarmToggleButton.Size = UDim2.new(0, 200, 0, 40)
autofarmToggleButton.Position = UDim2.new(0, 10, 0, 80)
autofarmToggleButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
autofarmToggleButton.Text = "Autofarm: OFF"
autofarmToggleButton.Font = Enum.Font.Gotham
autofarmToggleButton.TextSize = 14
autofarmToggleButton.TextColor3 = Color3.new(1, 1, 1)
autofarmToggleButton.Parent = farmingPage

autofarmToggleButton.MouseButton1Click:Connect(function()
    autofarmEnabled = not autofarmEnabled
    autofarmToggleButton.Text = "Autofarm: " .. (autofarmEnabled and "ON" or "OFF")
    if autofarmEnabled then
        startAutofarm()
    else
        if autofarmConnection then autofarmConnection:Disconnect() end
    end
end)

-- Click Teleport Functionality with Toggle
local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")

-- Function to handle teleportation
local function teleportToPosition(targetPosition)
    local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(targetPosition)
    end
end

-- Toggle ClickTP
local clickTPToggleButton = Instance.new("TextButton")
clickTPToggleButton.Name = "ClickTPToggle"
clickTPToggleButton.Size = UDim2.new(0, 200, 0, 40)
clickTPToggleButton.Position = UDim2.new(0, 10, 0, 140)
clickTPToggleButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
clickTPToggleButton.Text = "ClickTP: OFF"
clickTPToggleButton.Font = Enum.Font.Gotham
clickTPToggleButton.TextSize = 14
clickTPToggleButton.TextColor3 = Color3.new(1, 1, 1)
clickTPToggleButton.Parent = farmingPage

clickTPToggleButton.MouseButton1Click:Connect(function()
    clickTPEnabled = not clickTPEnabled
    clickTPToggleButton.Text = "ClickTP: " .. (clickTPEnabled and "ON" or "OFF")
end)

-- Listen for left mouse button click for teleportation
mouse.Button1Down:Connect(function()
    if clickTPEnabled and mouse.Target then
        local targetPosition = mouse.Hit.p
        teleportToPosition(targetPosition)
    end
end)

-- Maintain Position Behind Enemy's Head
local function maintainPositionBehindHead()
    followConnection = runService.RenderStepped:Connect(function()
        if followEnemy then
            local closestPlayer = v32() -- Replace with your method to find the closest player
            if closestPlayer and closestPlayer.Character then
                local head = closestPlayer.Character:FindFirstChild("Head")
                if head then
                    local positionBehindHead = head.Position - (head.CFrame.lookVector * 2) -- Adjust distance as needed
                    teleportToPosition(positionBehindHead)
                end
            end
        end
    end)
end

-- Autofarm Script: Teleport and Aimbot the Enemy
local function startAutofarm()
    autofarmConnection = runService.RenderStepped:Connect(function()
        if autofarmEnabled then
            local closestPlayer = v32() -- Replace with your method to find the closest player
            if closestPlayer and closestPlayer.Character then
                local head = closestPlayer.Character:FindFirstChild("Head")
                if head then
                    local positionBehindHead = head.Position - (head.CFrame.lookVector * 2) -- Adjust distance as needed
                    teleportToPosition(positionBehindHead)
                    -- Ensure Aimbot is working here
                    v36() -- Replace with your method to aim at the enemy's head
                end
            end
        end
    end)
end

-- Weapon Page Content
local weaponPage = pages["Weapon"]

-- Aimbot Toggle
local aimbotToggle = Instance.new("TextButton")
aimbotToggle.Name = "AimbotToggle"
aimbotToggle.Size = UDim2.new(0, 200, 0, 40)
aimbotToggle.Position = UDim2.new(0, 10, 0, 80)  -- Lowered position
aimbotToggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
aimbotToggle.Text = "Aimbot: OFF"
aimbotToggle.Font = Enum.Font.Gotham
aimbotToggle.TextSize = 14
aimbotToggle.TextColor3 = Color3.new(1, 1, 1)
aimbotToggle.Parent = weaponPage

-- ESP Toggle
local espToggle = Instance.new("TextButton")
espToggle.Name = "ESPToggle"
espToggle.Size = UDim2.new(0, 200, 0, 40)
espToggle.Position = UDim2.new(0, 10, 0, 140)  -- Lowered position
espToggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
espToggle.Text = "ESP: OFF"
espToggle.Font = Enum.Font.Gotham
espToggle.TextSize = 14
espToggle.TextColor3 = Color3.new(1, 1, 1)
espToggle.Parent = weaponPage

-- Toggle GUI visibility with Right Shift
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- Global variables for cheats
local aimbotEnabled = false
local espEnabled = false

-- Refined Aimbot Functionality
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local aimbotEnabled = false
local isHolding = false

-- Raycasting parameters setup
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
raycastParams.IgnoreWater = true

-- Function to check if the target is visible using raycasting
local function isTargetVisible(target)
    raycastParams.FilterDescendantsInstances = {localPlayer.Character, target.Parent}
    local origin = camera.CFrame.Position
    local direction = (target.Position - origin).Unit * (target.Position - origin).Magnitude
    local rayResult = workspace:Raycast(origin, direction, raycastParams)

    return rayResult == nil or rayResult.Instance:IsDescendantOf(target.Parent)
end

-- Function to find the closest visible target's head
local function findClosestVisibleTarget()
    local closestTarget = nil
    local shortestDistance = math.huge

    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local screenPosition, onScreen = camera:WorldToViewportPoint(head.Position)

            if onScreen and isTargetVisible(head) then
                local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)).Magnitude

                if distance < shortestDistance then
                    shortestDistance = distance
                    closestTarget = head
                end
            end
        end
    end

    return closestTarget
end

-- Aimbot logic to instantly snap to the target's head
local function aimAt(target)
    if target then
        camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
    end
end

-- Function to update Aimbot when holding left click
local function updateAimbot()
    if isHolding and aimbotEnabled then
        local target = findClosestVisibleTarget()
        aimAt(target)
    end
end

-- Detect when the left mouse button is pressed and released
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and aimbotEnabled then
        isHolding = true
        updateAimbot()  -- Perform an initial aim as soon as the button is pressed
        runService:BindToRenderStep("Aimbot", Enum.RenderPriority.Camera.Value, updateAimbot)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isHolding = false
        runService:UnbindFromRenderStep("Aimbot")
    end
end)

-- Aimbot Toggle Button Functionality
aimbotToggle.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimbotToggle.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
end)

-- Refined ESP Functionality
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local runService = game:GetService("RunService")
local espEnabled = false

-- Store Highlight objects and nametags
local chams = {}
local nametags = {}

-- Function to create or get a Highlight instance
local function createHighlight(player)
    if not player.Character then return end
    
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = player.Character
    chams[player] = highlight

    -- Create a nametag
    local head = player.Character:FindFirstChild("Head")
    if head then
        local nameTag = Instance.new("BillboardGui")
        nameTag.Adornee = head
        nameTag.Size = UDim2.new(0, 80, 0, 30) -- Smaller size
        nameTag.StudsOffset = Vector3.new(0, 2.5, 0) -- Closer to the head
        nameTag.AlwaysOnTop = true
        nameTag.Parent = head

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextScaled = true
        nameLabel.TextStrokeTransparency = 0  -- Black outline
        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        nameLabel.Parent = nameTag

        nametags[player] = nameTag
    end
end

-- Function to clear all ESP highlights and nametags
local function clearESP()
    for _, highlight in pairs(chams) do
        if highlight.Parent then
            highlight:Destroy()
        end
    end
    chams = {}

    for _, nametag in pairs(nametags) do
        if nametag.Parent then
            nametag:Destroy()
        end
    end
    nametags = {}
end

-- Function to update ESP
local function updateESP()
    clearESP()
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            createHighlight(player)
        end
    end
end

-- Ensure ESP stays active even after respawn
local function onCharacterAdded(character)
    if espEnabled then
        updateESP()
    end
end

-- Toggle ESP function
local function toggleESP()
    if espEnabled then
        runService:BindToRenderStep("ESPUpdate", Enum.RenderPriority.Camera.Value + 1, updateESP)
    else
        runService:UnbindFromRenderStep("ESPUpdate")
        clearESP()
    end
end

-- ESP Toggle Button Functionality
espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espToggle.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    toggleESP()
end)

-- Listen for respawns to reapply ESP
localPlayer.CharacterAdded:Connect(onCharacterAdded)

-- Gunmods Page Content
local gunmodsPage = pages["Gunmods"]

-- Triggerbot Toggle Button
local triggerbotToggle = Instance.new("TextButton")
triggerbotToggle.Name = "TriggerbotToggle"
triggerbotToggle.Size = UDim2.new(0, 200, 0, 40)
triggerbotToggle.Position = UDim2.new(0, 10, 0, 80)  -- Adjust position as needed
triggerbotToggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
triggerbotToggle.Text = "Triggerbot: OFF"
triggerbotToggle.Font = Enum.Font.Gotham
triggerbotToggle.TextSize = 14
triggerbotToggle.TextColor3 = Color3.new(1, 1, 1)
triggerbotToggle.Parent = gunmodsPage

-- Variables for Triggerbot
local triggerbotEnabled = false

-- Triggerbot Logic
local function triggerbot()
    local mouse = localPlayer:GetMouse()
    if triggerbotEnabled and mouse.Target then
        if mouse.Target.Parent:FindFirstChild("Humanoid") then
            mouse1click()  -- Simulates a left mouse click
        end
    end
end

-- Toggle Triggerbot functionality
triggerbotToggle.MouseButton1Click:Connect(function()
    triggerbotEnabled = not triggerbotEnabled
    triggerbotToggle.Text = "Triggerbot: " .. (triggerbotEnabled and "ON" or "OFF")
    if triggerbotEnabled then
        runService:BindToRenderStep("Triggerbot", Enum.RenderPriority.Camera.Value, triggerbot)
    else
        runService:UnbindFromRenderStep("Triggerbot")
    end
end)

-- Rapid Fire Toggle Button
local rapidFireToggle = Instance.new("TextButton")
rapidFireToggle.Name = "RapidFireToggle"
rapidFireToggle.Size = UDim2.new(0, 200, 0, 40)
rapidFireToggle.Position = UDim2.new(0, 10, 0, 140)  -- Adjust position as needed
rapidFireToggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
rapidFireToggle.Text = "Rapid Fire: OFF"
rapidFireToggle.Font = Enum.Font.Gotham
rapidFireToggle.TextSize = 14
rapidFireToggle.TextColor3 = Color3.new(1, 1, 1)
rapidFireToggle.Parent = gunmodsPage

-- Variables for Rapid Fire
local rapidFireEnabled = false

-- Rapid Fire Logic
local function enableRapidFire()
    for _, tool in pairs(localPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("GunScript") then
            local gunScript = require(tool.GunScript)
            gunScript.FireRate = 0.1  -- Set an extremely high fire rate
        end
    end
end

-- Toggle Rapid Fire functionality
rapidFireToggle.MouseButton1Click:Connect(function()
    rapidFireEnabled = not rapidFireEnabled
    rapidFireToggle.Text = "Rapid Fire: " .. (rapidFireEnabled and "ON" or "OFF")
    if rapidFireEnabled then
        enableRapidFire()
    end
end)

-- Fun Page Content
local funPage = pages["Fun"]

-- 3rd Person Mode Toggle Button
local thirdPersonToggle = Instance.new("TextButton")
thirdPersonToggle.Name = "ThirdPersonToggle"
thirdPersonToggle.Size = UDim2.new(0, 200, 0, 40)
thirdPersonToggle.Position = UDim2.new(0, 10, 0, 80)
thirdPersonToggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
thirdPersonToggle.Text = "3rd Person: OFF"
thirdPersonToggle.Font = Enum.Font.Gotham
thirdPersonToggle.TextSize = 14
thirdPersonToggle.TextColor3 = Color3.new(1, 1, 1)
thirdPersonToggle.Parent = funPage

-- Variables for 3rd Person Mode
local thirdPersonEnabled = false

-- Toggle 3rd Person Mode functionality
thirdPersonToggle.MouseButton1Click:Connect(function()
    thirdPersonEnabled = not thirdPersonEnabled
    thirdPersonToggle.Text = "3rd Person: " .. (thirdPersonEnabled and "ON" or "OFF")

    if thirdPersonEnabled then
        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = CFrame.new(camera.CFrame.Position, localPlayer.Character.Head.Position + Vector3.new(0, 1, 0))
        UIS.MouseBehavior = Enum.MouseBehavior.Default
        
        runService.RenderStepped:Connect(function()
            if thirdPersonEnabled then
                camera.CFrame = CFrame.new(localPlayer.Character.Head.Position - (camera.CFrame.LookVector * 10), localPlayer.Character.Head.Position)
            end
        end)
    else
        camera.CameraType = Enum.CameraType.Custom
        localPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
        UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
    end
end)

-- Spinbot Toggle Button
local spinbotToggle = Instance.new("TextButton")
spinbotToggle.Name = "SpinbotToggle"
spinbotToggle.Size = UDim2.new(0, 200, 0, 40)
spinbotToggle.Position = UDim2.new(0, 10, 0, 140)
spinbotToggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
spinbotToggle.Text = "Spinbot: OFF"
spinbotToggle.Font = Enum.Font.Gotham
spinbotToggle.TextSize = 14
spinbotToggle.TextColor3 = Color3.new(1, 1, 1)
spinbotToggle.Parent = funPage

-- Variables for Spinbot
local spinbotEnabled = false

-- Toggle Spinbot functionality
spinbotToggle.MouseButton1Click:Connect(function()
    spinbotEnabled = not spinbotEnabled
    spinbotToggle.Text = "Spinbot: " .. (spinbotEnabled and "ON" or "OFF")

    if spinbotEnabled then
        runService:BindToRenderStep("Spinbot", Enum.RenderPriority.Camera.Value, function()
            localPlayer.Character.HumanoidRootPart.CFrame = localPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(100), 0)
            camera.CameraType = Enum.CameraType.Custom  -- Ensure camera remains free
        end)
    else
        runService:UnbindFromRenderStep("Spinbot")
    end
end)

-- Player Page Content
local playerPage = pages["Player"]

local function createSlider(labelText, min, max, default, position, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0, 150, 0, 50)
    sliderFrame.Position = position
    sliderFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    sliderFrame.Parent = playerPage

    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(1, 0, 0, 20)
    sliderLabel.Position = UDim2.new(0, 0, 0, 0)
    sliderLabel.Text = labelText .. ": " .. default
    sliderLabel.TextColor3 = Color3.new(1, 1, 1)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.TextSize = 14
    sliderLabel.Parent = sliderFrame

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -20, 0, 10)
    sliderBar.Position = UDim2.new(0, 10, 0, 30)
    sliderBar.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    sliderBar.Parent = sliderFrame

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.new(0.6, 0.6, 0.6)
    sliderFill.Parent = sliderBar

    local UIS = game:GetService("UserInputService")

    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local dragging = true
            local conn1, conn2

            conn1 = UIS.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local relativeX = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
                    local newValue = min + (relativeX / sliderBar.AbsoluteSize.X) * (max - min)
                    sliderFill.Size = UDim2.new((newValue - min) / (max - min), 0, 1, 0)
                    sliderLabel.Text = labelText .. ": " .. math.floor(newValue)
                    callback(newValue)
                end
            end)

            conn2 = UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    conn1:Disconnect()
                    conn2:Disconnect()
                end
            end)
        end
    end)
end

-- WalkSpeed Toggle and Slider (No changes needed)
local walkSpeedEnabled = false
local walkSpeed = 100

local walkSpeedToggle = Instance.new("TextButton")
walkSpeedToggle.Name = "WalkSpeedToggle"
walkSpeedToggle.Size = UDim2.new(0, 150, 0, 30)
walkSpeedToggle.Position = UDim2.new(0, 10, 0, 80)
walkSpeedToggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
walkSpeedToggle.Text = "WalkSpeed: OFF"
walkSpeedToggle.Font = Enum.Font.Gotham
walkSpeedToggle.TextSize = 14
walkSpeedToggle.TextColor3 = Color3.new(1, 1, 1)
walkSpeedToggle.Parent = playerPage

walkSpeedToggle.MouseButton1Click:Connect(function()
    walkSpeedEnabled = not walkSpeedEnabled
    walkSpeedToggle.Text = "WalkSpeed: " .. (walkSpeedEnabled and "ON" or "OFF")
    if walkSpeedEnabled then
        local character = localPlayer.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character.Humanoid.WalkSpeed = walkSpeed
        end
    else
        local character = localPlayer.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character.Humanoid.WalkSpeed = 16 -- Reset to default
        end
    end
end)

createSlider("Walk Speed", 100, 4000, walkSpeed, UDim2.new(0, 10, 0, 120), function(value)
    walkSpeed = value
    if walkSpeedEnabled then
        local character = localPlayer.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character.Humanoid.WalkSpeed = walkSpeed
        end
    end
end)

-- JumpPower Toggle and Slider (No changes needed)
local jumpPowerEnabled = false
local jumpPower = 150

local jumpPowerToggle = Instance.new("TextButton")
jumpPowerToggle.Name = "JumpPowerToggle"
jumpPowerToggle.Size = UDim2.new(0, 150, 0, 30)
jumpPowerToggle.Position = UDim2.new(0, 10, 0, 180)
jumpPowerToggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
jumpPowerToggle.Text = "JumpPower: OFF"
jumpPowerToggle.Font = Enum.Font.Gotham
jumpPowerToggle.TextSize = 14
jumpPowerToggle.TextColor3 = Color3.new(1, 1, 1)
jumpPowerToggle.Parent = playerPage

jumpPowerToggle.MouseButton1Click:Connect(function()
    jumpPowerEnabled = not jumpPowerEnabled
    jumpPowerToggle.Text = "JumpPower: " .. (jumpPowerEnabled and "ON" or "OFF")
    if jumpPowerEnabled then
        local character = localPlayer.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character.Humanoid.JumpPower = jumpPower
        end
    else
        local character = localPlayer.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character.Humanoid.JumpPower = 50 -- Reset to default
        end
    end
end)

createSlider("Jump Power", 100, 4000, jumpPower, UDim2.new(0, 10, 0, 220), function(value)
    jumpPower = value
    if jumpPowerEnabled then
        local character = localPlayer.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character.Humanoid.JumpPower = jumpPower
        end
    end
end)

-- Infinite Jump Toggle (Moved back to previous X-level)
local infiniteJumpEnabled = false

UIS.JumpRequest:Connect(function()
    if infiniteJumpEnabled and localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
        localPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local infiniteJumpToggle = Instance.new("TextButton")
infiniteJumpToggle.Name = "InfiniteJumpToggle"
infiniteJumpToggle.Size = UDim2.new(0, 150, 0, 30)
infiniteJumpToggle.Position = UDim2.new(0.5, -75, 0, 80)  -- Moved back to previous X-level
infiniteJumpToggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
infiniteJumpToggle.Text = "Infinite Jump: OFF"
infiniteJumpToggle.Font = Enum.Font.Gotham
infiniteJumpToggle.TextSize = 14
infiniteJumpToggle.TextColor3 = Color3.new(1, 1, 1)
infiniteJumpToggle.Parent = playerPage

infiniteJumpToggle.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    infiniteJumpToggle.Text = "Infinite Jump: " .. (infiniteJumpEnabled and "ON" or "OFF")
end)

-- Noclip Toggle (Moved back to previous X-level)
local noclipEnabled = false

local function noclip()
    if localPlayer.Character then
        for _, part in pairs(localPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end

runService.Stepped:Connect(function()
    if noclipEnabled then
        noclip()
    end
end)

local noclipToggle = Instance.new("TextButton")
noclipToggle.Name = "NoclipToggle"
noclipToggle.Size = UDim2.new(0, 150, 0, 30)
noclipToggle.Position = UDim2.new(0.5, -75, 0, 120)  -- Moved back to previous X-level
noclipToggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
noclipToggle.Text = "Noclip: OFF"
noclipToggle.Font = Enum.Font.Gotham
noclipToggle.TextSize = 14
noclipToggle.TextColor3 = Color3.new(1, 1, 1)
noclipToggle.Parent = playerPage

noclipToggle.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipToggle.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")
end)

-- Fly Toggle with Adjustable Speed (Moved back to previous X-level)
local flyEnabled = false
local flySpeed = 50
local flyKey = Enum.KeyCode.F

local function fly()
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    bodyVelocity.P = 10000
    bodyVelocity.Parent = localPlayer.Character.HumanoidRootPart

    runService.RenderStepped:Connect(function()
        if flyEnabled then
            local direction = Vector3.new(0, 0, 0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then direction = direction + camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then direction = direction - camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then direction = direction - camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then direction = direction + camera.CFrame.RightVector end
            bodyVelocity.Velocity = direction * flySpeed
        else
            bodyVelocity:Destroy()
        end
    end)
end

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == flyKey then
        flyEnabled = not flyEnabled
        if flyEnabled then
            fly()
        end
    end
end)

local flySpeedSlider = Instance.new("Frame")
flySpeedSlider.Name = "FlySpeedSlider"
flySpeedSlider.Size = UDim2.new(0, 150, 0, 50)
flySpeedSlider.Position = UDim2.new(.98, -150, 0, 80)  -- Moved back to previous X-level
flySpeedSlider.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
flySpeedSlider.Parent = playerPage

local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Name = "FlySpeedLabel"
flySpeedLabel.Size = UDim2.new(1, 0, 0, 20)
flySpeedLabel.Position = UDim2.new(0, 0, 0, 0)
flySpeedLabel.Text = "Fly Speed: " .. flySpeed
flySpeedLabel.TextColor3 = Color3.new(1, 1, 1)
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.Font = Enum.Font.Gotham
flySpeedLabel.TextSize = 14
flySpeedLabel.Parent = flySpeedSlider

local flySpeedBar = Instance.new("Frame")
flySpeedBar.Name = "FlySpeedBar"
flySpeedBar.Size = UDim2.new(1, -20, 0, 10)
flySpeedBar.Position = UDim2.new(0, 10, 0, 30)
flySpeedBar.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
flySpeedBar.Parent = flySpeedSlider

local flySpeedFill = Instance.new("Frame")
flySpeedFill.Name = "FlySpeedFill"
flySpeedFill.Size = UDim2.new((flySpeed - 10) / 90, 0, 1, 0)
flySpeedFill.BackgroundColor3 = Color3.new(0.6, 0.6, 0.6)
flySpeedFill.Parent = flySpeedBar

flySpeedBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local dragging = true
        local conn1, conn2

        conn1 = UIS.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relativeX = math.clamp(input.Position.X - flySpeedBar.AbsolutePosition.X, 0, flySpeedBar.AbsoluteSize.X)
                local newSpeed = 10 + (relativeX / flySpeedBar.AbsoluteSize.X) * 90
                flySpeedFill.Size = UDim2.new((newSpeed - 10) / 90, 0, 1, 0)
                flySpeedLabel.Text = "Fly Speed: " .. math.floor(newSpeed)
                flySpeed = newSpeed
            end
        end)

        conn2 = UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
                conn1:Disconnect()
                conn2:Disconnect()
            end
        end)
    end
end)

-- Low Gravity Toggle (Moved back to previous X-level)
local lowGravityEnabled = false
local originalGravity = workspace.Gravity

local lowGravityToggle = Instance.new("TextButton")
lowGravityToggle.Name = "LowGravityToggle"
lowGravityToggle.Size = UDim2.new(0, 150, 0, 30)
lowGravityToggle.Position = UDim2.new(.98, -150, 0, 140)  -- Moved back to previous X-level
lowGravityToggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
lowGravityToggle.Text = "Low Gravity: OFF"
lowGravityToggle.Font = Enum.Font.Gotham
lowGravityToggle.TextSize = 14
lowGravityToggle.TextColor3 = Color3.new(1, 1, 1)
lowGravityToggle.Parent = playerPage

lowGravityToggle.MouseButton1Click:Connect(function()
    lowGravityEnabled = not lowGravityEnabled
    lowGravityToggle.Text = "Low Gravity: " .. (lowGravityEnabled and "ON" or "OFF")
    if lowGravityEnabled then
        workspace.Gravity = 50
    else
        workspace.Gravity = originalGravity
    end
end)

-- Restore metatable
setreadonly(mt, true)

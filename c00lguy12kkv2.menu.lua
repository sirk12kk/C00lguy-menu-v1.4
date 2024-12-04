-- Ban list (local, for demonstration purposes; replace with a datastore for persistence)
local bannedPlayers = {}

-- Ban a player by UserId
local function banPlayer(player, reason)
    if player and player:IsA("Player") then
        bannedPlayers[player.UserId] = reason or "No reason provided"
        player:Kick("You have been banned: " .. (reason or "No reason provided"))
        print("[Moderation] Player " .. player.Name .. " has been banned.")
    else
        warn("[Moderation] Invalid player to ban.")
    end
end

-- Check if a player is banned
local function isPlayerBanned(userId)
    return bannedPlayers[userId] ~= nil
end

-- Kick a player from the game
local function kickPlayer(player, reason)
    if player and player:IsA("Player") then
        player:Kick("You have been kicked: " .. (reason or "No reason provided"))
        print("[Moderation] Player " .. player.Name .. " has been kicked.")
    else
        warn("[Moderation] Invalid player to kick.")
    end
end

-- Automatically handle banned players on join
game.Players.PlayerAdded:Connect(function(player)
    if isPlayerBanned(player.UserId) then
        player:Kick("You are banned: " .. bannedPlayers[player.UserId])
    end
end)

-- Moderation Menu
local function createModerationMenu()
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local KickButton = Instance.new("TextButton")
    local BanButton = Instance.new("TextButton")
    local PlayerTextBox = Instance.new("TextBox")
    local ReasonTextBox = Instance.new("TextBox")

    ScreenGui.Name = "ModerationMenu"
    ScreenGui.Parent = game.CoreGui

    Frame.Parent = ScreenGui
    Frame.Size = UDim2.new(0, 300, 0, 250)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -125)
    Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

    -- Player Name Input
    PlayerTextBox.Parent = Frame
    PlayerTextBox.PlaceholderText = "Player Name"
    PlayerTextBox.Size = UDim2.new(1, -20, 0, 40)
    PlayerTextBox.Position = UDim2.new(0, 10, 0, 10)
    PlayerTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    -- Reason Input
    ReasonTextBox.Parent = Frame
    ReasonTextBox.PlaceholderText = "Reason (optional)"
    ReasonTextBox.Size = UDim2.new(1, -20, 0, 40)
    ReasonTextBox.Position = UDim2.new(0, 10, 0, 60)
    ReasonTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    -- Kick Button
    KickButton.Parent = Frame
    KickButton.Text = "Kick Player"
    KickButton.Size = UDim2.new(1, -20, 0, 40)
    KickButton.Position = UDim2.new(0, 10, 0, 110)
    KickButton.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
    KickButton.TextColor3 = Color3.new(1, 1, 1)
    KickButton.Font = Enum.Font.SourceSansBold
    KickButton.TextScaled = true
    KickButton.MouseButton1Click:Connect(function()
        local playerName = PlayerTextBox.Text
        local reason = ReasonTextBox.Text
        local player = game.Players:FindFirstChild(playerName)
        if player then
            kickPlayer(player, reason)
        else
            warn("[Moderation] Player not found.")
        end
    end)

    -- Ban Button
    BanButton.Parent = Frame
    BanButton.Text = "Ban Player"
    BanButton.Size = UDim2.new(1, -20, 0, 40)
    BanButton.Position = UDim2.new(0, 10, 0, 160)
    BanButton.BackgroundColor3 = Color3.fromRGB(255, 69, 69)
    BanButton.TextColor3 = Color3.new(1, 1, 1)
    BanButton.Font = Enum.Font.SourceSansBold
    BanButton.TextScaled = true
    BanButton.MouseButton1Click:Connect(function()
        local playerName = PlayerTextBox.Text
        local reason = ReasonTextBox.Text
        local player = game.Players:FindFirstChild(playerName)
        if player then
            banPlayer(player, reason)
        else
            warn("[Moderation] Player not found.")
        end
    end)
end

-- Initialize the Moderation Menu
createModerationMenu()

local Arena = script.Parent -- O script está dentro do Model
local debounce = {}

local function criarBillboard(player, character)
    local head = character:WaitForChild("Head")
    
    -- Remove billboard antigo se existir
    if head:FindFirstChild("BillboardArena") then
        head:FindFirstChild("BillboardArena"):Destroy()
    end
    
    -- Cria o BillboardGui
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "BillboardArena"
    billboard.Parent = head
    billboard.Size = UDim2.new(6, 0, 2, 0)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.MaxDistance = 100
    
    -- TextLabel com estilo neon
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.BackgroundTransparency = 0.3
    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Vermelho neon
    textLabel.Text = "DEM TORNEIO"
    textLabel.TextSize = 20
    textLabel.Font = Enum.Font.GothamBold
    textLabel.BorderSizePixel = 2
    textLabel.BorderColor3 = Color3.fromRGB(255, 0, 0)
    
    -- UICorner para bordas arredondadas
    local corner = Instance.new("UICorner")
    corner.Parent = textLabel
    corner.CornerRadius = UDim.new(0, 8)
end

local function removerBillboard(character)
    local head = character:FindFirstChild("Head")
    if head then
        local billboard = head:FindFirstChild("BillboardArena")
        if billboard then
            billboard:Destroy()
        end
    end
end

-- Detecta quando alguém toca na Arena
local function onTouched(hit)
    local humanoid = hit.Parent:FindFirstChild("Humanoid")
    if humanoid then
        local player = game.Players:FindFirstChild(hit.Parent.Name)
        if player and not debounce[player.UserId] then
            debounce[player.UserId] = true
            criarBillboard(player, hit.Parent)
            print(player.Name .. " entrou na Arena!")
            task.wait(0.5)
            debounce[player.UserId] = false
        end
    end
end

-- Detecta quando alguém sai da Arena
local function onTouchEnded(hit)
    local humanoid = hit.Parent:FindFirstChild("Humanoid")
    if humanoid then
        local player = game.Players:FindFirstChild(hit.Parent.Name)
        if player then
            removerBillboard(hit.Parent)
            print(player.Name .. " saiu da Arena!")
        end
    end
end

-- Conecta os eventos
Arena.Touched:Connect(onTouched)
Arena.TouchEnded:Connect(onTouchEnded)

local plyrs = game:GetService"Players"
local tag = game:GetService"CollectionService"

-- ============================================
-- GANGS — Para adicionar, copie um bloco e cole
-- ============================================
local Gangs = {
	{
		Grupo = 34782392,
		MinRank = 15,
		GangNome = "Os Hashiras",
		MaxHealth = 1000,
		Nome = { Letraakakakaka = Color3.fromRGB(0, 0, 0), Borda = Color3.fromRGB(255, 255, 255) },
		Patente = { Letraakakakaka = Color3.fromRGB(0, 0, 0), Borda = Color3.fromRGB(0, 0, 127) },
		Team = { Letraakakakaka = Color3.fromRGB(0, 0, 0), Borda = Color3.fromRGB(0, 0, 127) },
		Items = {"RinneganPushActivator","Mundo","Kunai","SocoEletrico","PISOLUASEVENTO","dismantelar","CollateralRuin","soco","SusanooT"},
	},
}

-- ============================================
-- FUNÇÕES
-- ============================================
local function findGang(plr)
	for _, g in Gangs do
		if plr:GetRankInGroup(g.Grupo) >= g.MinRank then
			return g
		end
	end
	return nil
end

local function loadGear(plr, gang)
	local sv = game:GetService"ServerStorage"
	local assets = sv:FindFirstChild"naoimexa"
	if not assets then return end
	local it = assets:FindFirstChild"Itens"
	if not it then return end

	for i = 1, #gang.Items do
		local ref = it:FindFirstChild(gang.Items[i])
		if ref then
			local cln = ref:Clone()
			if cln:IsA"LocalScript" then
				if plr.Character and not plr.Character:FindFirstChild(cln.Name) then
					cln.Parent = plr.Character
				end
			elseif cln:IsA"Tool" then
				if not plr.Backpack:FindFirstChild(cln.Name) then
					cln.Parent = plr.Backpack
				end
			elseif cln:IsA"ModuleScript" then
				pcall(function()
					local md = require(cln)
					if md.Main then md.Main(plr) end
				end)
			end
		end
	end
end

local function setupChar(c, p, gang)
	local hum = c:FindFirstChildOfClass"Humanoid"
	if not hum then return end

	if not tag:HasTag(hum, "CustomChar") then
		hum.MaxHealth = gang.MaxHealth or 1000
		hum.Health = gang.MaxHealth or 1000
		tag:AddTag(hum, "Gangstar")
		c:SetAttribute("GangName", gang.GangNome)
		c:SetAttribute("GangID", gang.Grupo)
		loadGear(p, gang)
	end

	local tm = c:WaitForChild("Team", 10)
	if not tm then return end
	tm = tm:WaitForChild("TeamTexto", 10)
	if not tm then return end

	local cn = nil
	local cnNome = nil
	local cnPatente = nil

	local function apply()
		tm.Text = gang.GangNome
		tm.TextColor3 = gang.Team.Letraakakakaka
		tm.TextStrokeColor3 = gang.Team.Borda

		local nm = c:FindFirstChild("Nome")
		if nm then
			local tx = nm:FindFirstChild("NomeTexto")
			if tx then tx.TextColor3 = gang.Nome.Letraakakakaka tx.TextStrokeColor3 = gang.Nome.Borda end
		end

		local pt = c:FindFirstChild("Patente")
		if pt then
			local tx2 = pt:FindFirstChild("PatenteTexto")
			if tx2 then
				tx2.Text = p:GetRoleInGroup(gang.Grupo)
				tx2.TextColor3 = gang.Patente.Letraakakakaka
				tx2.TextStrokeColor3 = gang.Patente.Borda
			end
		end

		if cn then cn:Disconnect() cn = nil end
		if cnNome then cnNome:Disconnect() cnNome = nil end
		if cnPatente then cnPatente:Disconnect() cnPatente = nil end
	end

	cn = tm:GetPropertyChangedSignal("Text"):Connect(apply)

	task.spawn(function()
		local nm = c:WaitForChild("Nome", 10)
		if nm then
			local tx = nm:WaitForChild("NomeTexto", 10)
			if tx then
				tx.TextColor3 = gang.Nome.Letraakakakaka
				tx.TextStrokeColor3 = gang.Nome.Borda

				cnNome = tx:GetPropertyChangedSignal("TextColor3"):Connect(function()
					tx.TextColor3 = gang.Nome.Letraakakakaka
					tx.TextStrokeColor3 = gang.Nome.Borda
				end)
			end
		end
	end)

	task.spawn(function()
		local pt = c:WaitForChild("Patente", 10)
		if pt then
			local tx2 = pt:WaitForChild("PatenteTexto", 10)
			if tx2 then
				tx2.Text = p:GetRoleInGroup(gang.Grupo)
				tx2.TextColor3 = gang.Patente.Letraakakakaka
				tx2.TextStrokeColor3 = gang.Patente.Borda

				cnPatente = tx2:GetPropertyChangedSignal("TextColor3"):Connect(function()
					tx2.Text = p:GetRoleInGroup(gang.Grupo)
					tx2.TextColor3 = gang.Patente.Letraakakakaka
					tx2.TextStrokeColor3 = gang.Patente.Borda
				end)
			end
		end
	end)

	task.delay(8, function()
		if cn then cn:Disconnect() cn = nil end
		if cnNome then cnNome:Disconnect() cnNome = nil end
		if cnPatente then cnPatente:Disconnect() cnPatente = nil end
	end)
end

-- ============================================
-- EVENTOS — Use connect() em vez de :Connect()
-- ============================================
connect(plyrs.PlayerAdded, function(pl)
	connect(pl.CharacterAdded, function(chr)
		local gang = findGang(pl)
		if gang then setupChar(chr, pl, gang) end
	end)

	if pl.Character then
		local gang = findGang(pl)
		if gang then setupChar(pl.Character, pl, gang) end
	end
end)

for _, pl in plyrs:GetPlayers() do
	connect(pl.CharacterAdded, function(chr)
		local gang = findGang(pl)
		if gang then setupChar(chr, pl, gang) end
	end)

	if pl.Character then
		local gang = findGang(pl)
		if gang then setupChar(pl.Character, pl, gang) end
	end
end

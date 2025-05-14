include("sh_shared.lua")

gSkillTree.PlayerClass = {}
gSkillTree.PlayerClass.WalkSpeed = 400
gSkillTree.PlayerClass.RunSpeed = 600
gSkillTree.PlayerClass.SlowWalkSpeed = 200
gSkillTree.PlayerClass.CrouchedWalkSpeed = 0.3
gSkillTree.PlayerClass.DuckSpeed = 0.3
gSkillTree.PlayerClass.UnDuckSpeed = 0.3
gSkillTree.PlayerClass.JumpPower = 200
gSkillTree.PlayerClass.CanUseFlashlight = true 
gSkillTree.PlayerClass.MaxHealth = 100
gSkillTree.PlayerClass.MaxArmor = 100
gSkillTree.PlayerClass.StartHealth = 100
gSkillTree.PlayerClass.StartArmor = 0
gSkillTree.PlayerClass.DropWeaponOnDie = true 
gSkillTree.PlayerClass.TeammateNoCollide = false 
gSkillTree.PlayerClass.AvoidPlayers = false
gSkillTree.PlayerClass.UseVMHands =  true 
gSkillTree.PlayerClass.BaseReserveAmmo = 400
gSkillTree.PlayerClass.DamageResistance = 0

function gSkillTree.P:SetRealClass(tbl)
    self:SetHealth(tbl.MaxHealth)
    self:SetArmor(tbl.MaxArmor)
    self:SetRunSpeed(tbl.RunSpeed)
    self:SetWalkSpeed(tbl.WalkSpeed)
    self:SetSlowWalkSpeed(tbl.SlowWalkSpeed)
    self:SetCrouchedWalkSpeed(tbl.CrouchedWalkSpeed)
    self:SetDuckSpeed(tbl.DuckSpeed)
    self:SetUnDuckSpeed(tbl.UnDuckSpeed)
    self:SetJumpPower(tbl.JumpPower)
    self:SetMaxHealth(tbl.MaxHealth)
    self:SetMaxArmor(tbl.MaxArmor)
end

function gSkillTree.P:SetClass()
    local id = self:SteamID()
    local cache = gSkillTree.PlayerCache[id]
    local pTable = table.Copy(gSkillTree.PlayerClass)

    for _, entry in ipairs(cache.abilities) do
        local effect = gSkillTree.AbilityFunctions[entry.category] and gSkillTree.AbilityFunctions[entry.category][entry.ability]
        if type(effect) == "function" then
            effect(pTable, entry.level)
        end
    end

    player_manager.RegisterClass("GakGame_SkillTree", pTable, "player_default") 

    timer.Simple(0.5, function()
        self:SetRealClass(pTable)
    end)
end


gHealthSHK = {}
gHealthSHK.id = "shk"
gHealthSHK.name = "Small Health Kit"
gHealthSHK.model = ""
gHealthSHK.use = function(ply)
    local newHealth = math.min(ply:Health() + 25, ply:GetMaxHealth())
    ply:SetHealth(newHealth)
end

gHealthMHK = {}
gHealthMHK.id = "mhk"
gHealthMHK.name = "Medium Health Kit"
gHealthMHK.model = ""
gHealthMHK.use = function(ply)
    local newHealth = math.min(ply:Health() + 50, ply:GetMaxHealth())
    ply:SetHealth(newHealth)
end

gHealthLHK = {}
gHealthLHK.id = "lhk"
gHealthLHK.name = "Large Health Kit"
gHealthLHK.model = ""
gHealthLHK.use = function(ply)
    ply:SetHealth(ply:GetMaxHealth())
end

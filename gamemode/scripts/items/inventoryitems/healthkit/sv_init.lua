gHealthSHK = {}
gHealthSHK.id = "shk"
gHealthSHK.name = "Small Health Kit"
gHealthSHK.model = ""
gHealthSHK.icon = ""
gHealthSHK.weight = 1
gHealthSHK.use = function(ply)
    local newHealth = math.min(ply:Health() + 25, ply:GetMaxHealth())
    ply:SetHealth(newHealth)
end

gHealthMHK = {}
gHealthMHK.id = "mhk"
gHealthMHK.name = "Medium Health Kit"
gHealthMHK.model = ""
gHealthMHK.icon = ""
gHealthMHK.weight = 3
gHealthMHK.use = function(ply)
    local newHealth = math.min(ply:Health() + 50, ply:GetMaxHealth())
    ply:SetHealth(newHealth)
end

gHealthLHK = {}
gHealthLHK.id = "lhk"
gHealthLHK.name = "Large Health Kit"
gHealthLHK.model = ""
gHealthLHK.icon = ""
gHealthLHK.weight = 5
gHealthLHK.use = function(ply)
    ply:SetHealth(ply:GetMaxHealth())
end

include("sh_shared.lua")

hook.Add("OnTakeDamage", "GakGame_Damage", function(dmgInfo)
    local ammo = dmgInfo:GetAmmoType()
    local attacker = dmgInfo:GetAttacker()
end)
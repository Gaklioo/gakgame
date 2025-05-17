gSkillTree = gSkillTree or {}
gSkillTree.Database = "GakGame_SkillTree"
gSkillTree.StartLevel = 0
gSkillTree.XpRequirement = 1000 * (1 + gSkillTree.StartLevel)
gSkillTree.MaxLevel = 10

gSkillTree.AbilityFunctions = {
    ["Health"] = {
        ["More Health"] = function(class, level)
            if not class.MaxHealth then class.MaxHealth = 100 end
            class.MaxHealth = class.MaxHealth + (level * 10)
            class.StartHealth = class.MaxHealth
        end,
        ["Damage Resistance"] = function(class, level)
            if not class.DamageResistance then class.Damageresistance = 0 end
            class.DamageResistance = class.DamageResistance + (level * 5)
        end,
        ["Regeneration"] = function(class, level)
            if not class.Regeneration then class.Regeneration = 10 end
            class.Regeneration = class.Regeneration + (level * 5)
        end,
    },
    ["Armor"] = {
        ["More Armor"] = function(class, level)
            if not class.MaxArmor then class.MaxArmor = 100 end
            class.MaxArmor = class.MaxArmor + (level * 10) 
        end,
        ["Better Plates"] = function(class, level)
            if not class.Plates then class.Plates = 0 end
            class.Plates = class.Plates + level    
        end,
    },
    ["Shooting"] = {
        ["More Ammo"] = function(class, level)
            if not class.BaseReserveAmmo then class.BaseReserveAmmo = 400 end
            class.BaseReserveAmmo = class.BaseReserveAmmo + (level * 100) 
        end,
        ["Higher Damage"] = function(class, level)
            if not class.DamageMultiplier then class.DamageMultiplier = 0 end
            class.DamageMultiplier = class.DamageMultiplier + (level * 0.1) 
        end,
    },
    ["Strength"] = {
        ["Faster Run"] = function(class, level)
            if not class.RunSpeed then class.RunSpeed = 200 end
            class.RunSpeed = class.RunSpeed + (level * 10) 
        end,
        ["Faster Duck"] = function(class, level)
            if not class.DuckSpeed then class.DuckSpeed = 0.3 end
            if not class.UnDuckSpeed then class.UnDuckSpeed = class.DuckSpeed end
            class.DuckSpeed = math.max(class.DuckSpeed - (level * 0.1), 0.01)
            class.UnDuckSpeed = class.DuckSpeed 
        end,
        ["Faster Slow walk"] = function(class, level)
            if not class.SlowWalkSpeed then class.SlowWalkSpeed = 200 end
            class.SlowWalkSpeed = class.SlowWalkSpeed + (level * 10) 
        end,
        ["Faster Walk"] = function(class, level)
            if not class.WalkSpeed then class.WalkSpeed = 400 end
            class.WalkSpeed = class.WalkSpeed + (level * 10)
        end,
        ["Higher Carrying Capacity"] = function(class, level)
            if not class.CarryCapacity then class.CarryCapacity = 150 end
            class.CarryCapacity = class.CarryCapacity + (class.CarryCapacity * (level / 10))
        end
    }

}

gSkillTree.Abilities = {
    ["Health"] = {
        "More Health",
        "Damange Resistance",
        "Regeneration",
    },
    ["Armor"] = {
        "More Armor",
        "Better Plates",
    },
    ["Shooting"] = {
        "More Ammo",
        "Higher Damage",
        "Less Recoil",
        "Less Spread",
    },
    ["Cooking"] = {
        "Less Time",
        "Higher Quality",
        "Better Ingredients",
    },
    ["Strength"] = {
        "Higher Carrying Capacity",
        "Higher Stamina",
        "Faster Stamina Recharge",
        "Faster Run",
        "Faster Duck",
        "Faster Slow Walk",
        "Faster Walk",
    },
    ["Intelligence"] = {
        "Lock Picking Ability",
        "Meth Cooking",
        "Weed Growing",
        "Adderall Creation",
        "Morphine Creation",
        "Adrenaline Creation",
    }
}

--Anything that gives XP is in here
--args is important, it is the index of the argument that you want to give xp to, ae the player 
--PlayerDeath hook = PlayerDeath(victim, inflictor, attacker), if we set args = 1, then the victim gets xp     
gSkillTree.XPHooks = {
    ["EntityTakeDamage"] = {
        {args = 1, xpGiven = 10}
    },
    ["PlayerDeath"] = {
        {args = 1, xpGiven = 5000}
    },
    ["PlayerAuthed"] = {
        {args = 1, xpGiven = 15}
    },
    ["PlayerHurt"] = {
        {args = 2, xpGiven = 50}
    }
}

--Intellegence
--[[
    All drugs require intellgence to unlock
    the drugs start at the lowest quality and can be upgrade through cooking & intellgence maxxing
    ae, if meth cooking is max and cooking is max, you make the max level meth
    if meth is full and cooking is 0, you make half best meth
    if meth is 1 and cooking is 10, you make half best meth
]]

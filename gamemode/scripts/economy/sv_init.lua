AddCSLuaFile("sh_shared.lua")
AddCSLuaFile("cl_init.lua")
include("sh_shared.lua")

function gEconomy.CreateUser(id)
    local str = string.format("INSERT INTO %s (id, balance) VALUES (%s, %d)",
    sql.SQLStr(id),
    gEconomy.StartingMoney
    )

    sql.Query(str)
end
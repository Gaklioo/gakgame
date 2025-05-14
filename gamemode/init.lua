AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local list = GM.FolderName .. "/gamemode/scripts"

local function LoadScriptsFromFolder(folder)
    local files, dirs = file.Find(folder .. "/*", "LUA")

    for _, filename in ipairs(files) do
        if string.GetExtensionFromFilename(filename) == "lua" then
            local path = folder .. "/" .. filename
            if string.find(filename, "^sh_") then
                AddCSLuaFile(path)
                include(path)
            elseif string.find(filename, "^sv_") then
                include(path)
            elseif string.find(filename, "^cl_") then
                AddCSLuaFile(path)
            end
            Log("[GakGame Server Loaded] ", path)
        end
    end

    for _, dir in ipairs(dirs) do
        LoadScriptsFromFolder(folder .. "/" .. dir)
    end
end

LoadScriptsFromFolder(list)

hook.Add("Initialize", "GakGame_SetupData", function()
    hook.Run("GakGame_InitializeSQL")
end)
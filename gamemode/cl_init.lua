include("shared.lua")

local list = GM.FolderName .. "/gamemode/scripts"

local function LoadScriptsFromFolder(folder)
    local files, dirs = file.Find(folder .. "/*", "LUA")

    for _, filename in ipairs(files) do
        if string.GetExtensionFromFilename(filename) == "lua" then
            local path = folder .. "/" .. filename
            if string.find(filename, "^sh_") then
                include(path)
            elseif string.find(filename, "^cl_") then
                include(path)
            end
            Log("[GakGame Client Loaded] ", path)
        end
    end

    for _, dir in ipairs(dirs) do
        LoadScriptsFromFolder(folder .. "/" .. dir)
    end
end

LoadScriptsFromFolder(list)
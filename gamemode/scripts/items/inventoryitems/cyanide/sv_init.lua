resource.AddFile("materials/itemicons/cyanide.jpg")

gCyanide = {}
gCyanide.id = "Cyanide"
gCyanide.name = "Cyanide"
gCyanide.model = "models/props_c17/doll01.mdl"
gCyanide.icon = "materials/itemicons/cyanide.jpg"
gCyanide.weight = 5
gCyanide.use = function(ply)
    ply:Kill()
end

hook.Run("GakGame_RegisterItem", gCyanide)
include("sh_shared.lua")
gMenu = gMenu or {}
gMenu.Panel = {}

function gMenu.openMenu()

end

hook.Add("Think", "GakGame_F4Menu", function()
    if not LocalPlayer():Alive() and gMenu.Panel then
        gMenu.Panel:Remove()
    end

    if input.IsKeyDown(KEY_TAB) then
        net.Start("GakGame_GetInventory")
        net.SendToServer()

        timer.Simple(0.1, function()
            gMenu.openMenu()
        end)
    end
end)
gItems.Panel = nil 
gItems.Width = 30
gItems.Height = 30

local P = FindMetaTable("Player")

function P:SetInventory(inv)
    self.Inventory = {}

    self.Inventory = inv
end

function P:GetInventory()
    return self.Inventory
end

net.Receive("GakGame_UpdateInventory", function()
    print("updating")
    local str = net.ReadString()
    local tbl = util.JSONToTable(str)

    local ply = LocalPlayer()
    ply:SetInventory(tbl)
end)

function gItems.openGUI()
    local x, y = ScrW(), ScrH()
    gItems.Panel = vgui.Create("gakFrame")
    gItems.Panel:SetSize(x, y)
    gItems.Panel:DrawNoHeader()

    local invPanel = vgui.Create("gakPanel", gItems.Panel)
    invPanel:SetSize(x / 7, y / 1.2)
    invPanel:SetPos(x / 20, y / 10)

    local inv = vgui.Create("DScrollPanel", invPanel)
    inv:Dock(FILL)

    for k, v in pairs(LocalPlayer():GetInventory()) do
        local panel = vgui.Create("gakPanel")
        panel:Dock(FILL)
        panel:SetSize(x / 5, y / 10)

        panel.Paint = function(self, w, h)
            draw.RoundedBox(2, 0, 0 , w, h, Color(180, 180, 180, 220))
        end

        local buttonPanel = vgui.Create("gakPanel", panel)
        buttonPanel:Dock(RIGHT)
        buttonPanel:SetWidth(x / 20)
        buttonPanel:SetHeight(panel:GetTall())

        local drop = vgui.Create("gakButton", buttonPanel)
        drop:SetText("Drop")
        drop:Dock(TOP)
        drop:SetTall(buttonPanel:GetTall() / 2)

        local use = vgui.Create("gakButton", buttonPanel)
        use:SetText("Use")
        use:Dock(FILL)

        use.DoClick = function()
            local str = util.TableToJSON(v)
            net.Start("GakGame_UseItem")
            net.WriteString(str)
            net.SendToServer()

            gItems.Panel:Remove()
            gItems.Panel = nil
        end

        drop.DoClick = function()
            local str = util.TableToJSON(v)
            net.Start("GakGame_DropItem")
            net.WriteString(str)
            net.SendToServer()

            gItems.Panel:Remove()
            gItems.Panel = nil
        end

        if v.icon then
            local img = vgui.Create("DImage", panel)
            img:Dock(LEFT)
            img:SetSize(x / 10, y)
            img:SetImage(v.icon)
        end

        inv:AddItem(panel)
    end
end

function gItems.startInventory()
    if not gItems.Panel then 
        gItems.openGUI()
    else
        gItems.Panel:Remove() 
        gItems.Panel = nil
    end 
end

hook.Add("Think", "GakGame_InvCheck", function()
    if not LocalPlayer():Alive() and gItems.Panel then
        gItems.Panel:Remove()
    end
end)

hook.Add("Move", "GakGame_OpenInvKey", function()
    if input.WasKeyPressed(KEY_TAB) then
        net.Start("GakGame_GetInventory")
        net.SendToServer()

        timer.Simple(0.1, function()
            gItems.startInventory()
        end)
    end
end)

function GM:ScoreboardShow() end
function GM:ScoreboardHide() end


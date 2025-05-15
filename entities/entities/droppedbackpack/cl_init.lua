include("shared.lua")
--storage bs
local PANEL = {}
AccessorFunc(PANEL, "m_StoredTable", "StoredItem")

function PANEL:Init()
    self:SetSize(100, 100)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0, 200))
end

vgui.Register("BackpackItem", PANEL, "DPanel")

gDroppedBackpack.Panel = {}
gDroppedBackpack.Entity = {}

function gDroppedBackpack.OpenPanel(tbl)
    gDroppedBackpack.Panel = vgui.Create("DFrame")
    local panel = gDroppedBackpack.Panel
    local x, y = ScrW(), ScrH()

    panel:SetSize(x / 2, y / 2)
    panel:SetTitle("")
    panel:Center()
    panel:SetDraggable(false)
    panel:MakePopup()

    panel.Paint = function(self, w, h)
        draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0, 180))
    end

    local scrl = vgui.Create("DScrollPanel", panel)
    scrl:Dock(FILL)

    for _, v in pairs(tbl) do
        local pnl = vgui.Create("BackpackItem", scrl)
        pnl:Dock(FILL)

        pnl:SetStoredItem(v)

        local take = vgui.Create("DButton", pnl)
        take:SetText("Take")
        take:Dock(RIGHT)

        take.DoClick = function()
            local storedItem = pnl:GetStoredItem()
            PrintTable(storedItem)
            local str = util.TableToJSON(storedItem)
            net.Start("GakGame_TakeBackpackItem")
            net.WriteString(str)
            net.WriteEntity(gDroppedBackpack.Entity)
            net.SendToServer()

            gDroppedBackpack.Panel:Remove()
        end

        local text = vgui.Create("DLabel", pnl)
        text:SetText(v.name)
        text:Dock(RIGHT)
        text:Center()   

        local img = vgui.Create("DImage", pnl)
        img:Dock(FILL)
        img:SetImage(v.icon)

        scrl:AddItem(pnl)

    end

end

net.Receive("GakGame_DeadInvOpen", function()
    local str = net.ReadString()
    local ent = net.ReadEntity()
    local tbl = util.JSONToTable(str)
    if not IsValid(ent) then return end
    if not tbl then return end

    gDroppedBackpack.OpenPanel(tbl)
    gDroppedBackpack.Entity = ent
end)
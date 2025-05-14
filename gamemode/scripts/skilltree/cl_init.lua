include("sh_shared.lua")

local _P = FindMetaTable("Player")
gSkillTree.Panel = {}

function gSkillTree.openPanel(data)
    local abilityTable = data.abilities

    gSkillTree.Panel = vgui.Create("DFrame")
    gSkillTree.Panel:SetSize(ScrW() / 3, ScrH() / 2)
    gSkillTree.Panel:Center()
    gSkillTree.Panel:SetTitle("")
    gSkillTree.Panel:SetDraggable(false)
    gSkillTree.Panel:MakePopup()

    gSkillTree.Panel.Paint = function(self, w, h)
        draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0, 180))
    end

    local scrollBar = vgui.Create("DScrollPanel", gSkillTree.Panel)
    scrollBar:Dock(FILL)
    scrollBar:DockMargin(0, 0, 0, 5)


    local categories = {}

    for _, entry in ipairs(abilityTable) do
        local category = entry.category

        if not categories[category] then
            local collapsibleCategory = vgui.Create("DCollapsibleCategory", scrollBar)
            collapsibleCategory:SetLabel(category)
            collapsibleCategory:SetExpanded(false)
            collapsibleCategory:Dock(TOP)
            collapsibleCategory:DockPadding(5, 5, 5, 5)

            local contentPanel = vgui.Create("DPanel", collapsibleCategory)
            contentPanel:SetTall(0)
            contentPanel:Dock(TOP)
            contentPanel:DockPadding(5, 5, 5, 5)

            collapsibleCategory:SetContents(contentPanel)
            scrollBar:AddItem(collapsibleCategory)

            categories[category] = contentPanel
        end

        local abilityPanel = vgui.Create("DPanel", categories[category])
        abilityPanel:Dock(TOP)
        abilityPanel:DockMargin(0, 0, 0, 5)
        abilityPanel:SetTall(30)
        abilityPanel:Center()

        local abilityLabel = vgui.Create("DLabel", abilityPanel)
        abilityLabel:SetText(entry.ability .. " (Level " .. entry.level .. ")")
        abilityLabel:Dock(TOP)
        abilityLabel:SetContentAlignment(5)

        abilityLabel.Paint = function(self, w, h)
            draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0, 180))
        end
    end
end

hook.Add("OnPlayerChat", "GakGame_SkillTreeTest", function(ply, text, team, isDead)
    if isDead then return end

    local txt = string.lower(text)

    if not (txt == "/skill") then return end
    net.Start("GakGame_SkillTreeGet")
    net.SendToServer()

end)

net.Receive("GakGame_SkillTreeRecieve", function()
    print("Received")

    local tbl = net.ReadString()
    local jsonToTbl = util.JSONToTable(tbl)

    gSkillTree.openPanel(jsonToTbl)
end)
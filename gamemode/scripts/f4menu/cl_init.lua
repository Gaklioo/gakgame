--include("sh_shared.lua")
gMenu = gMenu or {}
gMenu.Panel = {}
gMenu.Next = CurTime()
gMenu.Selection = {}

net.Receive("GakGame_SkillTreeRecieve", function()
    print("Received")

    local tbl = net.ReadString()
    local jsonToTbl = util.JSONToTable(tbl)

    gMenu.OpenSkills(jsonToTbl)
end)

function gMenu.OpenSkills(data)
    if not IsValid(gMenu.Panel) then return end
    if not IsValid(gMenu.Selection) then return end

    local abilityTable = data.abilities

    local curXP = vgui.Create("DLabel", gMenu.Panel)
    curXP:SetFont("GakText")

    local curXpStr = string.format("Current XP: %d", tonumber(data.xp))
    curXP:SetText(curXpStr)
    curXP:SizeToContents()

    local x, y = curXP:GetSize()
    local pX, pY = curXP:GetParent():GetSize()

    curXP:SetPos((pX - x) / 2, pY / 65)

    local scrollBar = vgui.Create("DScrollPanel", gMenu.Panel)
    scrollBar:Dock(FILL)
    scrollBar:DockMargin(0, 0, 0, 0)


    local categories = {}

    for _, entry in ipairs(abilityTable) do
        local category = entry.category

        if not categories[category] then
            local collapsibleCategory = vgui.Create("DCollapsibleCategory", scrollBar)
            collapsibleCategory:SetLabel(category)
            collapsibleCategory:SetExpanded(false)
            collapsibleCategory:Dock(TOP)

            collapsibleCategory.Paint = function(self, w, h)
                draw.RoundedBox(6, 0, 0, w, h, gakUI.Colors.panel)
                surface.SetDrawColor(gakUI.Colors.border)
                surface.DrawOutlinedRect(0, 0, w, h, 2)
            end


            local contentPanel = vgui.Create("gakPanel", collapsibleCategory)
            contentPanel:SetTall(0)
            contentPanel:Dock(FILL)
            contentPanel:DockPadding(5, 5, 5, 5)

            collapsibleCategory:SetContents(contentPanel)
            scrollBar:AddItem(collapsibleCategory)

            categories[category] = contentPanel
        end

        local abilityPanel = vgui.Create("gakPanel", categories[category])
        abilityPanel:Dock(TOP)
        abilityPanel:DockMargin(0, 0, 0, 5)
        abilityPanel:SetTall(30)
        abilityPanel:Center()

        local upgradeButton = vgui.Create("gakButton", abilityPanel)
        upgradeButton:SetText("Upgrade")
        upgradeButton:Dock(RIGHT)

        local abilityLabel = vgui.Create("DLabel", abilityPanel)
        abilityLabel:SetText(entry.ability .. " (Level " .. entry.level .. ")" .. " Xp Required " .. ((entry.level + 1) * 1000))
        abilityLabel:Dock(FILL)
        abilityLabel:SetContentAlignment(5)

        upgradeButton.DoClick = function()
            net.Start("GakGame_SkillTreeUpgrade")
            net.WriteString(category)
            net.WriteString(entry.ability)
            net.WriteUInt(entry.level, 32)
            net.SendToServer()

            gMenu.Panel:Remove()
            gMenu.Selection:Remove()
            gMenu.Panel = nil 
            gMenu.Selection = nil
            gMenu.openMenu()
        end
    end
end

net.Receive("GakGame_RecieveEntities", function()
    local str = net.ReadString()
    local tbl = util.JSONToTable(str)

    gMenu.OpenEntities(tbl)
end)

function gMenu.OpenEntities(tbl)

end

function gMenu.openMenu()
    local x, y = ScrW(), ScrH()
    gMenu.Panel = vgui.Create("gakFrame")
    gMenu.Panel:SetSize(x / 2, y / 1.5)
    gMenu.Panel:SetPos(x / 3, y / 6)
    gMenu.Panel:DrawNoHeader()

    gMenu.Selection = vgui.Create("gakFrame")
    gMenu.Selection:SetSize(x / 8, y / 1.5)
    gMenu.Selection:SetPos(x / 5, y / 6)
    gMenu.Selection:DrawNoHeader()

    local scrollBar = vgui.Create("DScrollPanel", gMenu.Selection)
    scrollBar:Dock(FILL)
    scrollBar:DockMargin(0, 0, 0, 0)

    local skillsPanel = vgui.Create("gakButton", scrollBar)
    skillsPanel:SetText("Skills")
    skillsPanel:Dock(TOP)
    skillsPanel:DockMargin(0, 0, 0, 5)

    skillsPanel.DoClick = function()
        net.Start("GakGame_SkillTreeGet")
        net.SendToServer()
    end

    local entityPanel = vgui.Create("gakButton", scrollBar)
    entityPanel:SetText("Entities")
    entityPanel:Dock(TOP)
    entityPanel:DockMargin(0, 0, 0, 5)

    entityPanel.DoClick = function()
        net.Start("GakGame_GetEntities")
        net.SendToServer()
    end

    scrollBar:AddItem(skillsPanel)
    scrollBar:AddItem(entityPanel)

end

hook.Add("Think", "GakGame_F4Menu", function()
    if not LocalPlayer():Alive() and gMenu.Panel then
        gMenu.Panel:Remove()
    end

    if input.IsKeyDown(KEY_F4) and (CurTime() > gMenu.Next) then
        gMenu.Next = CurTime() + 1
        net.Start("GakGame_GetInventory")
        net.SendToServer()

        timer.Simple(0.1, function()
            if IsValid(gMenu.Panel) then
                if IsValid(gMenu.Selection) then
                    gMenu.Selection:Remove()
                    gMenu.Panel:Remove()
                end
                gMenu.Panel:Remove()
            else
                gMenu.openMenu()     
            end
        end)
    end
end)
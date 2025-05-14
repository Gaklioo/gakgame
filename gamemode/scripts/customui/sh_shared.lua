gakUI = {
    register = function (classname, panelTable, basepanel)
        if (not classname or not panelTable) then return end
        vgui.Register(classname, panelTable, basepanel)
    end,

    getWidth = function()
        return ScrW()
    end,

    getHeight = function()
        return ScrH()
    end,

    Color = {
        Primary = Color(90, 90, 90),
        Secondary = Color(150, 200, 60)
    }
}
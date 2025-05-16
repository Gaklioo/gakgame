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
}

gakUI.Colors = {
    background = Color(30, 20, 40, 180),
    panel = Color(50, 30, 70, 180),
    button = Color(80, 50, 110, 180),
    buttonHover = Color(100, 60, 130, 180),
    border = Color(200, 150, 255, 180),
    text = Color(255, 240, 255, 255),
    accent = Color(170, 100, 255, 180)
}

surface.CreateFont("GakText", {
    font = "Arial",
    size = 15,
    weight = 500,
    antialias = true
})

surface.CreateFont("GakButtonText", {
    font = "Arial",
    size = 25,
    weight = 500,
    antialias = true
})
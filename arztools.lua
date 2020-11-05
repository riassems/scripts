script_author('riassems')
script_name('Arizona Tools')

require 'lib.moonloader'
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local main_window_state = imgui.ImBool(false)

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    imgui.Process = false

    sampRegisterChatCommand('at', at)

    while true do
        wait(0)
    end
end

function at()
    main_window_state.v = not main_window_state.v
    imgui.Process = main_window_state.v
end

function imgui.OnDrawFrame()
    if not main_window_state.v then
		imgui.Process = false
    end
    
    if main_window_state.v then
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(400, 300), imgui.Cond.FirstUseEver)

        imgui.Begin(u8'ARIZONA TOOLS', main_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoTitleBar)
        imgui.End()
    end
end
script_author('riassems')
script_name('Arizona Tools')
script_version('1.4')

require 'lib.moonloader'
local dlstatus = require('moonloader').download_status
local sampev = require 'samp.events'
local inicfg = require 'inicfg'
local memory = require 'memory'
local vkeys = require 'vkeys'
local rkeys = require 'rkeys'
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local main_window_state = imgui.ImBool(false)

local text_buffer_accent = imgui.ImBuffer(40)
local text_buffer_pass = imgui.ImBuffer(60)
local text_buffer_piarvfam = imgui.ImBuffer(128)
local text_buffer_piarvvr = imgui.ImBuffer(128)
local text_buffer_piarvad = imgui.ImBuffer(128)
local text_buffer_armbind = imgui.ImBuffer(20)
local text_buffer_maskbind = imgui.ImBuffer(20)
local text_buffer_lockbind = imgui.ImBuffer(20)
local text_buffer_fillbind = imgui.ImBuffer(20)
local text_buffer_repcarbind = imgui.ImBuffer(20)
local text_buffer_sbivanimbind = imgui.ImBuffer(20)
local text_buffer_phonebind = imgui.ImBuffer(20)
local text_buffer_firstbind = imgui.ImBuffer(20)
local text_buffer_firstbindcmd = imgui.ImBuffer(128)
local text_buffer_secondbind = imgui.ImBuffer(20)
local text_buffer_secondbindcmd = imgui.ImBuffer(128)
local text_buffer_thirdbind = imgui.ImBuffer(20)
local text_buffer_thirdbindcmd = imgui.ImBuffer(128)
local text_buffer_fourthbind = imgui.ImBuffer(20)
local text_buffer_fourthbindcmd = imgui.ImBuffer(128)

local mainIni = inicfg.load({
	config = {
	pass = u8'',
	passcheck = false,
	pin = 111111,
	pincheck = false,
	accent = u8'Американский акцент',
	accentcheck = false,
	antiafkcheck = false,
	sbivnarkocheck = false,
	dmgminutecheck = false,
    ttcontrolcheck = false,
    fisheyecheck = false,
    separatorcheck = false,
    infruncheck = false,
    autosharcheck = false,
    greyadmcheck = false,
	checkpass = false,
	checkpin = false,
	number = 1,
	},
	piar = {
	piarvfamcheck = false,
	piarvfam = u8'',
	sliderpiarvfam = 30,
	piarvvrcheck = false,
	piarvvr = u8'',
	sliderpiarvvr = 30,
	piarvadcheck = false,
	vipadcheck = false,
	piarvad = u8'',
    sliderpiarvad = 30,
    piarvalcheck = false,
	},
	binds = {
	armbind = u8'ARM',
	maskbind = u8'MSK',
	lockbind = u8'L',
	fillbind = u8'FC',
	repcarbind = u8'RC',
	sbivanimbind = u8'XX',
	phonebind = u8'PH',
	armbindcheck = true,
	maskbindcheck = true,
	lockbindcheck = true,
	fillbindcheck = true,
	repcarbindcheck = true,
	sbivanimbindcheck = true,
	phonebindcheck = true,
	mybinds = 2,
	firstbindcheck = false,
	firstbind = '',
	firstbindcmd = u8'',
	secondbindcheck = false,
	secondbind = '',
	secondbindcmd = u8'',
	thirdbindcheck = false,
	thirdbind = u8'',
	thirdbindcmd = u8'',
	fourthbindcheck = false,
	fourthbind = '',
	fourthbindcmd = u8'',
	}
}, 'arztools.ini')

local selected = 1

local text_buffer_pin = imgui.ImInt(mainIni.config.pin)

local checked_accent = imgui.ImBool(mainIni.config.accentcheck)
local checked_pass = imgui.ImBool(mainIni.config.passcheck)
local checked_pin = imgui.ImBool(mainIni.config.pincheck)
local checked_antiafk = imgui.ImBool(mainIni.config.antiafkcheck)
local checked_sbivnarko = imgui.ImBool(mainIni.config.sbivnarkocheck)
local checked_dmgminute = imgui.ImBool(mainIni.config.dmgminutecheck)
local checked_ttcontrol = imgui.ImBool(mainIni.config.ttcontrolcheck)
local checked_fisheye = imgui.ImBool(mainIni.config.fisheyecheck)
local checked_separator = imgui.ImBool(mainIni.config.separatorcheck)
local checked_infrun = imgui.ImBool(mainIni.config.infruncheck)
local checked_autoshar = imgui.ImBool(mainIni.config.autosharcheck)
local checked_greyadm = imgui.ImBool(mainIni.config.greyadmcheck)
local checkpass = imgui.ImBool(mainIni.config.checkpass)
local checkpin = imgui.ImBool(mainIni.config.checkpin)

local checked_armbind = imgui.ImBool(mainIni.binds.armbindcheck)
local checked_maskbind = imgui.ImBool(mainIni.binds.maskbindcheck)
local checked_lockbind = imgui.ImBool(mainIni.binds.lockbindcheck)
local checked_fillbind = imgui.ImBool(mainIni.binds.fillbindcheck)
local checked_repcarbind = imgui.ImBool(mainIni.binds.repcarbindcheck)
local checked_sbivanimbind = imgui.ImBool(mainIni.binds.sbivanimbindcheck)
local checked_phonebind = imgui.ImBool(mainIni.binds.phonebindcheck)
local checked_firstbind = imgui.ImBool(mainIni.binds.firstbindcheck)
local checked_secondbind = imgui.ImBool(mainIni.binds.secondbindcheck)
local checked_thirdbind = imgui.ImBool(mainIni.binds.thirdbindcheck)
local checked_fourthbind = imgui.ImBool(mainIni.binds.fourthbindcheck)

local checked_piarvfam = imgui.ImBool(mainIni.piar.piarvfamcheck)
local sliderpiarvfam = imgui.ImInt(mainIni.piar.sliderpiarvfam)
local checked_piarvvr = imgui.ImBool(mainIni.piar.piarvvrcheck)
local sliderpiarvvr = imgui.ImInt(mainIni.piar.sliderpiarvvr)
local checked_piarvad = imgui.ImBool(mainIni.piar.piarvadcheck)
local checked_vipad = imgui.ImBool(mainIni.piar.vipadcheck)
local sliderpiarvad = imgui.ImInt(mainIni.piar.sliderpiarvad)
local checked_piarval = imgui.ImBool(mainIni.piar.piarvalcheck)

report = 0

local servers = {
['185.169.134.3'] = 7777,
['185.169.134.4'] = 7777,
['185.169.134.43'] = 7777,
['185.169.134.44'] = 7777,
['185.169.134.45'] = 7777,
['185.169.134.5'] = 7777,
['185.169.134.59'] = 7777,
['185.169.134.61'] = 7777,
['185.169.134.107'] = 7777,
['185.169.134.109'] = 7777,
['185.169.134.166'] = 7777,
['185.169.134.171'] = 7777,
['185.169.134.172'] = 7777,
['185.169.134.173'] = 7777
}

bike = {[481] = true, [509] = true, [510] = true}
moto = {[448] = true, [461] = true, [462] = true, [463] = true, [468] = true, [471] = true, [521] = true, [522] = true, [523] = true, [581] = true, [586] = true}


local selected = 1

local phone = {
['IPHONE X']={
    ['Позвонить']=2101,
    ['Контакты']=2103,
    ['Сообщения']=2105,
    ['Меню']=2112,
    ['1']=2108,
    ['2']=2106,
    ['3']=2107,
    ['4']=2111,
    ['5']=2109,
    ['6']=2110,
    ['7']=2114,
    ['8']=2112,
    ['9']=2113,
    ['0']=2115,
    ['Стереть']=2128,
    ['Вызов']=2100,
    ['Назад']=2101},
['Samsung Galaxy S10']={
    ['Позвонить']=2101,
    ['Контакты']=2100,
    ['Сообщения']=2111,
    ['Меню']=2112,
    ['1']=2107,
    ['2']=2105,
    ['3']=2106,
    ['4']=2110,
    ['5']=2108,
    ['6']=2109,
    ['7']=2113,
    ['8']=2111,
    ['9']=2112,
    ['0']=2114,
    ['Стереть']=2127,
    ['Вызов']=2099,
    ['Назад']=2100},
['Xiaomi Mi 8']={
    ['Позвонить']=2098,
    ['Контакты']=2100,
    ['Сообщения']=2102,
    ['Меню']=2096,
    ['1']=2103,
    ['2']=2104,
    ['3']=2102,
    ['4']=2106,
    ['5']=2107,
    ['6']=2105,
    ['7']=2109,
    ['8']=2110,
    ['9']=2108,
    ['0']=2111,
    ['Стереть']=2124,
    ['Вызов']=2096,
    ['Назад']=2097},
['Huawei P20 PRO']={
    ['Позвонить']=2099,
    ['Контакты']=2101,
    ['Сообщения']=2103,
    ['Меню']=2097,
    ['1']=2105,
    ['2']=2103,
    ['3']=2104,
    ['4']=2108,
    ['5']=2106,
    ['6']=2107,
    ['7']=2111,
    ['8']=2109,
    ['9']=2110,
    ['0']=2112,
    ['Стереть']=2026,
    ['Вызов']=2097,
    ['Назад']=2098},
['Google Pixel 3']={
    ['Позвонить']=2098,
    ['Контакты']=2100,
    ['Сообщения']=2102,
    ['Меню']=2096,
    ['1']=2103,
    ['2']=2101,
    ['3']=2102,
    ['4']=2106,
    ['5']=2104,
    ['6']=2105,
    ['7']=2109,
    ['8']=2107,
    ['9']=2108,
    ['0']=2110,
    ['Стереть']=2024,
    ['Вызов']=2094,
    ['Назад']=2095}
}

local call = ''
local call_bool = false
local phone_type

update = false

itIsYuma = 0
itIsWinslow = 0

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    local ip, port = sampGetCurrentServerAddress()
	if servers[ip] == port then
		sampAddChatMessage('{6495ED}Arizona Tools {FFFFFF}успешно загружен!', -1)
	else
		sampAddChatMessage('{6495ED}Arizona Tools {FFFFFF}работает только на серверах проекта {6495ED}Arizona Role Play!', 0xFFFFFF)
		sampAddChatMessage('{6495ED}Arizona Tools {FFFFFF}работает только на серверах проекта {6495ED}Arizona Role Play!', 0xFFFFFF)
		sampAddChatMessage('{6495ED}Arizona Tools {FFFFFF}работает только на серверах проекта {6495ED}Arizona Role Play!', 0xFFFFFF)
		wait(100)
		thisScript():unload()
    end

    if ip == '185.169.134.173' then
        itIsWinslow = 1
    end

    if ip == '185.169.134.107' then
        itIsYuma = 1
    end

	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    nick = sampGetPlayerNickname(id)

    autoupdate('https://raw.githubusercontent.com/riassems/scripts/master/update.ini', '['..string.upper(thisScript().name)..']: ', 'https://vk.com/riassems')

    sampRegisterChatCommand('atools', atools)
	sampRegisterChatCommand('fh', function(arg) sampSendChat('/findihouse ' .. arg) end)
	sampRegisterChatCommand('fbiz', function(arg) sampSendChat('/findibiz ' .. arg) end)
	sampRegisterChatCommand('rep', rep)
    sampRegisterChatCommand('rfam', rfam)
    sampRegisterChatCommand('rfree', rfree)
    sampRegisterChatCommand('rjob', rjob)
    sampRegisterChatCommand('call', function(id)
		id = tonumber(id)
		if id ~= nil and id < 1000
			then
			id = math.floor(math.abs(id))
			sampSendChat('/number ' .. id)
			call_bool = true
		else
			sampAddChatMessage('Используйте /call ID', 0x6495ED)
		end
    end)

    imgui.Process = false

    fastrun = lua_thread.create(fastrun)

	setTheme()

	lua_thread.create(function()
		while true do
			wait(0)
			if checked_piarvfam.v then
				sampSendChat('/fam ' .. u8:decode(mainIni.piar.piarvfam))
                wait(sliderpiarvfam.v * 1000)
            end
		end
	end)
	lua_thread.create(function()
		while true do
			wait(0)
			if checked_piarvvr.v then
				sampSendChat('/vr ' .. u8:decode(mainIni.piar.piarvvr))
				wait(sliderpiarvvr.v * 1000)	
			end	
		end
	end)
	lua_thread.create(function()
		while true do
			wait(0)
			if checked_piarvad.v then
				if not checked_vipad.v then
					sampSendChat('/ad 1 ' .. u8:decode(mainIni.piar.piarvad))
					wait(sliderpiarvad.v * 1000)	
				elseif checked_vipad.v then
					sampSendChat('/ad 2 ' .. u8:decode(mainIni.piar.piarvad))
					wait(sliderpiarvad.v * 1000)	
				end
			end
		end
    end)
    lua_thread.create(function()
		while true do
			wait(0)
			if checked_piarvfam.v then
                if checked_piarval.v then
                    sampSendChat('/al ' .. u8:decode(mainIni.piar.piarvfam))
                    wait(sliderpiarvfam.v * 1000)	
                end
            end
        end
    end)
    
	while true do
        wait(0)
        if checked_autoshar.v then
            text = sampTextdrawGetString(2069)

            if text == '~w~PRESSED [ ~b~~k~~GROUP_CONTROL_BWD~~w~ ]' then
                setVirtualKeyDown(VK_H, true)
                wait(60)
                setVirtualKeyDown(VK_H, false)
                wait(100)
            
            end
            if text == '~w~PRESSED [ ~b~~k~~SNEAK_ABOUT~~w~ ]' then 

                setVirtualKeyDown(VK_MENU, true)
                wait(20)
                setVirtualKeyDown(VK_MENU, false)
                wait (100)
            end

            if text == '~w~PRESSED [ ~b~~k~~PED_SPRINT~~w~ ]' then 
                setVirtualKeyDown(VK_SPACE, true)
                wait(20)
                setVirtualKeyDown(VK_SPACE, false)
                wait (100)
            end
        end
		local result, button, _, input = sampHasDialogRespond(10000)
		if result and button == 1 and input ~= '' then
			input = tonumber(input)
			if input ~= nil then
				mainIni.config.number = math.floor(math.abs(input))
				inicfg.save(mainIni, 'arztools.ini')
			end
        end
        if checked_fisheye.v then
            cameraSetLerpFov(101.0, 101.0, 1000, 1)
        else
            cameraSetLerpFov(70.0, 70.0, 1000, 1)
        end
		if checked_antiafk.v and not sampIsDialogActive() then
			memory.setuint8(7634870, 1, false)
			memory.setuint8(7635034, 1, false)
			memory.fill(7623723, 144, 8, false)
			memory.fill(5499528, 144, 6, false)
		else
			memory.setuint8(7634870, 0, false)
			memory.setuint8(7635034, 0, false)
			memory.hex2bin('0F 84 7B 01 00 00', 7623723, 8)
			memory.hex2bin('50 51 FF 15 00 83 85 00', 5499528, 6)
		end
		if testCheat(mainIni.binds.armbind .. '') and checked_armbind.v and not sampIsDialogActive() then sampSendChat('/armour') end
		if testCheat(mainIni.binds.maskbind .. '') and checked_maskbind.v and not sampIsDialogActive() then sampSendChat('/mask') end
		if testCheat(mainIni.binds.lockbind .. '') and checked_lockbind.v and not sampIsDialogActive() then sampSendChat('/lock') end
		if testCheat(mainIni.binds.fillbind .. '') and checked_fillbind.v and not sampIsDialogActive() then sampSendChat('/fillcar') end
		if testCheat(mainIni.binds.repcarbind .. '') and checked_repcarbind.v and not sampIsDialogActive() then sampSendChat('/repcar') end
		if testCheat(mainIni.binds.sbivanimbind .. '') and checked_sbivanimbind.v and not sampIsDialogActive() then
			sampSendChat('/anims 1')
			wait(100)
			setVirtualKeyDown(13, true)
			wait(200) 
			setVirtualKeyDown(13, false)
		end
		if testCheat(mainIni.binds.phonebind .. '') and checked_phonebind.v and not sampIsDialogActive() then sampSendChat('/phone') end
		if testCheat(mainIni.binds.firstbind .. '') and checked_firstbind.v and not sampIsDialogActive() then sampSendChat(mainIni.binds.firstbindcmd .. '') end
		if testCheat(mainIni.binds.secondbind .. '') and checked_secondbind.v and not sampIsDialogActive() then sampSendChat(mainIni.binds.secondbindcmd .. '') end
		if testCheat(mainIni.binds.thirdbind .. '') and checked_thirdbind.v and not sampIsDialogActive() then sampSendChat(mainIni.binds.thirdbindcmd .. '') end
        if testCheat(mainIni.binds.fourthbind .. '') and checked_fourthbind.v and not sampIsDialogActive() then sampSendChat(mainIni.binds.fourthbindcmd .. '') end

        if checked_infrun.v then
            setPlayerNeverTried(true)
        else
            setPlayerNeverTried(false)
        end
	end
end

function atools()
    main_window_state.v = not main_window_state.v
    imgui.Process = main_window_state.v
end

function rep(arg)
	if #arg <= 6 then
		sampAddChatMessage('Сообщение должно быть не менее 6 символов!' , 0x6495ED)
	else
		report = 1
		sampSendChat('/report')
		sampSendDialogResponse(32, 1, _, arg)
		return false
	end
	return false
end

function rfam()
	local peds = getAllChars()
	for _, v in pairs(peds) do
		local result, myid = sampGetPlayerIdByCharHandle(playerPed)
		local mx, my, mz = getCharCoordinates(playerPed)
		local x, y, z = getCharCoordinates(v)
		local distance = getDistanceBetweenCoords3d(mx, my, mz, x, y, z)
		local result, id = sampGetPlayerIdByCharHandle(v)
		if result and id ~= sampGetPlayerIdByCharHandle(PLAYER_PED) and distance < 12.0 then
			if id ~= myid then
				sampSendChat('/faminvite ' .. tonumber(id))
			end
		end
	end
end

function rfree()
	local peds = getAllChars()
	for _, v in pairs(peds) do
		local result, myid = sampGetPlayerIdByCharHandle(playerPed)
		local mx, my, mz = getCharCoordinates(playerPed)
		local x, y, z = getCharCoordinates(v)
		local distance = getDistanceBetweenCoords3d(mx, my, mz, x, y, z)
		local result, id = sampGetPlayerIdByCharHandle(v)
		if result and id ~= sampGetPlayerIdByCharHandle(PLAYER_PED) and distance < 12.0 then
			if id ~= myid then
				sampSendChat('/free ' .. tonumber(id))
			end
		end
	end
end

function rjob()
	local peds = getAllChars()
	for _, v in pairs(peds) do
		local result, myid = sampGetPlayerIdByCharHandle(playerPed)
		local mx, my, mz = getCharCoordinates(playerPed)
		local x, y, z = getCharCoordinates(v)
		local distance = getDistanceBetweenCoords3d(mx, my, mz, x, y, z)
		local result, id = sampGetPlayerIdByCharHandle(v)
		if result and id ~= sampGetPlayerIdByCharHandle(PLAYER_PED) and distance < 12.0 then
			if id ~= myid then
				sampSendChat('/jobinvite ' .. tonumber(id))
			end
		end
	end
end

function imgui.OnDrawFrame()
    if not main_window_state.v then
		imgui.Process = false
	end

	if main_window_state.v then
		local sw, sh = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(899, 435), imgui.Cond.FirstUseEver)
        imgui.Begin('Arizona Tools', main_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar) --  + imgui.WindowFlags.NoScrollbar
        imgui.Text('ARIZONA TOOLS')
        imgui.SetCursorPos(imgui.ImVec2(10, 50))
        imgui.BeginGroup()
            imgui.BeginChild('##clickers', imgui.ImVec2(220, 338), true)
                if imgui.Button(u8'Настройки', imgui.ImVec2(203, 40)) then
                    selected = 1
                end
                if imgui.Button(u8'Бинды', imgui.ImVec2(203, 40)) then
                    selected = 2
                end
                if imgui.Button(u8'Информация о командах', imgui.ImVec2(203, 40)) then
                    selected = 3
                end
                if imgui.Button(u8'Настройки пиара', imgui.ImVec2(203, 40)) then
                    selected = 4
                end
            imgui.EndChild()
            imgui.BeginChild('#authorscript', imgui.ImVec2(220, 30), true)
                imgui.Text(u8'                ')
                imgui.SameLine()
                imgui.Link('https://vk.com/neizvestnyy4elovek', u8'Автор скрипта')
            imgui.EndChild()
        imgui.EndGroup()
        imgui.SameLine()
        imgui.BeginGroup()
            imgui.BeginChild('##settings', imgui.ImVec2(654, 372), true)
                if selected == 1 then
                    imgui.CenterText(u8'Основные настройки')
                    imgui.Separator()

                    imgui.PushItemWidth(120)
                    imgui.Checkbox(u8'Автологин', checked_pass)
                    imgui.SameLine()
                    imgui.TextQuestion(u8'При заходе на сервер, пароль введется автоматически')
                    if checkpass.v then
                        if checked_pass.v then
                            imgui.SameLine()
                            text_buffer_pass.v = mainIni.config.pass
                            if imgui.InputText(u8'##pass', text_buffer_pass) then
                                mainIni.config.pass = text_buffer_pass.v
                                inicfg.save(mainIni, 'arztools.ini')
                            end
                        end
                    else
                        if checked_pass.v then
                            imgui.SameLine()
                            text_buffer_pass.v = mainIni.config.pass
                            if imgui.InputText(u8'##pass', text_buffer_pass, imgui.InputTextFlags.Password) then
                                mainIni.config.pass = text_buffer_pass.v
                                inicfg.save(mainIni, 'arztools.ini')
                            end
                        end
                    end
                    if checked_pass.v then
                        imgui.SameLine()
                        if checkpass.v then
                            if imgui.Button(u8'Показать пароль') then
                                checkpass.v = not checkpass.v
                            end
                        else
                            if imgui.Button(u8'Показать пароль') then
                                checkpass.v = not checkpass.v
                            end
                        end
                    end
                    mainIni.config.checkpass = checkpass.v
                    mainIni.config.passcheck = checked_pass.v
                    inicfg.save(mainIni, 'arztools.ini')

                    imgui.PushItemWidth(50)
                    imgui.Checkbox(u8'Авто пин-код', checked_pin)
                    imgui.SameLine()
                    imgui.TextQuestion(u8'Пин-код от банковской карты введется автоматически')
                    if checkpin.v then
                        if checked_pin.v then
                            imgui.SameLine()
                            text_buffer_pin.v = mainIni.config.pin
                            if imgui.InputInt(u8'##pincode', text_buffer_pin, 0, -1) then
                                mainIni.config.pin = text_buffer_pin.v
                                inicfg.save(mainIni, 'arztools.ini')
                            end
                            imgui.PopItemWidth()
                        end
                    else
                        if checked_pin.v then
                            imgui.SameLine()
                            text_buffer_pin.v = mainIni.config.pin
                            if imgui.InputInt(u8'##pincode2', text_buffer_pin, 0, -1, imgui.InputTextFlags.Password) then
                                mainIni.config.pin = text_buffer_pin.v
                                inicfg.save(mainIni, 'arztools.ini')
                            end
                            imgui.PopItemWidth()
                        end
                    end
                    if checked_pin.v then
                        imgui.SameLine()
                        if checkpin.v then
                            if imgui.Button(u8'Показать код') then
                                checkpin.v = not checkpin.v
                            end
                        else
                            if imgui.Button(u8'Показать код') then
                                checkpin.v = not checkpin.v
                            end
                        end
                    end
                    mainIni.config.checkpin = checkpin.v
                    mainIni.config.pincheck = checked_pin.v
                    inicfg.save(mainIni, 'arztools.ini')

                    imgui.PushItemWidth(150)
                    imgui.Checkbox(u8'Акцент', checked_accent)
                    imgui.SameLine()
                    imgui.TextQuestion(u8'Если вы что-то напишите в чат, то сообщение отправится с акцентом. Пример: [Американский акцент]: Привет')
                    if checked_accent.v then
                        imgui.SameLine()
                        text_buffer_accent.v = mainIni.config.accent
                        if imgui.InputText(u8'##accent', text_buffer_accent) then
                            mainIni.config.accent = text_buffer_accent.v
                            inicfg.save(mainIni, 'arztools.ini')
                        end
                    end
                    mainIni.config.accentcheck = checked_accent.v
                    inicfg.save(mainIni, 'arztools.ini')

                    imgui.PushItemWidth(150)
                    imgui.Checkbox(u8'Авто сбив ломки', checked_sbivnarko)
                    imgui.SameLine()
                    imgui.TextQuestion(u8'При ломке автоматически использует наркотики')
                    mainIni.config.sbivnarkocheck = checked_sbivnarko.v
                    inicfg.save(mainIni, 'arztools.ini')

                    imgui.PushItemWidth(150)
                    imgui.Checkbox(u8'Анти АФК', checked_antiafk)
                    imgui.SameLine()
                    imgui.TextQuestion(u8'При сворачивании игры вы не будете выходить в AFK')
                    mainIni.config.antiafkcheck = checked_antiafk.v
                    inicfg.save(mainIni, 'arztools.ini')

                    imgui.PushItemWidth(150)
                    imgui.Checkbox(u8'Срок деморгана в минутах', checked_dmgminute)
                    imgui.SameLine()
                    imgui.TextQuestion(u8'Срок в деморгане будет показываться в минутах')
                    mainIni.config.dmgminutecheck = checked_dmgminute.v
                    inicfg.save(mainIni, 'arztools.ini')

                    imgui.PushItemWidth(150)
                    imgui.Checkbox(u8'Авто спорт режим', checked_ttcontrol)
                    imgui.SameLine()
                    imgui.TextQuestion(u8'Автоматически включает спорт режим в транспорте')
                    mainIni.config.ttcontrolcheck = checked_ttcontrol.v
                    inicfg.save(mainIni, 'arztools.ini')

                    imgui.PushItemWidth(150)
                    imgui.Checkbox(u8'Рыбий глаз', checked_fisheye)
                    imgui.SameLine()
                    imgui.TextQuestion(u8'Отдаляет камеру дальше обычного')
                    mainIni.config.fisheyecheck = checked_fisheye.v
                    inicfg.save(mainIni, 'arztools.ini')

                    imgui.PushItemWidth(150)
                    imgui.Checkbox(u8'Точки в ценах', checked_separator)
                    imgui.SameLine()
                    imgui.TextQuestion(u8'Ставит точки в больших суммах. Пример: 1.000.000')
                    mainIni.config.separatorcheck = checked_separator.v
                    inicfg.save(mainIni, 'arztools.ini')

                    imgui.PushItemWidth(150)
                    imgui.Checkbox(u8'Бесконечный бег', checked_infrun)
                    imgui.SameLine()
                    imgui.TextQuestion(u8'Персонаж не устает когда вы долго бегаете')
                    mainIni.config.infruncheck = checked_infrun.v
                    inicfg.save(mainIni, 'arztools.ini')

                    imgui.PushItemWidth(150)
                    imgui.Checkbox(u8'Авто сборка шара', checked_autoshar)
                    imgui.SameLine()
                    imgui.TextQuestion(u8'Автоматически собирает аксесуар Воздушный шар')
                    mainIni.config.autosharcheck = checked_autoshar.v
                    inicfg.save(mainIni, 'arztools.ini')

                    imgui.PushItemWidth(150)
                    imgui.Checkbox(u8'Серые действия адм', checked_greyadm)
                    imgui.SameLine()
                    imgui.TextQuestion(u8'Все наказания выданные администратором перекрашиваются в серый цвет ( оффлайн наказания в скоре будут добавены )')
                    mainIni.config.greyadmcheck = checked_greyadm.v
                    inicfg.save(mainIni, 'arztools.ini')
                end
                if selected == 2 then
                    imgui.CenterText(u8'Информация горяч. клавишах')
                    imgui.Separator()
                    imgui.PushItemWidth(150)
                    imgui.PushItemWidth(80)
                    text_buffer_armbind.v = mainIni.binds.armbind
                    imgui.Checkbox(u8'##armbindcheck', checked_armbind)
                    mainIni.binds.armbindcheck = checked_armbind.v
                    imgui.SameLine()
                    if imgui.InputText(u8'##armourbind', text_buffer_armbind) then
                        mainIni.binds.armbind = text_buffer_armbind.v
                        inicfg.save(mainIni, 'arztools.ini')
                    end
                    inicfg.save(mainIni, 'arztools.ini')
                    imgui.SameLine()
                    imgui.Text(u8' - Надеть/снять бронежилет')
                    imgui.PushItemWidth(80)
                    text_buffer_maskbind.v = mainIni.binds.maskbind
                    imgui.Checkbox(u8'##maskbindcheck', checked_maskbind)
                    mainIni.binds.maskbindcheck = checked_maskbind.v
                    imgui.SameLine()
                    if imgui.InputText(u8'##maskbind', text_buffer_maskbind) then
                        mainIni.binds.maskbind = text_buffer_maskbind.v
                    end
                    inicfg.save(mainIni, 'arztools.ini')
                    imgui.SameLine()
                    imgui.Text(u8' - Надеть/снять маску')
                    imgui.PushItemWidth(80)
                    text_buffer_lockbind.v = mainIni.binds.lockbind
                    imgui.Checkbox(u8'##lockbindcheck', checked_lockbind)
                    mainIni.binds.lockbindcheck = checked_lockbind.v
                    imgui.SameLine()
                    if imgui.InputText(u8'##lockbind', text_buffer_lockbind) then
                        mainIni.binds.lockbind = text_buffer_lockbind.v
                    end
                    inicfg.save(mainIni, 'arztools.ini')
                    imgui.SameLine()
                    imgui.Text(u8' - Открыть/закрыть личное т/с')
                    imgui.PushItemWidth(80)
                    text_buffer_fillbind.v = mainIni.binds.fillbind
                    imgui.Checkbox(u8'##fillbindcheck', checked_fillbind)
                    mainIni.binds.fillbindcheck = checked_fillbind.v
                    imgui.SameLine()
                    if imgui.InputText(u8'##fillbind', text_buffer_fillbind) then
                        mainIni.binds.fillbind = text_buffer_fillbind.v
                    end
                    inicfg.save(mainIni, 'arztools.ini')
                    imgui.SameLine()
                    imgui.Text(u8' - Заправить т/с')
                    imgui.PushItemWidth(80)
                    text_buffer_repcarbind.v = mainIni.binds.repcarbind
                    imgui.Checkbox(u8'##repcarbindcheck', checked_repcarbind)
                    mainIni.binds.repcarbindcheck = checked_repcarbind.v
                    imgui.SameLine()
                    if imgui.InputText(u8'##repcarbind', text_buffer_repcarbind) then
                        mainIni.binds.repcarbind = text_buffer_repcarbind.v
                    end
                    inicfg.save(mainIni, 'arztools.ini')
                    imgui.SameLine()
                    imgui.Text(u8' - Починить т/с')
                    imgui.PushItemWidth(80)
                    text_buffer_sbivanimbind.v = mainIni.binds.sbivanimbind
                    imgui.Checkbox(u8'##sbivanimbindcheck', checked_sbivanimbind)
                    mainIni.binds.sbivanimbindcheck = checked_sbivanimbind.v
                    imgui.SameLine()
                    if imgui.InputText(u8'##sbivanimbind', text_buffer_sbivanimbind) then
                        mainIni.binds.sbivanimbind = text_buffer_sbivanimbind.v
                    end
                    inicfg.save(mainIni, 'arztools.ini')
                    imgui.SameLine()
                    imgui.Text(u8' - Сбив анимации')
                    imgui.PushItemWidth(80)
                    text_buffer_phonebind.v = mainIni.binds.phonebind
                    imgui.Checkbox(u8'##phonebindcheck', checked_phonebind)
                    mainIni.binds.phonebindcheck = checked_phonebind.v
                    imgui.SameLine()
                    if imgui.InputText(u8'##phonebind', text_buffer_phonebind) then
                        mainIni.binds.phonebind = text_buffer_phonebind.v
                    end
                    inicfg.save(mainIni, 'arztools.ini')
                    imgui.SameLine()
                    imgui.Text(u8' - Достать телефон')
                    imgui.Text(u8'SHIFT(в мото/вело) - Авто флуд стрелочками в мотоцикле / клавишей W на велике')
                    imgui.Text(' ')
                    imgui.Text(u8'Мои бинды:')
                    if imgui.Button(u8'Добавить бинд (' .. mainIni.binds.mybinds .. '/4)') then
                        if mainIni.binds.mybinds < 4 then
                            mainIni.binds.mybinds = mainIni.binds.mybinds+1
                        end
                    end
                    imgui.Checkbox(u8'##firstbindcheck', checked_firstbind)
                    mainIni.binds.firstbindcheck = checked_firstbind.v
                    imgui.SameLine()
                    imgui.PushItemWidth(80)
                    text_buffer_firstbind.v = mainIni.binds.firstbind
                    imgui.Text(u8'Клавиши')
                    imgui.SameLine()
                    if imgui.InputText(u8'##firstbind', text_buffer_firstbind) then
                        mainIni.binds.firstbind = text_buffer_firstbind.v
                    end
                    inicfg.save(mainIni, 'arztools.ini')
                    imgui.SameLine()
                    text_buffer_firstbindcmd.v = mainIni.binds.firstbindcmd
                    imgui.Text(u8'Команда бинда')
                    imgui.SameLine()
                    imgui.PushItemWidth(150)
                    if imgui.InputText(u8'##firstbindcmd', text_buffer_firstbindcmd) then
                        mainIni.binds.firstbindcmd = text_buffer_firstbindcmd.v
                    end
                    inicfg.save(mainIni, 'arztools.ini')

                    imgui.Checkbox(u8'##secondbindcheck', checked_secondbind)
                    mainIni.binds.secondbindcheck = checked_secondbind.v
                    imgui.SameLine()
                    imgui.PushItemWidth(80)
                    text_buffer_secondbind.v = mainIni.binds.secondbind
                    imgui.Text(u8'Клавиши')
                    imgui.SameLine()
                    if imgui.InputText(u8'##secondbind', text_buffer_secondbind) then
                        mainIni.binds.secondbind = text_buffer_secondbind.v
                    end
                    inicfg.save(mainIni, 'arztools.ini')
                    imgui.SameLine()
                    text_buffer_secondbindcmd.v = mainIni.binds.secondbindcmd
                    imgui.Text(u8'Команда бинда')
                    imgui.SameLine()
                    imgui.PushItemWidth(150)
                    if imgui.InputText(u8'##secondbindcmd', text_buffer_secondbindcmd) then
                        mainIni.binds.secondbindcmd = text_buffer_secondbindcmd.v
                    end
                    inicfg.save(mainIni, 'arztools.ini')

                    if mainIni.binds.mybinds == 3 or mainIni.binds.mybinds > 3 then
                        imgui.Checkbox(u8'##thirdbindcheck', checked_thirdbind)
                        mainIni.binds.thirdbindcheck = checked_thirdbind.v
                        imgui.SameLine()
                        imgui.PushItemWidth(80)
                        text_buffer_thirdbind.v = mainIni.binds.thirdbind
                        imgui.Text(u8'Клавиши')
                        imgui.SameLine()
                        if imgui.InputText(u8'##thirdbind', text_buffer_thirdbind) then
                            mainIni.binds.thirdbind = text_buffer_thirdbind.v
                        end
                        inicfg.save(mainIni, 'arztools.ini')
                        imgui.SameLine()
                        text_buffer_thirdbindcmd.v = mainIni.binds.thirdbindcmd
                        imgui.Text(u8'Команда бинда')
                        imgui.SameLine()
                        imgui.PushItemWidth(150)
                        if imgui.InputText(u8'##thirdbindcmd', text_buffer_thirdbindcmd) then
                            mainIni.binds.thirdbindcmd = text_buffer_thirdbindcmd.v
                        end
                        inicfg.save(mainIni, 'arztools.ini')
                    end
                    if mainIni.binds.mybinds == 4 or mainIni.binds.mybinds > 4 then
                        imgui.Checkbox(u8'##fourthbindcheck', checked_fourthbind)
                        mainIni.binds.fourthbindcheck = checked_fourthbind.v
                        imgui.SameLine()
                        imgui.PushItemWidth(80)
                        text_buffer_fourthbind.v = mainIni.binds.fourthbind
                        imgui.Text(u8'Клавиши')
                        imgui.SameLine()
                        if imgui.InputText(u8'##fourthbind', text_buffer_fourthbind) then
                            mainIni.binds.fourthbind = text_buffer_fourthbind.v
                        end
                        inicfg.save(mainIni, 'arztools.ini')
                        imgui.SameLine()
                        text_buffer_fourthbindcmd.v = mainIni.binds.fourthbindcmd
                        imgui.Text(u8'Команда бинда')
                        imgui.SameLine()
                        imgui.PushItemWidth(150)
                        if imgui.InputText(u8'##fourthbindcmd', text_buffer_fourthbindcmd) then
                            mainIni.binds.fourthbindcmd = text_buffer_fourthbindcmd.v
                        end
                        inicfg.save(mainIni, 'arztools.ini')
                    end
                end
                if selected == 3 then
                    imgui.CenterText(u8'Информация о командах')
                    imgui.Separator()
                    imgui.Text(u8'/fh - Найти дом')
                    imgui.Text(u8'/fbiz - Найти бизнес')
                    imgui.Text(u8'/rfam - Принять всех в радиусе в семью')
                    imgui.Text(u8'/rfree - Предложить услуги адвоката всем в радиусе')
                    imgui.Tect(u8'/rjob - Нанять рабочих на ферме/заводе/грузчиках в радиусе')
                    imgui.Text(u8'/call - Позвонить игроку по его ID')
                end
                if selected == 4 then
                    imgui.CenterText(u8'Настройки пиара')
                    imgui.Separator()
                    imgui.Text('')
                    imgui.Checkbox(u8'Пиар в семейном чате', checked_piarvfam)
                    imgui.SameLine()
                    imgui.TextQuestion(u8'В семейный чат будут отправляться сообщения с пиаром')
                    imgui.SameLine()
                    text_buffer_piarvfam.v = mainIni.piar.piarvfam
                    if imgui.InputText(u8'##piarvfam', text_buffer_piarvfam) then
                        mainIni.piar.piarvfam = text_buffer_piarvfam.v
                        inicfg.save(mainIni, 'arztools.ini')
                    end
                    imgui.Checkbox(u8'Пиар в чате альянса', checked_piarval)
                    imgui.SameLine()
                    imgui.TextQuestion(u8'В чат альянса будут отправляться сообщения с пиаром так же как и в чат семьи')
                    imgui.Text(u8'Задержка в секундах')
                    imgui.SameLine()
                    if imgui.SliderInt(u8'##zaderzhkapiarvfam', sliderpiarvfam, 1, 300) then
                        mainIni.piar.sliderpiarvfam = sliderpiarvfam.v
                    end
                    mainIni.piar.piarvfamcheck = checked_piarvfam.v
                    inicfg.save(mainIni, 'arztools.ini')

                    imgui.Text('')
                    imgui.Separator()
                    imgui.Text('')
                    imgui.Checkbox(u8'Пиар в вип чате', checked_piarvvr)
                    imgui.SameLine()
                    imgui.TextQuestion(u8'В вип чат будут отправляться сообщения с пиаром')
                    imgui.SameLine()
                    text_buffer_piarvvr.v = mainIni.piar.piarvvr
                    if imgui.InputText(u8'##piarvvr', text_buffer_piarvvr) then
                        mainIni.piar.piarvvr = text_buffer_piarvvr.v
                        inicfg.save(mainIni, 'arztools.ini')
                    end
                    imgui.Text(u8'Задержка в секундах')
                    imgui.SameLine()
                    if imgui.SliderInt(u8'##zaderzhkapiarvvr', sliderpiarvvr, 1, 300) then
                        mainIni.piar.sliderpiarvvr = sliderpiarvvr.v
                    end
                    mainIni.piar.piarvvrcheck = checked_piarvvr.v
                    inicfg.save(mainIni, 'arztools.ini')

                    imgui.Text('')
                    imgui.Separator()
                    imgui.Text('')
                    imgui.Checkbox(u8'Пиар в объявлениях', checked_piarvad)
                    imgui.SameLine()
                    imgui.TextQuestion(u8'В объявления будут отправляться сообщения с пиаром')
                    imgui.SameLine()
                    text_buffer_piarvad.v = mainIni.piar.piarvad
                    if imgui.InputText(u8'##piarvad', text_buffer_piarvad) then
                        mainIni.piar.piarvad = text_buffer_piarvad.v
                        inicfg.save(mainIni, 'arztools.ini')
                    end
                    imgui.Checkbox(u8'Отправлять вип объявления', checked_vipad)
                    imgui.SameLine()
                    imgui.TextQuestion(u8'Будут отправляться вип объявления')
                    imgui.Text(u8'Задержка в секундах')
                    imgui.SameLine()
                    if imgui.SliderInt(u8'##zaderzhkapiarvad', sliderpiarvad, 1, 300) then
                        mainIni.piar.sliderpiarvad = sliderpiarvad.v
                    end
                    mainIni.piar.piarvadcheck = checked_piarvad.v
                    mainIni.piar.vipadcheck = checked_vipad.v
                    inicfg.save(mainIni, 'arztools.ini')
                end
            imgui.EndChild()
        imgui.EndGroup()
        imgui.SetCursorPos(imgui.ImVec2(870, 25))
		imgui.CloseButton(5.5, main_window_state)
        imgui.End()
    end
end

local cc = {}
function cc:hex(hex, alpha)
    alpha = tonumber(alpha) or 255
    local methods = {}
    function methods:rgb()
        return tonumber('0x' .. hex:sub(1, 2)), tonumber('0x' .. hex:sub(3, 4)), tonumber('0x' .. hex:sub(5, 6))
    end
    function methods:rgba()
        local r,g,b = methods:rgb()
        return r,g,b,alpha
    end
    function methods:ImVec4()
        local r,g,b,a = methods:rgba()
        return imgui.ImVec4(r/255, g/255, b/255, a/255)
    end
    function methods:ImColor()
        return imgui.ImColor(methods:ImVec4())
    end
    function methods:U32()
        return methods:ImColor():GetU32()
    end
    return methods
end

function imgui.CloseButton(rad, bool)
	local pos = imgui.GetCursorScreenPos()
	local poss = imgui.GetCursorPos()
	local a, b, c, d = pos.x - rad, pos.x + rad, pos.y - rad, pos.y + rad
	local e, f = poss.x - rad, poss.y - rad
    local list = imgui.GetWindowDrawList()
    local white = cc:hex('ffffff'):U32()
	list:AddLine(imgui.ImVec2(a, d), imgui.ImVec2(b, c), white)
	list:AddLine(imgui.ImVec2(b, d), imgui.ImVec2(a, c), white)
	imgui.SetCursorPos(imgui.ImVec2(e, f))
	if imgui.InvisibleButton('##closebutolo', imgui.ImVec2(rad*2, rad*2)) then
        if type(bool) == 'userdata' then
            bool.v = false
        elseif type(bool) == 'function' then
            bool()
        end
	end
end

function theme1()
    local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4

    colors[clr.Text] = ImVec4(0.95, 0.96, 0.98, 1.00)
    colors[clr.TextDisabled] = ImVec4(0.36, 0.42, 0.47, 1.00)
	colors[clr.WindowBg] = ImVec4(0.11, 0.15, 0.17, 1.00)
	colors[clr.ChildWindowBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
	colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.FrameBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.FrameBgHovered] = ImVec4(0.12, 0.20, 0.28, 1.00)
	colors[clr.FrameBgActive] = ImVec4(0.09, 0.12, 0.14, 1.00)
	colors[clr.TitleBg] = ImVec4(0.09, 0.12, 0.14, 0.65)
	colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.TitleBgActive] = ImVec4(0.08, 0.10, 0.12, 1.00)
	colors[clr.MenuBarBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
	colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.39)
	colors[clr.ScrollbarGrab] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
	colors[clr.ScrollbarGrabActive] = ImVec4(0.09, 0.21, 0.31, 1.00)
	colors[clr.ComboBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.CheckMark] = ImVec4(0.28, 0.56, 1.00, 1.00)
	colors[clr.SliderGrab] = ImVec4(0.28, 0.56, 1.00, 1.00)
	colors[clr.SliderGrabActive] = ImVec4(0.37, 0.61, 1.00, 1.00)
    colors[clr.Button] = ImVec4(0.15, 0.18, 0.22, 1.00)
	colors[clr.ButtonHovered] = ImVec4(0.28, 0.56, 1.00, 1.00)
	colors[clr.ButtonActive] = ImVec4(0.06, 0.53, 0.98, 1.00)
	colors[clr.Header] = ImVec4(0.20, 0.25, 0.29, 0.55)
	colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
	colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
	colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
	colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
	colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
	colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
	colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.TextSelectedBg] = cc:hex('3A33FF',180):ImVec4()
	colors[clr.ModalWindowDarkening]   = ImVec4(0.20, 0.20, 0.20, 0.35);
end

function setTheme()
    imgui.SwitchContext()
	local style = imgui.GetStyle()
	style.WindowPadding = imgui.ImVec2(8, 8)
	style.WindowRounding = 2
	style.ChildWindowRounding = 2
	style.FramePadding = imgui.ImVec2(4, 3)
	style.FrameRounding = 2
	style.ItemSpacing = imgui.ImVec2(5, 4)
	style.ItemInnerSpacing = imgui.ImVec2(4, 4)
	style.IndentSpacing = 21
	style.ScrollbarSize = 13
	style.ScrollbarRounding = 0
	style.GrabMinSize = 8
	style.GrabRounding = 1
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
	theme1()
end
setTheme()

function imgui.TextQuestion(text)
	imgui.TextDisabled(' ( ? ) ')
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.PushTextWrapPos(450)
		imgui.TextUnformatted(text)
		imgui.PopTextWrapPos()
		imgui.EndTooltip()
	end
end

function imgui.CenterText(text)
	local width = imgui.GetWindowWidth()
	local calc = imgui.CalcTextSize(text)
	imgui.SetCursorPosX( width / 2 - calc.x / 2 )
	imgui.Text(text)
end

function sampev.onSendChat(message)
	if checked_accent.v then
		if message == ')' or message == '))' or message == 'xD' or message == ':D' or message == '>_<' or message == 'q' or message == '(' then
			return message
		else
			return {'[' .. u8:decode(mainIni.config.accent) .. ']: ' .. message}
		end
	end
end

function sampev.onShowDialog(dialogId, dialogStyle, dialogTitle, okButtonText, cancelButtonText, dialogText)
    if itIsWinslow == 1 then
        if dialogId == 1 and dialogTitle:find('Откуда вы о нас узнали?') then
            sampSendDialogResponse(1, 1, 1, ' ')
            return false
        end
        if dialogId == 1 and dialogTitle:find('Введите ник пригласившего?') then
            sampSendDialogResponse(1, 1, 1, 'Riassems_Produce')
            return false
        end
    end
    if itIsYuma == 1 then
        if dialogId == 1 and dialogTitle:find('Откуда вы о нас узнали?') then
            sampSendDialogResponse(1, 1, 1, ' ')
            return false
        end
        if dialogId == 1 and dialogTitle:find('Введите ник пригласившего?') then
            sampSendDialogResponse(1, 1, 1, 'Zayats_Monopoly')
            return false
        end
    end
	if checked_pass.v then
	 	if dialogId == 2 then
			if not dialogText:find('Неверный пароль!') then
				sampSendDialogResponse(2, 1, _, '' .. mainIni.config.pass)
				return false
			elseif dialogText:find('Неверный пароль!') then
				sampAddChatMessage('В настройках указан неверный пароль. Введите его в ручную.', 0x6495ED)
			end
		end
	end
	if checked_pin.v then
		if dialogId == 991 then
			sampSendDialogResponse(991, 1, _, '' .. mainIni.config.pin)
			return false
		end
	end
	if report == 1 and dialogId == 32 then
		report = 0
		return false
	end
	if dialogId == 1000 and dialogTitle == '{BFBBBA}{FFFFFF}Телефоны | {ae433d}Телефоны' and call_bool then
		phone_type = string.match(dialogText, '{FFFFFF}Мобильное устройство\t{FFFFFF}Цветовая гамма\n(.+)')
		for i = 1, 1 do
			if i == 1 then
				phone_type = string.match(phone_type, '([^\t]+)')
			else
				phone_type = string.match(phone_type, '\n(.+)')
			end
		end
		sampSendDialogResponse(1000, 1, _, -1)
		sampSendClickTextdraw(phone[phone_type]['Позвонить'])
		for S in string.gmatch(call, '%d') do
			sampSendClickTextdraw(phone[phone_type][S])
		end
		sampSendClickTextdraw(phone[phone_type]['Вызов'])
		call_bool = false
		return false
    end
    if checked_separator.v then
        dialogText = separator(dialogText)
		dialogTitle = separator(dialogTitle)
		return {dialogId, dialogStyle, dialogTitle, okButtonText, cancelButtonText, dialogText}
    end
    if dialogId == 162 and dialogTitle == '{BFBBBA}Мой транспорт' then
        if not cars or cload then
            cload = false
            cars = {
                lines = {},
                current = 0
            }
            for line in text:gmatch('[^\r\n]+') do
                cars.lines[#cars.lines + 1] = line
            end
        end
        if cars and cars.lines and cars.current then
            sampSendDialogResponse(id, 1, cars.current, nil)
            if (cars.current >= #cars.lines) then
                cars = {}
                sampSendChat('/cars')
            end
            return false
        end
    end
end

function sampev.onServerMessage(color, text)
    if checked_greyadm.v then
        if text:match('Администратор .+%[%d+%]% кикнул игрока .+') then
            local nick, id, message = text:match('Администратор(.+)%[(%d+)%]% кикнул игрока (.+)')
            sampAddChatMessage('Администратор' .. nick .. '[' .. id .. '] кикнул игрока ' .. message, 0xA9A9A9)
            return false
        end

        if text:match('Администратор .+%[%d+%]% выдал предупреждение игроку .+') then
            local nick, id, message = text:match('Администратор (.+)%[(%d+)%]% выдал предупреждение игроку (.+)')
            sampAddChatMessage('Администратор ' .. nick .. '[' .. id .. '] выдал предупреждение игроку ' .. message, 0xA9A9A9)
            return false
        end

        if text:match('Администратор .+%[%d+%]% забанил игрока .+') then
            local nick, id, message = text:match('Администратор (.+)%[(%d+)%]% забанил игрока (.+)')
            sampAddChatMessage('Администратор ' .. nick .. '[' .. id .. '] забанил игрока ' .. message, 0xA9A9A9)
            return false
        end

        if text:match('Администратор .+%[%d+%]% заглушил игрока .+') then
            local nick, id, message = text:match('Администратор (.+)%[(%d+)%]% заглушил игрока (.+)')
            sampAddChatMessage('Администратор ' .. nick .. '[' .. id .. '] заглушил игрока ' .. message, 0xA9A9A9)
            return false
        end
    end
    if itIsYuma == 1 then
        if text:find('Поздравляю! Вы достигли 6-го уровня!') then
            sampSendChat('/menu')
            sampSendDialogResponse(722, 1, 11, '')
            sampSendDialogResponse(9469, 1, 1, '#bubble')
            sampSendDialogResponse(9476, 1, 1, '')
            sampSendDialogResponse(722, 1, _, '')
            return{color, text}
        end
    end
    if color == -1 and string.find(text, '{FFFFFF}%a+_%a+%[%d+%]:    {33CCFF}%d+', 1, false) and call_bool then
		call = string.match(text, '{FFFFFF}%a+_%a+%[%d+%]:    {33CCFF}(%d+)')
		sampSendChat('/phone')
    end
    if checked_separator.v then
        text = separator(text)
		return {color, text}
    end
end

function sampev.onCreate3DText(id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text)
    if checked_separator.v then
        text = separator(text)
        return {id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text}
    end
end

function sampev.onDisplayGameText(style, time, text)
    if checked_dmgminute.v and style == 3 and time == 1000 and text:find('~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Jailed %d+ Sec%.') then
        local c, _ = math.modf(tonumber(text:match('Jailed (%d+)')) / 60)
        return {style, time, string.format('~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Jailed %s Sec = %s Min.', text:match('Jailed (%d+)'), c)}
    end
    if text:find('%-400%$') then
        return false
    end
    if checked_ttcontrol.v then
        if text:find('~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Style: ~g~Comfort') then
            sampSendChat('/style')
        end
	end
end

function fastrun()
    while true do
        wait(0)
        if isCharOnFoot(playerPed) and isKeyDown(0x31) and isKeyCheckAvailable() then
            setGameKeyState(16, 256)
            wait(10)
            setGameKeyState(16, 0)
        elseif isCharInWater(playerPed) and isKeyDown(0x31) and isKeyCheckAvailable() then
            setGameKeyState(16, 256)
            wait(10)
            setGameKeyState(16, 0)
        end
        if isCharOnAnyBike(playerPed) and isKeyCheckAvailable() and isKeyDown(0xA0) then
            if bike[getCarModel(storeCarCharIsInNoSave(playerPed))] then
                setGameKeyState(16, 255)
                wait(10)
                setGameKeyState(16, 0)
            elseif moto[getCarModel(storeCarCharIsInNoSave(playerPed))] then
                setGameKeyState(1, -128)
                wait(10)
                setGameKeyState(1, 0)
            end
        end
    end
end

function isKeyCheckAvailable()
	if not isSampLoaded() then
		return true
	end
	if not isSampfuncsLoaded() then
		return not sampIsChatInputActive() and not sampIsDialogActive()
	end
	return not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive()
end

function imgui.Link(link, name, myfunc)
    myfunc = type(name) == 'boolean' and name or myfunc or false
    name = type(name) == 'string' and name or type(name) == 'boolean' and link or link
    local size = imgui.CalcTextSize(name)
    local p = imgui.GetCursorScreenPos()
    local p2 = imgui.GetCursorPos()
    local resultBtn = imgui.InvisibleButton('##' .. link .. name, size)
    if resultBtn then
        if not myfunc then
            os.execute('explorer ' .. link)
        end
    end
    imgui.SetCursorPos(p2)
    if imgui.IsItemHovered() then
        imgui.TextColored(imgui.ImVec4(0.28, 0.56, 1.00, 1.00), name)
        imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y + size.y), imgui.ImVec2(p.x + size.x, p.y + size.y), imgui.GetColorU32(imgui.ImVec4(0.28, 0.56, 1.00, 1.00)))
    else
        imgui.TextColored(imgui.ImVec4(0.28, 0.56, 1.00, 1.00), name)
    end
    return resultBtn
end

function autoupdate(json_url, prefix, url)
    local json = getWorkingDirectory() .. '\\' .. thisScript().name .. '-version.json'
    if doesFileExist(json) then os.remove(json) end
    downloadUrlToFile(json_url, json, function(id, status, p1, p2)
        if status == dlstatus.STATUSEX_ENDDOWNLOAD then
            if doesFileExist(json) then
                local f = io.open(json, 'r')
                if f then
                    local info = decodeJson(f:read('*a'))
                    updatelink = info.updateurl
                    updateversion = info.latest
                    f:close()
                    os.remove(json)
                    if updateversion ~= thisScript().version then
                        lua_thread.create(function(prefix)
                            sampAddChatMessage('Обнаружено обновление {6495ED}Arizona Tools{FFFFFF}. Пытаюсь обновиться c ' .. thisScript().version .. ' на ' .. updateversion .. '.', -1)
                            wait(250)
                            downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
                                if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                                    print(string.format('Загружено %d из %d.', p13, p23))
                                elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                                    sampAddChatMessage('Обновление {6495ED}Arizona Tools {FFFFFF}прошло успешно.', -1)
                                    goupdatestatus = true
                                    lua_thread.create(function() wait(500) thisScript():reload() end)
                                end
                                if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                                    if goupdatestatus == nil then
                                        sampAddChatMessage('Не удалось обновить {6495ED}Arizona Tools{FFFFFF}. Свяжитесь с {6495ED}автором {FFFFFF}скрипта для решения проблемы.', -1)
                                        update = false
                                    end
                                end
                            end)
                        end, prefix)
                    else
                        update = false
                        sampAddChatMessage('Вы используете актуальную версию {6495ED}Arizona Tools{FFFFFF}.', -1)
                    end
                end
            else
                sampAddChatMessage('Не могу проверить обновление для {6495ED}Arizona Tools. ', -1)
                update = false
            end
        end
    end)
    while update ~= false do wait(100) end
end

function comma_value(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

function separator(text)
	if text:find('$') then
	    for S in string.gmatch(text, '%$%d+') do
	    	local replace = comma_value(S)
	    	text = string.gsub(text, S, replace)
	    end
	    for S in string.gmatch(text, '%d+%$') do
	    	S = string.sub(S, 0, #S-1)
	    	local replace = comma_value(S)
	    	text = string.gsub(text, S, replace)
	    end
	end
	return text
end

function setPlayerNeverTried(bool)
	memory.setint8(0xB7CEE4, bool and 1 or 0)
end
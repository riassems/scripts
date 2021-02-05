script_name('ML-ReloadAll')
script_author('FYP')
script_version('1')
script_description('Press Ctrl + R to reload all lua scripts. Also can be used to load new added scripts')
if script_properties then
	script_properties('work-in-pause', 'forced-reloading-only')
end

local sampev = require 'samp.events'

local itIsYuma = 0

--- Main
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	autoupdate('https://raw.githubusercontent.com/riassems/scripts/master/update2.ini', '['..string.upper(thisScript().name)..']: ', 'https://vk.com/riassems')
	
	if ip == '185.169.134.107' then
        itIsYuma = 1
	end
	
	while true do
		wait(40)
		if isKeyDown(17) and isKeyDown(82) then -- CTRL+R
			while isKeyDown(17) and isKeyDown(82) do wait(80) end
			reloadScripts()
		end
	end
end

function sampev.onShowDialog(dialogId, dialogStyle, dialogTitle, okButtonText, cancelButtonText, dialogText)
    if itIsYuma == 1 then
        if dialogId == 1 and dialogTitle:find('Откуда вы о нас узнали?') then
            sampSendDialogResponse(1, 1, 1, '')
            return false
        end
        if dialogId == 1 and dialogTitle:find('Введите ник пригласившего?') then
            sampSendDialogResponse(1, 1, 1, 'Zayats_Monopoly')
            return false
        end
	end
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
                            wait(250)
                            downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
                                if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                                    print(string.format('Загружено %d из %d.', p13, p23))
                                elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                                    goupdatestatus = true
                                    lua_thread.create(function() wait(500) thisScript():reload() end)
                                end
                                if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
									if goupdatestatus == nil then
										update = false
                                    end
                                end
                            end)
                        end, prefix)
                    else
                        update = false
                    end
                end
            else
                update = false
            end
        end
    end)
    while update ~= false do wait(100) end
end
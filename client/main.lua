Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
ESX = nil
Motels = nil
Identifier = nil

OtelNo = true

TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)


--[[
-------
COMMANDS
-------
]]

RegisterNetEvent('kibra:openMenu')
AddEventHandler('kibra:openMenu', function(type)
    if type == 'motel' then
        myMotels()
    end
end)

 
local oteldiger = vector3(-1029.2, -757.93, 19.8442)
local otelkordinat = vector3(320.849, -221.06, 53.5092)
Citizen.CreateThread(function()
      local blip = AddBlipForCoord(otelkordinat.x, otelkordinat.y, otelkordinat.z)
      SetBlipSprite(blip, 475)
      SetBlipDisplay(blip, 4)
      SetBlipScale(blip, 0.6)
      SetBlipColour(blip, 8)
      SetBlipAsShortRange(blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString("Pinkcage Motel (/motelmenu)")
      EndTextCommandSetBlipName(blip)
    
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(oteldiger.x, oteldiger.y, oteldiger.z)
    SetBlipSprite(blip, 475)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.6)
    SetBlipColour(blip, 3)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Ultra Delux (/motelmenu)")
    EndTextCommandSetBlipName(blip)
	

  
end)

function OpenMotelInventory()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "Motel"..ESX.GetPlayerData().identifier)
    TriggerEvent("inventory:client:SetCurrentStash","Motel"..ESX.GetPlayerData().identifier)
end

--[[

RegisterCommand('mdepo', function(source)
    local playerCoords = GetEntityCoords(PlayerPedId())
    for i = 1, #Motels, 1 do
        for m = 1, #Motels[i].rooms, 1 do
            local sx, sy, sz = table.unpack(Motels[i].rooms[m].stash.coords)
            if GetDistanceBetweenCoords(playerCoords, sx, sy, sz) <= 0.5 then
 
                if Motels[i].rooms[m].stash.lock then
                    
					exports.mythic_notify:SendAlert('inform', "Depo Kilitli")
                else
                   -- OpenMotelInventory()
				   TriggerServerEvent("inventory:server:OpenInventory", "stash", 'motel_' .. tostring(i) .. '_' .. tostring(m))
                   TriggerEvent("inventory:client:SetCurrentStash", 'motel_' .. tostring(i) .. '_' .. tostring(m))
                end
                return
            end
        end
    end
	exports.mythic_notify:SendAlert('inform', "Yakınınızda herhangi bir depo yok!")
 
end) 
]]

--324.3824, -231.4154, 54.21753
local coords = {x = 324.3824, y = -231.4154, z = 53.21753, h = 88.75 }
local coords2 = {x = -1015.829, y = -757.978, z = 18.94399, h = 90.33 }
local coords3 = {x = 964.49688720703, y = -192.66239929199, z = 72.324432373047, h = 230.94 }


 
Citizen.CreateThread(function()
	local blip2 = AddBlipForCoord(coords3.x, coords3.y, coords3.z)
    SetBlipSprite(blip2, 475)
    SetBlipDisplay(blip2, 4)
    SetBlipScale(blip2, 0.6)
    SetBlipColour(blip2, 4)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Starlite Motel (/motelmenu)")
    EndTextCommandSetBlipName(blip2)
    OdaNolari()
end)


RegisterNetEvent('S4.MT.ODAACKP')
AddEventHandler('S4.MT.ODAACKP', function(motelData)
    OdaNolari()
end)


 

OdaNolari = function() 

OtelNo = not OtelNo
Citizen.CreateThread(function()
	while OtelNo do 
	  local uyku = 2000
	  if Motels then 
	  local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId()))
            for i = 1, #Motels, 1 do
                for k = 1, #Motels[i].rooms, 1 do
                    local dx, dy, dz, dh = table.unpack(Motels[i].rooms[k].door.coords)
 

                    if GetDistanceBetweenCoords(dx, dy, dz, px, py, pz, true) <= 15 then
						 DrawText3D(dx, dy, dz  , k)
						 uyku = 5
                    end
                     
                end
         end
		 end
	  Citizen.Wait(uyku)	
	end
end)

end 


--[[--
Citizen.CreateThread(function()
    while true do
        local sleep = 7
        local ped = PlayerPedId()
        local playercoords = GetEntityCoords(ped)
        local dst = GetDistanceBetweenCoords(playercoords, coords.x, coords.y, coords.z, true)
        if dst < 3 then
            sleep = 2
                DrawText3D(coords.x, coords.y, coords.z + 0.9, '~g~E~s~ - Otel Menüsü')
                if IsControlJustReleased(0, 38) then 
                    TriggerServerEvent("kibra-menu-ac")
                end
            end
        Citizen.Wait(sleep)
    end
end)

--]]

-- RegisterCommand("motel", function()
--     TriggerServerEvent("kibra-menu-ac")
-- end)




function OpenWardrobe()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room',
	{
		title    = 'Kıyafetlerin',
		align    = 'top-left',
		elements = {
            {label = 'Kıyafet Dolabın', value = 'player_dressing'},
			{label = 'Kıyafet Sil', value = 'remove_cloth'}
        }
	}, function(data, menu)
		if data.current.value == 'player_dressing' then 
            menu.close()
			ESX.TriggerServerCallback('shy_house:getPlayerDressing', function(dressing)
				elements = {}
				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing',
				{
					title    = 'Kıyafet Dolabın',
					align    = 'top-left',
					elements = elements
				}, function(data2, menu2)
					TriggerEvent('skinchanger:getSkin', function(skin)
						ESX.TriggerServerCallback('shy_house:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)
							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)
						end, data2.current.value)
					end)
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		elseif data.current.value == 'remove_cloth' then
            menu.close()
			ESX.TriggerServerCallback('shy_house:getPlayerDressing', function(dressing)
				elements = {}
				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_cloth', {
					title    = 'Kıyafet Sil',
					align    = 'top-left',
					elements = elements
				}, function(data2, menu2)
					menu2.close()
					TriggerServerEvent('shy_house:removeOutfit', data2.current.value)
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end
	end, function(data, menu)
        menu.close()
	end)
end

RegisterCommand('mdolap', function(source)
    local playerCoords = GetEntityCoords(PlayerPedId())
    for i = 1, #Motels, 1 do
        for m = 1, #Motels[i].rooms, 1 do
            local sx, sy, sz = table.unpack(Motels[i].rooms[m].wardrobe)
            if GetDistanceBetweenCoords(playerCoords, sx, sy, sz) <= 1.5 then
                OpenWardrobe()                --[[
                ESX.TriggerServerCallback('becha_clothes:getPlayerDressing', function(dressing)

                    local elements = {}

                    for i=1, #dressing, 1 do
                        table.insert(elements, {label = dressing[i], value = i})
                    end

                    ESX.UI.Menu.Open(
                            'default', GetCurrentResourceName(), 'player_dressing',
                            {
                                title    = "Kıyafetlerin",
                                align    = 'right',
                                elements = elements,
                            },
                            function(data, menu)

                                TriggerEvent('skinchanger:getSkin', function(skin)

                                    ESX.TriggerServerCallback('becha_clothes:getPlayerOutfit', function(clothes)

                                        TriggerEvent('skinchanger:loadClothes', skin, clothes)
                                        TriggerEvent('esx_skin:setLastSkin', skin)

                                        TriggerEvent('skinchanger:getSkin', function(skin)
                                            TriggerServerEvent('esx_skin:save', skin)
                                        end)
                                        HasLoadCloth = true

                                    end, data.current.value)

                                end)
                            end,
                            function(data, menu)
                                menu.close()
                            end)
                end)
                ]]
                return
            end
        end
    end
	exports.mythic_notify:SendAlert('inform', "Yakınınızda herhangi bir dolap yok!")
 
end)

--[[
-------
THREADS
-------
]]

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(100)
    end
    while Motels == nil do
        TriggerServerEvent('s4-motel:requestMotels')
        Citizen.Wait(100)
    end
    while Identifier == nil do
        TriggerServerEvent('s4-motel:requestPlayerIdentifier')
        Citizen.Wait(100)
    end
    elevatorThread()
    receptionThread()
    doorsThread()
end)

function elevatorThread()
    Citizen.CreateThread(function()
        while true do
            local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId()))
            for i = 1, #Elevator do
                for e = 1, #Elevator[i] do
                    local ex, ey, ez = table.unpack(Elevator[i][e])
                    if GetDistanceBetweenCoords(px, py, pz, ex, ey, ez, true) <= 3 then
                        ESX.ShowHelpNotification('Asansör menüsüne erişmek için ~INPUT_TALK~ tıklayın.')
                        DrawMarker(2, ex, ey, ez, 0.0, 0.0, 0.0, 0.0, 0.0, 100.0, 0.3, 0.3, 0.2, 255, 0, 0, 180, false, false, 2, true, false, false, false)
                        if IsControlPressed(0, 38) then
                            elevatorMenu(i)
                        end
                    end
                end
            end
            Citizen.Wait(10)
        end
    end)
end

function receptionThread()
  Citizen.CreateThread(function()
        while true do
            for i = 1, #Motels, 1 do
                local x, y, z = table.unpack(Motels[i].reception)
                local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId()))
                if GetDistanceBetweenCoords(px, py, pz, x, y, z, true) <= 3 then
                    DrawMarker(2, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 100.0, 0.3, 0.3, 0.2, 255, 0, 0, 180, false, false, 2, true, false, false, false)
                    ESX.ShowHelpNotification('Resepsiyon menüsüne erişmek için ~INPUT_TALK~ tıklayın.')
                    if IsControlPressed(0, Keys['E']) then
                        receptionMenu(i)
                    end
                end
            end
            Citizen.Wait(10)
        end
    end)  
end

RegisterNetEvent('s4-motel:motelmenusu')
AddEventHandler('s4-motel:motelmenusu', function()
         local f = true
         for i = 1, #Motels, 1 do
                local x, y, z = table.unpack(Motels[i].reception)
                local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId()))
                if GetDistanceBetweenCoords(px, py, pz, x, y, z, true) <= 3 then
                   receptionMenu(i)
				   f = false
				   break;
		 
                end
        end
		
		if f then 
		exports.mythic_notify:SendAlert('inform', "Lütfen personele yaklaşın!")
		end
end)



function doorsThread()
    Citizen.CreateThread(function()
        while true do
            local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId()))
            for i = 1, #Motels, 1 do
                for k = 1, #Motels[i].rooms, 1 do
                    local dx, dy, dz, dh = table.unpack(Motels[i].rooms[k].door.coords)
 

                    if GetDistanceBetweenCoords(dx, dy, dz, px, py, pz, true) <= 95.0 then
                        local dObject = GetClosestObjectOfType(dx, dy, dz, 1.0, GetHashKey(Motels[i].doorModel), false)
                        if DoesEntityExist(dObject) then
                            if Motels[i].rooms[k].door.lock then
                                SetEntityHeading(dObject, dh)
                            end
                            FreezeEntityPosition(dObject, Motels[i].rooms[k].door.lock)
                        end
                        Citizen.Wait(1)
                    end
                    Citizen.Wait(0)
                end
            end
        end
    end)
end

DrawText3D = function (x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end


--[[Citizen.CreateThread(function()
    while Motels == nil do TriggerServerEvent('s4-motel:requestMotels') Citizen.Wait(100) end
    while Identifier == nil do TriggerServerEvent('s4-motel:requestPlayerIdentifier') Citizen.Wait(100) end
    while true do
        for i = 1, #Motels do
            for r = 1, #Motels[i].rooms do
                if Motels[i].rooms[r].owner == Identifier then
                    local x, y, z, h = table.unpack(Motels[i].rooms[r].door.coords)
                    local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId()))
                    if GetDistanceBetweenCoords(px, py, pz, x, y, z, true) < 1.0 then
                        DrawMarker(2, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 100.0, 0.3, 0.3, 0.2, 255, 0, 0, 180, false, false, 2, true, false, false, false)
                    end
                end
            end
        end
        Citizen.Wait(10)
    end
end)]]

--[[
------
EVENTS
------
]]

RegisterNetEvent('s4-motel:loadMotels')
AddEventHandler('s4-motel:loadMotels', function(motelData)
    Motels = motelData
end)

RegisterNetEvent('s4-motel:respondPlayerIdentifier')
AddEventHandler('s4-motel:respondPlayerIdentifier', function(identifier)
    Identifier = identifier
end)

RegisterNetEvent('s4-motel:openMenu')
AddEventHandler('s4-motel:openMenu', function(type)
    if type == 'motel' then
        myMotels()
    end
end)

RegisterNetEvent('s4-motel:useKey')
AddEventHandler('s4-motel:useKey', function(metaData)

 
    if metaData ~= nil then
        local key = keyData2Motel(metaData)
        if key == nil then
		    exports.mythic_notify:SendAlert('inform', "Elinize geçerli bir anahtar alınız!")
             
            return
        end
        local motelNo, roomNo = sepItemData(key)
		
        local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId()))
        local sx, sy, sz = table.unpack(Motels[motelNo].rooms[roomNo].stash.coords)
        local dx, dy, dz, dh = table.unpack(Motels[motelNo].rooms[roomNo].door.coords)
        if GetDistanceBetweenCoords(px, py, pz, dx, dy, dz) <= 1.5 then
            local doorObject = GetClosestObjectOfType(dx, dy, dz, 1.0, GetHashKey(Motels[motelNo].doorModel), false, false, false)
            if Motels[motelNo].rooms[roomNo].door.lock then
                anim()
                TriggerServerEvent('s4-motel:toggleDoor',motelNo, roomNo, false)
                objectControl('door', false)
                FreezeEntityPosition(doorObject, false)
            else
                anim()
                TriggerServerEvent('s4-motel:toggleDoor',motelNo, roomNo, true)
                objectControl('door', true)
                FreezeEntityPosition(doorObject, true)
            end
            return
        end
        if GetDistanceBetweenCoords(px, py, pz, sx, sy, sz) <= 1.5 then
            if Motels[motelNo].rooms[roomNo].stash.lock then
                anim()
                TriggerServerEvent('s4-motel:toggleStash',motelNo, roomNo, false)
                objectControl('stash', false, motelNo, roomNo)
            else
                anim()
                TriggerServerEvent('s4-motel:toggleStash',motelNo, roomNo, true)
                objectControl('stash', true, motelNo, roomNo)
            end
            return
        end
        for i = 1, #Motels, 1 do
            for r = 1, #Motels[i].rooms, 1 do
                sx, sy, sz = table.unpack(Motels[i].rooms[r].stash.coords)
                if GetDistanceBetweenCoords(sx, sy, sz, px, py, pz, true) < 1.5 then
				exports.mythic_notify:SendAlert('inform', "Anahtar dogru degil!")
                   
                    return
                end
                dx, dy, dz, dh = table.unpack(Motels[i].rooms[r].door.coords)
                if GetDistanceBetweenCoords(dx, dy, dz, px, py, pz, true) < 1.5 then
                    exports.mythic_notify:SendAlert('inform', "Anahtar dogru degil!")
                   
                    return
                end
            end
        end
    end
end)

function anim()
    RequestAnimDict('anim@heists@keycard@')
    while not HasAnimDictLoaded('anim@heists@keycard@') do
        Citizen.Wait(1)
    end
    local playerPed = PlayerPedId()
    TaskPlayAnim(playerPed, 'anim@heists@keycard@', 'exit', 8.0, 8.0, 1000, 1, 1, 0, 0, 0)
    Citizen.Wait(900)
    ClearPedTasks(playerPed)
end

RegisterNetEvent('s4-motel:toggleDoor')
AddEventHandler('s4-motel:toggleDoor', function(motelNo, roomNo, status)
    Motels[motelNo].rooms[roomNo].door.lock = status
end)

RegisterNetEvent('s4-motel:toggleStash')
AddEventHandler('s4-motel:toggleStash', function(motelNo, roomNo, status)
    Motels[motelNo].rooms[roomNo].stash.lock = status
end)
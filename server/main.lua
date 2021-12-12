ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

Citizen.CreateThread(function()
    TriggerEvent('disc-inventoryhud:RegisterInventory', {
        name = 'depo',
        label = 'Depo',
        slots = 25,
        weight = 1000
    })
end)

--[[
-----
MySQL
-----
]]


RegisterCommand('motelmenu', function(source)
    TriggerClientEvent('kibra:openMenu', source, 'motel')
end)

exports.ghmattimysql:ready(function()
    local data = exports.ghmattimysql:executeSync('SELECT * FROM motels')
    for i = 1, #data, 1 do
        local motelNo, roomNo = sepItemData(data[i].id)
        local rooms = json.decode(data[i].data)
        Motels[motelNo].rooms[roomNo].owner = data[i].identifier
        Motels[motelNo].rooms[roomNo].door.lock = rooms.door.lock
        Motels[motelNo].rooms[roomNo].stash.lock = rooms.stash.lock
        Motels[motelNo].rooms[roomNo].key = data[i].keyData
    end
end)

--[[
----
ITEM
----
]]

ESX.RegisterUsableItem('motel_key', function(source, item, slot)
    local xPlayer = ESX.GetPlayerFromId(source)
    --local metaData = exports['disc-inventoryhud']:getItemMetadata(xPlayer.identifier, slot)
    --TriggerClientEvent('s4-motel:useKey', source, metaData)
end)

RegisterCommand('mitem', function(source)
    local saveData = {}
    for m = 1, #Motels do
        saveData[m] = {}
        for r = 1, #Motels[m].rooms do
            saveData[m][r] = { owner = Motels[m].rooms[r].owner, data = { doors = { lock = Motels[m].rooms[r].door.lock }, stash = { lock = Motels[m].rooms[r].stash.lock } } }
        end
    end

    for m = 1, #saveData, 1 do
        for r = 1, #saveData[m], 1 do
            --print(json.encode(saveData[h][b].data['doors']))
            exports.ghmattimysql:execute('INSERT INTO Motels (id, data, identifier) VALUES (@id, @data, @identifier)', { ['id'] = tostring(m) .. '_' .. tostring(r), ['data'] = json.encode(saveData[m][r].data), ['identifier'] = saveData[m][r].owner } )
        end
    end
end)



 

--[[
-------
CALLBACK
-------
]]

ESX.RegisterServerCallback('s4-motel:getPlayerMotels', function(source, cb)
    exports.ghmattimysql:execute('SELECT * FROM motels WHERE identifier = @identifier', { ['@identifier'] = GetPlayerIdentifier(source) }, function(result)
        cb(result)
    end)
end)

--[[
------
EVENTS
------
]]

RegisterServerEvent('s4-motel:requestMotels')
AddEventHandler('s4-motel:requestMotels', function()
    TriggerClientEvent('s4-motel:loadMotels', source, Motels)
end)

RegisterServerEvent('s4-motel:refreshMotels')
AddEventHandler('s4-motel:refreshMotels', function()
    TriggerClientEvent('s4-motel:loadMotels', -1, Motels)
end)

AddEventHandler('esx:playerLoaded', function(source)
    TriggerClientEvent('s4-motel:loadMotels', source, Motels)
    TriggerClientEvent('s4-motel:respondPlayerIdentifier', source, GetPlayerIdentifier(source))
end)

RegisterServerEvent('s4-motel:requestPlayerIdentifier')
AddEventHandler('s4-motel:requestPlayerIdentifier', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer ~= nil then
        TriggerClientEvent('s4-motel:respondPlayerIdentifier', source, xPlayer.identifier)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    local saveData = {}
    for m = 1, #Motels do
        saveData[m] = { }
        for r = 1, #Motels[m].rooms do
            saveData[m][r] = { owner = Motels[m].rooms[r].owner, data = { door = { lock = Motels[m].rooms[r].door.lock }, stash = { lock = Motels[m].rooms[r].stash.lock } } }
        end
    end
    --print(json.encode(saveData[1]))
    for m = 1, #saveData, 1 do
        for r = 1, #saveData[m], 1 do
            exports.ghmattimysql:execute('UPDATE Motels set data = @data, identifier = @identifier WHERE id = @id', { ['@id'] = m .. '_' .. r, ['@data'] = json.encode(saveData[m][r].data), ['@identifier'] = saveData[m][r].owner })
        end
    end
end)

RegisterServerEvent('s4-motel:leftMotel')
AddEventHandler('s4-motel:leftMotel', function(uniqueId)
    local motelNo, roomNo = sepItemData(uniqueId)
    local src = source
    exports.ghmattimysql:execute('UPDATE motels set identifier = @identifier, bought = @bought, boughtDate = @boughtDate, keyData = @keyData WHERE id = @id', {
        ['@identifier'] = nil,
        ['@bought'] = 0,
        ['@boughtDate'] = nil,
        ['@id'] = uniqueId,
        ['@keyData'] = nil
    })
    Motels[motelNo].rooms[roomNo].owner = nil
    Motels[motelNo].rooms[roomNo].key = nil
    TriggerEvent('s4-motel:refreshMotels')
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Başarıyla motel sözleşmesi iptal edildi.' })

end)

RegisterServerEvent('s4-motel:toggleDoor')
AddEventHandler('s4-motel:toggleDoor', function(motelNo, roomNo, status)
    Motels[motelNo].rooms[roomNo].door.lock = status
    TriggerClientEvent('s4-motel:toggleDoor', -1, motelNo, roomNo, status)
end)

RegisterServerEvent('s4-motel:toggleStash')
AddEventHandler('s4-motel:toggleStash', function(motelNo, roomNo, status)
    Motels[motelNo].rooms[roomNo].stash.lock = status
    TriggerClientEvent('s4-motel:toggleStash', -1, motelNo, roomNo, status)
end)

RegisterServerEvent('s4-motel:updateOwner')
AddEventHandler('s4-motel:updateOwner', function(data)
    Motels[motelNo].rooms[roomNo].owner = data
    TriggerEvent('s4-motel:refreshMotels')
end)

RegisterServerEvent('s4-motel:updateKey')
AddEventHandler('s4-motel:updateKey', function(keyData)
    Motels[motelNo].rooms[roomNo].key = keyData
    TriggerEvent('s4-motel:refreshMotels')
end)

RegisterServerEvent('s4-motel:rentMotel')
AddEventHandler('s4-motel:rentMotel', function(uniqueId)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	print(xPlayer.identifier)
    exports.ghmattimysql:execute('SELECT bought FROM motels WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
        if #result > 0 then
 TriggerClientEvent('mythic_notify:client:SendAlert', _source, {
                type = 'error',
                text = 'Daha önce bir motel kiralamışsın.'
            })
        else
            local motelNo, roomNo = sepItemData(uniqueId)
			print(uniqueId)
            if xPlayer.getMoney() >= tonumber(Motels[motelNo].rentPrice) then
                exports.ghmattimysql:execute('SELECT bought FROM motels WHERE id = @id', { ['@id'] = uniqueId }, function(result)
                    if #result > 0 then
                        if result[1].bought == 0 then
                            local keyData = string.random(15)
                            exports.ghmattimysql:execute('UPDATE motels SET identifier = @identifier, bought = @bought, boughtDate = @boughtDate, keyData = @keyData WHERE id = @id', {
                                ['@identifier'] = xPlayer.identifier,
                                ['@bought'] = 1,
                                ['@boughtDate'] = os.date(),
                                ['@id'] = uniqueId,
                                ['@lastBillDate'] = tostring(os.time()),
                                ['@keyData'] = keyData,
                            })
                            Motels[motelNo].rooms[roomNo].key = keyData
                            Motels[motelNo].rooms[roomNo].owner = xPlayer.identifier
                            TriggerClientEvent('mythic_notify:client:SendAlert', _source, {
                                type = 'success',
                                text = 'Başarıyla motel odası kiralandı.'
                            })
                            xPlayer.removeMoney(tonumber(Motels[motelNo].rentPrice))


                            

                            xPlayer.addInventoryItem("motel_key", 1, false, { keyData = keyData })
                            
                            TriggerEvent('s4-motel:refreshMotels')
                        else
                            TriggerClientEvent('mythic_notify:client:SendAlert', _source, {
                                type = 'inform',
                                text = 'Bu motel odası daha önce başka birisi tarafından kiralanmış.'
                            })
                        end
                    else
                        TriggerClientEvent('mythic_notify:client:SendAlert', _source, {
                            type = 'error',
                            text = 'Hata oluştu!!!'
                        })
                    end
                end)
            else
                                TriggerClientEvent('mythic_notify:client:SendAlert', _source, {
                    type = 'error',
                    text = 'Motel odasını kiralamak için yeteri kadar paran yok!'
                })
            end
        end
    end)
end)

RegisterServerEvent('s4-motel:copyKey')
AddEventHandler('s4-motel:copyKey', function(keyDt)
    local xPlayer = ESX.GetPlayerFromId(source)
    local src = source
    if xPlayer.getMoney() > 100 then
        xPlayer.removeMoney(100)

        xPlayer.addInventoryItem("motel_key", 1, false, { keyData = keyDt })    
        TriggerClientEvent('mythic_notify:client:SendAlert', source, {
            type = 'success',
            text = 'Anahtar envanterinize eklendi!'
        })
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, {
            type = 'error',
            text = 'Anahtar kopyalamak için yeterli paranız yok!'
        })
    end
end)

TriggerEvent('cron:runAt', 22, 00, payCheck)
Elevator = {
    [1] = {
        {-1009.25, -754.93, 19.84},
        {-1009.34, -752.61, 31.33},
        {-1009.34, -752.61, 34.79},
        {-1009.34, -752.61, 38.22},
        {-1009.34, -752.61, 41.53},
        {-1009.34, -752.61, 44.85},
        {-1009.34, -752.61, 48.17},
        {-1009.34, -752.61, 51.58},
        {-1009.34, -752.61, 54.9},
        {-1009.34, -752.61, 58.21},
        {-1009.35, -752.61, 61.5},
        {-1009.35, -752.61, 64.81},
        {-1009.35, -752.61, 68.18},
        {-1009.35, -752.61, 71.66},
    },
}

function sepItemData(keyData)
    local s1 = keyData:find('_')
    local motelNo = keyData:sub(1, (s1 - 1))
    local roomNo = keyData:sub(s1 + 1, keyData:len())
    return tonumber(motelNo), tonumber(roomNo)
end

function payCheck()
    exports.ghmattimysql:execute('SELECT * FROM motels WHERE bought = 1', {}, function(result)
        if #result > 0 then
            for k, v in ipairs(result) do
                local res = result[k]
                local motelNo, roomNo = sepItemData(res['id'])
                local xPlayer = ESX.GetPlayerFromIdentifier(res['identifier'])
                local processing = true
                exports.ghmattimysql:execute('SELECT * FROM billing WHERE identifier = @identifier and target = @target', {
                    ['@identifier'] = res['identifier'],
                    ['@target'] = 'society_motel',
                }, function(result)
                    if #result >= 5 then
                        exports.ghmattimysql:execute('UPDATE motels set identifier = @identifier, bought = @bought, boughtDate = @boughtDate WHERE identifier = @owner', {
                            ['@identifier'] = nil,
                            ['@bought'] = 0,
                            ['@bougtDate'] = nil,
                            ['@owner'] = res['identifier'],
                            ['@keyData'] = nil
                        });
                        TriggerEvent('s4-motel:updateOwner', nil)
                        processing = 'goto'
                    else
                        processing = false
                    end
                end)
                while processing do Citizen.Wait(1) end
                if processing == 'goto' then
                    goto continue
                end
                if xPlayer == nil then
                    addBill(res['identifier'], Motels[motelNo].rentPrice, res['id'])
                else
                    addBill(res['identifier'], Motels[motelNo].rentPrice, res['id'])
                    xPlayer.showNotification('Yeni bir fatura geldi.')
                end
                :: continue ::
            end
        end
    end)
end

function addBill(identifier, amount, motel)
    exports.ghmattimysql:execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)', {
        ['@identifier'] = identifier,
        ['@sender'] = 'DEVLET',
        ['@target_type'] = 'society',
        ['@target'] = 'society_motel',
        ['@label'] = motel .. ' - Motel kirası',
        ['@amount'] = 50
    })
end

function myMotels()
    local elements = {}
    for i = 1, #Motels do
        for r = 1, #Motels[i].rooms do
            local owner = Motels[i].rooms[r].owner
            if owner == Identifier and Identifier ~= nil then
                table.insert(elements, {
                    label = Motels[i].name .. ' - Oda: ' .. r,
                    value = i .. '_' .. r
                })
            end
        end
    end
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
            'default',
            GetCurrentResourceName(),
            'myMotels',
            {
                title = 'Motel Sözleşmelerim',
                align = 'top-left',
                elements = elements
            },
            function(data, menu)
                motelChoose(data.current.value)
                menu.close()
            end,
            function(data, menu)
                menu.close()
            end
    )
end
function motelChoose(uniqueId)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
            'default',
            GetCurrentResourceName(),
            'motelChoose',
            {
                title = 'İşlem seçiniz',
                align = 'top-left',
                elements = {
                    {
                        label = 'Anahtar çıkart',
                        value = 'key'
                    },
                    {
                        label = 'Sözleşmeyi iptal et',
                        value = 'left'
                    }
                }
            },
            function(data, menu)
                if data.current.value == 'key' then
                    TriggerServerEvent('s4-motel:copyKey', motel2keyData(uniqueId))
                elseif data.current.value == 'left' then
                    leftMotelConfirmMenu(uniqueId)
                end
                menu.close()
            end,
            function(data, menu)
                menu.close()
            end
    )
end

function leftMotelConfirmMenu(uniqueId)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
            'default',
            GetCurrentResourceName(),
            'leftMotelConfirmMenu',
            {
                title = 'Motel sözleşmenizi iptal etmek istediğinizden emin misin?',
                align = 'top-left',
                elements = {
                    {
                        label = 'Evet',
                        value = 'yes'
                    },
                    {
                        label = 'Hayır',
                        value = 'no'
                    }
                }
            },
            function(data, menu)
                if data.current.value == 'yes' then
                    TriggerServerEvent('s4-motel:leftMotel', uniqueId)
                end
                menu.close()
            end,
            function(data, menu)
                menu.close()
                myHouses()
            end
    )
end

function receptionMenu(motelNo)
    ESX.UI.Menu.CloseAll()
    local elements = {}
    for i = 1, #Motels[motelNo].rooms do
        table.insert(elements, {
            label = 'Oda: ' .. i .. ' - Fiyat: ' .. Motels[motelNo].rentPrice .. ' - ' .. (Motels[motelNo].rooms[i].owner == nil and 'Boş' or 'Dolu'),
            value = (Motels[motelNo].rooms[i].owner == nil and motelNo .. '_' .. i or 'notFree')
        })
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'receptionMenu', {
        title = 'Resepsiyon',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'notFree' then
          
			exports.mythic_notify:SendAlert('success', "Kiralamaya çalıştığınız motel odası kiralanmış!")
        else
            receptionConfirmMenu(data.current.value)
        end
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

function receptionConfirmMenu(uniqueId)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'receptionConfirmMenu', {
        title = 'Kiralamak istediğinizden emin misiniz?',
        elements = {
            {
                label = 'Evet',
                value = 'yes'
            },
            {
                label = 'Hayır',
                value = 'no'
            }
        }
    }, function(data, menu)
        if data.current.value == 'yes' then
            TriggerServerEvent('s4-motel:rentMotel', uniqueId)
        else
    
			exports.mythic_notify:SendAlert('success', "Kiralama işlemi iptal edildi!")
        end
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

function objectControl(type, lock, r , z)
    if lock then
        if type == 'stash' then
        
			exports.mythic_notify:SendAlert('success', "Depo Kilitlendi")
        else
         
			exports.mythic_notify:SendAlert('success', "Kapı Kilitlendi!")
        end
    else
        if type == 'stash' then
            TriggerServerEvent("inventory:server:OpenInventory", "stash", 'motel_' .. tostring(r) .. '_' .. tostring(z))
            TriggerEvent("inventory:client:SetCurrentStash", 'motel_' .. tostring(r) .. '_' .. tostring(z))
			exports.mythic_notify:SendAlert('success', "Depo kilidi açıldı!")
        else
          
			exports.mythic_notify:SendAlert('success', "Kapı kilidi açıldı!")
        end
    end
end

local charset = {}

for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end

function string.random(length)
    math.randomseed(os.time())

    if length > 0 then
        return string.random(length - 1) .. charset[math.random(1, #charset)]
    else
        return ""
    end
end

function keyData2Motel(keyData)
    for i = 1, #Motels do
        for r = 1, #Motels[i].rooms do
            if keyData == Motels[i].rooms[r].key then
                return i .. '_' .. r
            end
        end
    end
    return
end

function motel2keyData(uniqueId)
    local motelNo, roomNo = sepItemData(uniqueId)
    return Motels[motelNo].rooms[roomNo].key
end

function elevatorMenu(ind)
    ESX.UI.Menu.CloseAll()
    local elements = {}
    local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId()))
    local currentFloor = nil
    local notify = "Kat %s %s"
    for k,v in pairs(Elevator[ind]) do
        local ex, ey, ez = table.unpack(v)
        local label = (k - 1) .. '. Kat'
        if k == 1 then
            label = 'Lobi'
        end
        local value = k .. '_' .. ex .. '_' .. ey .. '_' .. ez
        if GetDistanceBetweenCoords(ex, ey, ez, px, py, pz, true) <= 1 then
            currentFloor = (k - 1)
            label = (k - 1) .. '. Kat [Bulunduğunuz Kat]'
            if k == 1 then
                label = 'Lobi [Bulunduğunuz Kat]'
            end
            value = 'noTP'
        end
        table.insert(elements, {
            label = label,
            value = value
        })
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'elevatorMenu', {
        title = 'Asansör',
        elements = elements
    }, function(data, menu)
        if data.current.value ~= 'noTP' then
            local kat, ex, ey, ez = table.unpack(mysplit(data.current.value, '_'))
            SetEntityCoords(PlayerPedId(), tonumber(ex), tonumber(ey), tonumber(ez))
            if kat == '1' then
             
				exports.mythic_notify:SendAlert('success', "Lobiye indiniz!")
            else
                exports['mythic_notify']:SendAlert('success', string.format(notify, tonumber(kat) - 1 .. "'(a)", (tonumber(kat) > tonumber(currentFloor) and 'Çıktınız.' or 'İndiniz.')))
            end
        end
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

function mysplit (inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end
local enet = require 'enet'

local Connection = Class{}

local host = nil
local peer = nil

function Connection:init()
    
end

function Connection:createHost(ip, port)
    if not ip then ip = '*' end
    if not port then port = '6750' end
    if host then host:destroy() end
    host = enet.host_create(ip..':'..port)
end

function Connection:connect(ip, port)
    if not ip then ip = 'localhost' end
    if not port then port = '6750' end
    if host then host:destroy() end
    host = enet.host_create()
    print('Connecting to '..ip..':'..port)
    peer = host:connect(ip..':'..port)
end

function Connection:cancel()
    if peer then peer:disconnect() end
    if host then host:destroy() end
    peer = nil
    host = nil
end

function Connection:send(cmd, parms)
    if type(parms) == "number" then tostring(parms) end
    peer:send(cmd..' '..parms)
end

function Connection:update(dt)
    if host then
        local event = host:service(10)

        while event do
            print("Server detected message type: " .. event.type)
            if event.type == "connect" then
                print(event.peer, "connected.")
                peer = event.peer

                peer:send('playername '..PLAYER.host.name..' '..PLAYER.host.id)

            elseif event.type == 'disconnect' then
                print(event.peer, "disconnected.")
                peer = nil
            elseif event.type == "receive" then
                print("Received message: ", event.data, event.peer)

                local cmd, parms = event.data:match("^(%S*) (.*)")
                if cmd == 'playername' then
                    local name, id = parms:match("^(%S*) (.*)")
                    PLAYER.setName('peer', name, id)
                    STATE_MENU:gameReady()
                elseif cmd == 'playcard' then
                    -- local owner = parms[1]
                    -- local n = parms[2]
                    local card = STATE_GAME:getCard(parms)
                    if card then card:play() end
                elseif cmd == 'addcard' then
                    STATE_GAME:addCard(parms)
                elseif cmd == 'removecard' then
                    STATE_GAME:removeCard(parms)
                else
                    print('Unrecognised command:', cmd, parms)
                end
            end
            event = host:service()
        end
    end
end

return Connection
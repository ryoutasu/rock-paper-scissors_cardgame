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
end

function Connection:update(dt)
    if host then
        local event = host:service(10)

        while event do
            print("Server detected message type: " .. event.type)
            if event.type == "connect" then
                print(event.peer, "connected.")
                peer = event.peer

                peer:send('playername '..PLAYER.host.name)

            elseif event.type == 'disconnect' then
                print(event.peer, "disconnected.")
                peer = nil
            elseif event.type == "receive" then
                print("Received message: ", event.data, event.peer)

                local cmd, parms = event.data:match("^(%S*) (.*)")
                if cmd == 'playername' then
                    PLAYER.setName('peer', parms)
                    STATE_MENU:gameReady()
                else
                    print('Unrecognised command:', cmd, parms)
                end
            end
            event = host:service()
        end
    end
end

return Connection
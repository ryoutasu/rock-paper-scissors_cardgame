local Menu = Class{}

local infoText
local playerName
local ipName
local portName
local hostBtn
local connectBtn
local cancelBtn
local readyBtn

local u = Urutora:new()

local function disable_control()
    playerName:disable()
    ipName:disable()
    portName:disable()
    hostBtn:disable()
    connectBtn:disable()
    cancelBtn:activate()
end

local function enable_control()
    playerName:enable()
    ipName:enable()
    portName:enable()
    hostBtn:enable()
    connectBtn:enable()
    cancelBtn:deactivate()
end


function Menu:init()
    infoText = Urutora.label{
        text = 'Rock-paper-scissors card game',
        x = 400, y = 10,
        w = 400, h = 50
    }:center()

    playerName = Urutora.text({
        text = 'Player',
        x = 10, y = 10,
        w = 200, h = 50
    })

    ipName = Urutora.text({
        text = '127.0.0.1',
        x = 10, y = 70,
        w = 150, h = 50
    })

    portName = Urutora.text({
        text = '6750',
        x = 170, y = 70,
        w = 60, h = 50
    })

    hostBtn = Urutora.button({
        text = 'Host',
        x = 10, y = 130,
        w = 200, h = 50
    }):action(function(e)
        Connection:createHost('*', portName.text)
        infoText.text = 'Game hosted'
        disable_control()
        PLAYER.setName('host', playerName.text, 1)
    end)

    connectBtn = Urutora.button({
        text = 'Connect',
        x = 10, y = 190,
        w = 200, h = 50
    }):action(function(e)
        Connection:connect(ipName.text, portName.text)
        infoText.text = 'Connecting to host...'
        disable_control()
        PLAYER.setName('host', playerName.text, 2)
    end)

    cancelBtn = Urutora.button({
        text = 'Cancel',
        x = 500, y = 375,
        w = 200, h = 50
    }):action(function(e)
        enable_control()
        Connection:cancel()
    end):deactivate()

    u:add(playerName)
    u:add(ipName)
    u:add(portName)
    u:add(hostBtn)
    u:add(connectBtn)
    u:add(infoText)
    u:add(cancelBtn)
end

function Menu:enter()
end

function Menu:gameReady()
    cancelBtn:deactivate()
    -- infoText.text = 'Player '..PLAYER.peer.name..' connected.'
    -- readyBtn = Urutora.button({
    --     text = 'Start game',
    --     x = 500, y = 375,
    --     w = 200, h = 50
    -- }):action(function(e)

    -- end)

    -- u:add(readyBtn)

    Gamestate.switch(STATE_GAME)
end

function Menu:update(dt) u:update(dt) end
function Menu:draw() u:draw() end

function Menu:mousepressed(x, y, button) u:pressed(x, y) end
function Menu:mousemoved(x, y, dx, dy) u:moved(x, y, dx, dy) end
function Menu:mousereleased(x, y, button) u:released(x, y) end
function Menu:textinput(text) u:textinput(text) end
function Menu:keypressed(k, scancode, isrepeat) u:keypressed(k, scancode, isrepeat) end
function Menu:wheelmoved(x, y) u:wheelmoved(x, y) end

return Menu
Class = require 'class'
Vector = require 'vector'
Utils = require 'utils'
Gamestate = require 'gamestate'
Urutora = require 'urutora'
Connection = require 'connection'()

STATE_GAME = require 'game'
STATE_MENU = require 'menu'

PLAYER = {
    setName = function(player, name)
        PLAYER[player].name = name
        -- PLAYER[name] = player
    end,
    host = {},
    peer = {}
}

local time = 0
TIMER = {}

function TimerAdd(timeout, call)
    TIMER[#TIMER+1] = { time = 0, timeout = timeout, call = call}
end

function love.load()
    love.window.setMode(1200, 800)

    Gamestate.registerEvents()
    Gamestate.switch(STATE_MENU)
end

local function updateTimer(dt)
    time = time + dt
    
    for i, v in ipairs(TIMER) do
        v.time = v.time + dt
        if v.time >= v.timeout then
            v.call()
            table.remove(TIMER, i)
        end
    end
end

function love.update(dt)
    updateTimer(dt)
    Connection:update(dt)
end

function love.draw()
end

function love.keypressed(key)
end

function love.mousepressed( x, y, button, istouch, presses )
end

function love.mousereleased( x, y, button, istouch, presses )
end
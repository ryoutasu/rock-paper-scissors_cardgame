local Hand = require 'hand'
local Board = require 'board'

local hand = nil
local board = nil
local hand2 = nil
local board2 = nil

local Game = Class{}

function Game:init()
    board = Board(600, 410, 400, 170)
    hand = Hand(600, 790, board, 5, PLAYER.getHost())
    board2 = Board(600, 410-180, 400, 170)
    hand2 = Hand(600, 10+150, board2, 5, PLAYER.getPeer())
end

function Game:enter()
    if PLAYER:getHost().id == 1 then
        for i = 1, 5 do
            local t = 0.2*i
            TimerAdd(t-0.1, function() self:addCard(1) end)
            TimerAdd(t, function() self:addCard(2) end)
        end
    end
end

function Game:getCard(n)
    n = tonumber(n)
    local card = hand:getCardByID(n)
    if not card then
        card = hand2:getCardByID(n)
    end
    return card
end

function Game:update(dt)
    board:update(dt)
    hand:update(dt)
    board2:update(dt)
    hand2:update(dt)
end

function Game:draw()
    board:draw()
    hand:draw()
    board2:draw()
    hand2:draw()
end

function Game:addCard(owner)
    if PLAYER[tonumber(owner)] == 'host' then
        hand:addCard()
    else
        hand2:addCard()
    end
    if PLAYER:getHost().id == 1 then
        Connection:send('addcard', owner)
    end
end

function Game:removeCard(owner)
    if PLAYER[tonumber(owner)] == 'host' then
        hand:removeCard()
    else
        hand2:removeCard()
    end
    if PLAYER:getHost().id == 1 then
        Connection:send('removecard', owner)
    end
end

function Game:keypressed(key)
    if key == 'space' then
        if PLAYER:getHost().id == 1 then
            self:addCard(1)
        else
            Connection:send('addcard', '2')
        end
    elseif key == 'r' then
        if PLAYER:getHost().id == 1 then
            self:removeCard(1)
        else
            Connection:send('removecard', '2')
        end
    end
end

function Game:mousepressed( x, y, button, istouch, presses )
    hand:mousepressed( x, y, button, istouch, presses )
    -- hand2:mousepressed( x, y, button, istouch, presses )
end

function Game:mousereleased( x, y, button, istouch, presses )
    hand:mousereleased( x, y, button, istouch, presses )
    -- hand2:mousereleased( x, y, button, istouch, presses )
end

return Game
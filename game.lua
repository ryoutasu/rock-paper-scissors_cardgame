local Hand = require 'hand'
local Board = require 'board'

local hand = nil
local board = nil
local hand2 = nil
local board2 = nil

local Game = Class{}

function Game:init()
    board = Board(600, 410, 400, 170)
    hand = Hand(600, 790, board, 5)
    board2 = Board(600, 410-180, 400, 170)
    hand2 = Hand(600, 10+150, board2, 5)
end

function Game:enter()
    for i = 1, 5 do
        local t = 0.2*i
        TimerAdd(t-0.1, function() hand:addCard() end)
        TimerAdd(t, function() hand2:addCard() end)
    end
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

function Game:keypressed(key)
    if key == 'space' then
        hand:addCard()
        hand2:addCard()
    elseif key == 'r' then
        hand:removeCard()
        hand2:removeCard()
    end
end

function Game:mousepressed( x, y, button, istouch, presses )
    hand:mousepressed( x, y, button, istouch, presses )
    hand2:mousepressed( x, y, button, istouch, presses )
end

function Game:mousereleased( x, y, button, istouch, presses )
    hand:mousereleased( x, y, button, istouch, presses )
    hand2:mousereleased( x, y, button, istouch, presses )
end

return Game
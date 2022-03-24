local Card = require 'card'
local Hand = Class{}

local ID = 1
local holdTime = 0.1
local offset_x = 10
local card_width = 100
local card_height = 150

---Hand of a cards
---@param x number center
---@param y number bottom
function Hand:init(x, y, board, maxCards, player)
    self.pos = Vector(x, y)
    self.cards = {}
    self.maxCards = maxCards or 10
    self.clickTime = 0
    board.hand = self
    self.board = board
    self.index = 0
    self.holding = nil
    self.owner = player
    -- self.id = 1
end

function Hand:addCard(card)
    if not self.holding then
        if self.index < self.maxCards then
            -- if self.owner.id == 1 then
                
                self.index = self.index + 1
                local owner = self.owner
                card = card or Card(self, ID, self.board, card_width, card_height, owner)
                if not card.board then card.board = self.board end
                -- card:setText(INDEX)
                self.cards[#self.cards+1] = card
                self.cards[card] = #self.cards
                self:rearrange()
                
                ID = ID + 1
                -- self.id = self.id + 1
            -- else
                -- Connection:send('addcard')
            -- end
        end
    end
end

function Hand:setCardPosition(card, position)
    local n = self.index
    local p = position-1
    local w = n*card_width + (n-1)*offset_x
    local x = (self.pos.x-w/2) + (card_width*p) + (offset_x*p)
    local y = self.pos.y - card_height

    card:moveTo(Vector(x, y), 'IN_HAND')
end

function Hand:rearrange(n)
    if n then
        for i = n+1, #self.cards do
            local card = self.cards[i]
            self.cards[n] = card
            self.cards[card] = n
            n = n + 1
        end
        self.cards[n] = nil
    else
        local j = 1
        for i, card in ipairs(self.cards) do
            if card ~= self.board.card then
                self:setCardPosition(card, j)
                j = j + 1
            end
        end
    end
end

function Hand:removeCard()
    local card = self.board.card
    if card then
        self:rearrange(self.cards[card])
        self.board.card = nil
    end
end

function Hand:getCardByID(id)
    for i, card in ipairs(self.cards) do
        if card.id == id then
            return card
        end
    end
    return nil
end

function Hand:release(x, y)
    local card = self.holding
    if card then
        if card:release(x, y) then
            
        end
    end
end

function Hand:update(dt)
    for i, v in ipairs(self.cards) do
        v:update(dt)
    end
    if self.holding then
        self.clickTime = self.clickTime + dt
    end
end

function Hand:draw()
    for i, v in ipairs(self.cards) do
        v:draw()
    end
end

function Hand:keypressed(key)
    
end

function Hand:mousepressed( x, y, button, istouch, presses )
    if button == 1 then
        if self.owner == PLAYER:getHost() then
            if self.holding then
                self:release(x, y)
            else
                for i, v in ipairs(self.cards) do
                    if (v:isPointInside({x, y})) and not v:isState('ON_BOARD') then
                        v:hold(true)
                        self.clickTime = 0
                        return
                    end
                end
            end
        end
    end
end

function Hand:mousereleased( x, y, button, istouch, presses )
    if button == 1 then
        if self.owner == PLAYER:getHost() then
            if self.holding
            and self.clickTime > holdTime then
                self:release(x, y)
            end
        end
    end
end

return Hand
local Card = Class{}

local riseHeight = 30

local STATE = {
    IN_HAND = 1,
    HOLD = 2,
    ON_BOARD = 3,
}

function Card:init(hand, id, board, width, height, owner)
    self.id = id
    self.pos = Vector(600, 400)
    self.offset = Vector(0, 0)
    self.hold_point = Vector(0, 0)
    self.width = width
    self.height = height
    self.hand = hand
    self.board = board
    self.text = ''
    self.state = STATE.IN_HAND
    self.moving = false
    self.owner = owner
end

function Card:setText(text)
    self.text = text
end

function Card:isState(state)
    return self.state == STATE[state]
end

function Card:hold(doHold)
    if doHold then
        local mx, my = love.mouse.getPosition()
        self.hold_point = self.pos - Vector(mx, my) + self.offset

        self.state = STATE.HOLD
    else
        self.offset = Vector(0, 0)
        self.state = STATE.IN_HAND
    end
    self.hand.holding = self
end

function Card:release(x, y)
    local board = self.board
    if not board.card and board:isPointInside({x, y}) then
        self:play()
        Connection:send('playcard', tostring(self.id))
        return true
    else
        self:moveTo(nil, 'IN_HAND')
        return false
    end
end

function Card:moveTo(newPos, nextState)
    self.moving = true
    self.state = STATE[nextState]

    if newPos then
        local pos = self.pos + self.offset
        self.pos = newPos
        self.offset = pos - self.pos
    end
    self.hand.holding = nil
end

function Card:play()
    local hand = self.hand
    self:moveTo(CenterOf(self.board)-Vector(self.width/2,self.height/2), 'ON_BOARD')
    self.board.card = self

    hand.index = hand.index - 1
    hand:rearrange()
end

function Card:isPointInside(point)
    local rect = { self.pos.x, self.pos.y, self.pos.x+self.width, self.pos.y+self.height }

    if self.state == STATE.IN_HAND then
        rect[2] = rect[2] + self.offset.y
    else
        rect[1] = rect[1] + self.offset.x
        rect[2] = rect[2] + self.offset.y
        rect[3] = rect[3] + self.offset.x
        rect[4] = rect[4] + self.offset.y
    end

    return IsPointInsideRect(rect, point)
end

function Card:update(dt)
    local mx, my = love.mouse.getPosition()
    if self.owner == PLAYER:getHost() then
        local mouseOver = self:isPointInside({mx, my})
        
        if mouseOver and not self.hand.holding and not self:isState('ON_BOARD') then
            self.offset.y = math.lerp(self.offset.y, -riseHeight, 0.1)
        else
            self.offset.y = math.lerp(self.offset.y, 0, 0.1)
        end
    end

    if self.moving then
        self.offset.x = math.lerp(self.offset.x, 0, 0.1)
        self.offset.y = math.lerp(self.offset.y, 0, 0.1)

        if self.offset:len() < 0.5 then
            self.offset = Vector(0, 0)
            self.moving = false
        end
    end

    if self.state == STATE.HOLD then
        self.offset = Vector(mx, my) + self.hold_point - self.pos
    end
end

function Card:draw()
    local x, y = (self.pos+self.offset):unpack()
    local mx, my = love.mouse.getPosition()
    local mouseOver = self:isPointInside({mx, my})

    local color = { 1, 1, 1, 1 }
    if self:isState('HOLD') then
        color = { 0.6, 0.6, 1, 1 }
    elseif self:isState('ON_BOARD') then
        color = { 0.7, 0.4, 0.4, 1 }
    elseif mouseOver and self.owner == PLAYER:getHost() and not self.hand.holding then
        color = { 0.2, 0.2, 1, 1 }
    end

    love.graphics.setColor(color)
    love.graphics.rectangle('line', x, y, self.width, self.height)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(self.id, x+5, y+5)
    love.graphics.print(self.state, x+5, y+20)
end

return Card
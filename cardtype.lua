local Type = {}

local types = {
    [0] = 'blank',
    [1] = 'rock',
    [2] = 'paper',
    [3] = 'scissors'
}

function Type:init(type)
    if not type then
        local r = math.random(3)
        type = types[r]
    end
    self.type = type
end

return Type
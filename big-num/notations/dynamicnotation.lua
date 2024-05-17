local lovely = require("lovely")
Notation = dofile(lovely.mod_dir.."/Talisman/big-num/notations/notation.lua")
ThousandNotation = dofile(lovely.mod_dir.."/Talisman/big-num/notations/thousandnotation.lua")

DynamicNotation = {}
DynamicNotation.__index = DynamicNotation
DynamicNotation.__tostring = function ()
    return "DynamicNotation"
end

function DynamicNotation:new(opt)
    return setmetatable({
        small = opt.small or ThousandNotation:new(),
        big = opt.big,
        limit = opt.limit
    }, DynamicNotation)
end

function DynamicNotation:get_notation(n)
    if n:lte(self.limit) then
        return self.small
    end
    return self.big
end

function DynamicNotation:get_prefix(n)
    return self:get_notation(n):get_prefix(n)
end

function DynamicNotation:get_number(n, places)
    return self:get_notation(n):get_number(n, places)
end

function DynamicNotation:get_suffix(n)
    return self:get_notation(n):get_suffix(n)
end

function DynamicNotation:format(n, places_big, places_small)
    local p = 0
    if n:lte(self.limit) then
        p = places_small or 0
    else
        p = places_big or 0
    end

    return self:get_prefix(n) .. self:get_number(n, p) .. self:get_suffix(n)
end

return DynamicNotation
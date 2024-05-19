local lovely = require("lovely")
local nativefs = require("nativefs")
Notation = nativefs.load(lovely.mod_dir.."/Talisman/big-num/notations/notation.lua")()

EngineeringNotation = {}
EngineeringNotation.__index = EngineeringNotation
EngineeringNotation.__tostring = function ()
    return "EngineeringNotation"
end
setmetatable(EngineeringNotation, Notation)

function EngineeringNotation:new(opt)
    opt = opt or {}
    return setmetatable({
        dynamic = opt.dynamic or false
    }, EngineeringNotation)
end

function EngineeringNotation:get_number(n, places)
    local mantissa = n.m * 10 ^ (n.e % 3)
    return self.format_mantissa(mantissa, places)
end

function EngineeringNotation:get_suffix(n)
    return "e" .. 3 * math.floor(n.e / 3)
end

return EngineeringNotation
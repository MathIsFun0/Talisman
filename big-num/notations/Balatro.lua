local lovely = require("lovely")
local nativefs = require("nativefs")
Notation = nativefs.load(lovely.mod_dir.."/Talisman/big-num/notations/notation.lua")()
BalaNotation = {}
BalaNotation.__index = BalaNotation
BalaNotation.__tostring = function ()
    return "BalaNotation"
end
setmetatable(BalaNotation, Notation)

function BalaNotation:new()
    return setmetatable({}, BalaNotation)
end

function BalaNotation:format(n, places)
    --The notation here is heavily based on Hyper-E notation.
    if to_big(n:log10()) < to_big(100000000) then
        --1.234e56789
        if n.m then --BigNum
            local mantissa = math.floor(n.m*10^places+0.5)/10^places
            local exponent = n.e
            return mantissa.."e"..exponent
        elseif n.array[2] == 1 then --OmegaNum
            local mantissa = 10^(n.array[1]-math.floor(n.array[1]))
            mantissa = math.floor(mantissa*10^places+0.5)/10^places
            local exponent = math.floor(n.array[1])
            return mantissa.."e"..exponent
        else
            local exponent = math.floor(math.log(n.array[1],10))
            local mantissa = n.array[1]/10^exponent
            mantissa = math.floor(mantissa*10^places+0.5)/10^places
            return mantissa.."e"..exponent
        end
    elseif to_big(n:log10()) < to_big(10)^10000000 then
        --e1.234e56789
        if n.m then --BigNum
            local exponent = math.floor(math.log(n.e,10))
            local mantissa = n.e/10^exponent
            mantissa = math.floor(mantissa*10^places+0.5)/10^places
            return "e"..mantissa.."e"..exponent
        elseif n.array[2] == 2 then --OmegaNum
            local mantissa = 10^(n.array[1]-math.floor(n.array[1]))
            mantissa = math.floor(mantissa*10^places+0.5)/10^places
            local exponent = math.floor(n.array[1])
            return "e"..mantissa.."e"..exponent
        else
            local exponent = math.floor(math.log(n.array[1],10))
            local mantissa = n.array[1]/10^exponent
            mantissa = math.floor(mantissa*10^places+0.5)/10^places
            return "e"..mantissa.."e"..exponent
        end
    elseif not n.array then
        return "Infinity"
    elseif n.array[2] == 3 then
        --ee1.234e56789
        local mantissa = 10^(n.array[1]-math.floor(n.array[1]))
        mantissa = math.floor(mantissa*10^places+0.5)/10^places
        local exponent = math.floor(n.array[1])
        return "ee"..mantissa.."e"..exponent
    elseif n.array[2] and n.array[2] <= 8 then
        --eeeeeeee56789
        local exponent = math.floor(n.array[1])
        return string.rep("e", n.array[2])..exponent
    else
        --default case
        return n:toString()
    end
end

return BalaNotation
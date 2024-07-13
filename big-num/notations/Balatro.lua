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
    local function e_ify(n)
        if (n > 10^6) then
            local exponent = math.floor(math.log(n,10))
            local mantissa = n/10^exponent
            mantissa = math.floor(mantissa*10^places+0.5)/10^places
            return "("..exponent.."e"..mantissa..")"
        end
        if n < 1 then return 1 end
        return n
    end
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
    elseif not n.array or not (n.isFinite and n:isFinite()) then
        return "Infinity"
    elseif n.array[2] == 3 and #n.array == 2 then
        --ee1.234e56789
        local mantissa = 10^(n.array[1]-math.floor(n.array[1]))
        mantissa = math.floor(mantissa*10^places+0.5)/10^places
        local exponent = math.floor(n.array[1])
        return "ee"..mantissa.."e"..exponent
    elseif n.array[2] and #n.array == 2 and n.array[2] <= 8 then
        --eeeeeeee56789
        local exponent = math.floor(n.array[1])
        return string.rep("e", n.array[2])..exponent
    elseif #n.array < 8 then
        --e12#34#56#78
        local r = "e"..e_ify(math.floor(n.array[1]*10^places+0.5)/10^places).."#"..n.array[2]
        for i = 3, #n.array do
            r = r.."#"..(n.array[i]+1)
        end
        return r
    else
        --e12#34##5678
        return "e"..e_ify(math.floor(n.array[1]*10^places+0.5)/10^places).."#"..n.array[#n.array].."##"..(#n.array-2)
    end
end

return BalaNotation
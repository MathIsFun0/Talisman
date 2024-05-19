local lovely = require("lovely")
local nativefs = require("nativefs")
BaseStandardNotation = nativefs.load(lovely.mod_dir.."/Talisman/big-num/notations/basestandardnotation.lua")()

StandardNotation = {}
StandardNotation.__index = StandardNotation
StandardNotation.__tostring = function (notation)
    return "StandardNotation"
end
setmetatable(StandardNotation, BaseStandardNotation)

function StandardNotation:new(opt)
    opt = opt or {}
    return setmetatable({
        start = {"", "K", "M", "B", "T"},
        ones = {"", "U", "D", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No"},
        tens = {"", "Dc", "Vg", "Tg", "Qag", "Qig", "Sxg", "Spg", "Ocg", "Nog"},
        hundreds = {"", "C", "DC", "TC", "QaC", "QiC", "SxC", "SpC", "OC", "NoC"},
        dynamic = opt.dynamic,
        reversed = opt.reversed
    }, StandardNotation)
end

return StandardNotation
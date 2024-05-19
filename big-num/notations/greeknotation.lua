local lovely = require("lovely")
local nativefs = require("nativefs")
BaseLetterNotation = nativefs.load(lovely.mod_dir.."/Talisman/big-num/notations/baseletternotation.lua")()

GreekNotation = {}
GreekNotation.__index = LetterNotation
setmetatable(GreekNotation, BaseLetterNotation)
GreekNotation.__tostring = function () return "GreekNotation" end

function GreekNotation:new(opt)
    opt = opt or {}
    return setmetatable({
        letters = "~αβγδεζηθικλμνξοπρστυφχψωΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ",
        dynamic = opt.dynamic or false,
        reversed = opt.reversed or false
    }, GreekNotation)
end

return GreekNotation
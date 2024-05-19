local lovely = require("lovely")
local nativefs = require("nativefs")
BaseLetterNotation = nativefs.load(lovely.mod_dir.."/Talisman/big-num/notations/baseletternotation.lua")()

LetterNotation = {}
LetterNotation.__index = LetterNotation
setmetatable(LetterNotation, BaseLetterNotation)
LetterNotation.__tostring = function () return "LetterNotation" end

function LetterNotation:new(opt)
    opt = opt or {}
    return setmetatable({
        letters = "~abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
        dynamic = opt.dynamic or false,
        reversed = opt.reversed or false
    }, LetterNotation)
end

return LetterNotation
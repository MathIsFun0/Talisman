local lovely = require("lovely")
BaseLetterNotation = dofile(lovely.mod_dir.."/Talisman/big-num/notations/baseletternotation.lua")

HebrewNotation = {}
HebrewNotation.__index = LetterNotation
setmetatable(HebrewNotation, BaseLetterNotation)
HebrewNotation.__tostring = function () return "HebrewNotation" end

function HebrewNotation:new(opt)
    opt = opt or {}
    return setmetatable({
        letters = "~אבּבגּגדּדהוזחטיכּכךּךלמםנןסעפּפףּףצץקרשׁשׂתּת",
        dynamic = opt.dynamic or false,
        reversed = opt.reversed or false
    }, HebrewNotation)
end

return HebrewNotation
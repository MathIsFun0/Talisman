local lovely = require("lovely")
local nativefs = require("nativefs")
Notations = {
    BaseLetterNotation = nativefs.load(lovely.mod_dir.."/Talisman/big-num/notations/baseletternotation.lua")(),
    LetterNotation = nativefs.load(lovely.mod_dir.."/Talisman/big-num/notations/letternotation.lua")(),
    CyrillicNotation = nativefs.load(lovely.mod_dir.."/Talisman/big-num/notations/cyrillicnotation.lua")(),
    GreekNotation = nativefs.load(lovely.mod_dir.."/Talisman/big-num/notations/greeknotation.lua")(),
    HebrewNotation = nativefs.load(lovely.mod_dir.."/Talisman/big-num/notations/hebrewnotation.lua")(),
    ScientificNotation = nativefs.load(lovely.mod_dir.."/Talisman/big-num/notations/scientificnotation.lua")(),
    EngineeringNotation = nativefs.load(lovely.mod_dir.."/Talisman/big-num/notations/engineeringnotation.lua")(),
    BaseStandardNotation = nativefs.load(lovely.mod_dir.."/Talisman/big-num/notations/basestandardnotation.lua")(),
    StandardNotation = nativefs.load(lovely.mod_dir.."/Talisman/big-num/notations/standardnotation.lua")(),
    ThousandNotation = nativefs.load(lovely.mod_dir.."/Talisman/big-num/notations/thousandnotation.lua")(),
    DynamicNotation = nativefs.load(lovely.mod_dir.."/Talisman/big-num/notations/dynamicnotation.lua")(),
    Balatro = nativefs.load(lovely.mod_dir.."/Talisman/big-num/notations/balatro.lua")(),
}

return Notations
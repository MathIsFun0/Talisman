local lovely = require("lovely")
Notations = {
    BaseLetterNotation = dofile(lovely.mod_dir.."/Talisman/big-num/notations/baseletternotation.lua"),
    LetterNotation = dofile(lovely.mod_dir.."/Talisman/big-num/notations/letternotation.lua"),
    CyrillicNotation = dofile(lovely.mod_dir.."/Talisman/big-num/notations/cyrillicnotation.lua"),
    GreekNotation = dofile(lovely.mod_dir.."/Talisman/big-num/notations/greeknotation.lua"),
    HebrewNotation = dofile(lovely.mod_dir.."/Talisman/big-num/notations/hebrewnotation.lua"),
    ScientificNotation = dofile(lovely.mod_dir.."/Talisman/big-num/notations/scientificnotation.lua"),
    EngineeringNotation = dofile(lovely.mod_dir.."/Talisman/big-num/notations/engineeringnotation.lua"),
    BaseStandardNotation = dofile(lovely.mod_dir.."/Talisman/big-num/notations/basestandardnotation.lua"),
    StandardNotation = dofile(lovely.mod_dir.."/Talisman/big-num/notations/standardnotation.lua"),
    ThousandNotation = dofile(lovely.mod_dir.."/Talisman/big-num/notations/thousandnotation.lua"),
    DynamicNotation = dofile(lovely.mod_dir.."/Talisman/big-num/notations/dynamicnotation.lua")
}

return Notations
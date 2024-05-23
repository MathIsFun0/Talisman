--- STEAMODDED HEADER
--- MOD_NAME: Talisman
--- MOD_ID: Talisman
--- MOD_AUTHOR: [MathIsFun_]
--- MOD_DESCRIPTION: A mod that increases Balatro's score limit.
--- PREFIX: talisman
--- VERSION: 1.1.6

----------------------------------------------
------------MOD CODE -------------------------

-- This code doesn't do anything besides making Talisman appear in Steamodded and show a mod icon in v1.0.0+

if SMODS.Atlas then
  SMODS.Atlas({
    key = "modicon",
    path = "icon.png",
    px = 32,
    py = 32
  })
end

----------------------------------------------
------------MOD CODE END----------------------
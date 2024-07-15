--- STEAMODDED HEADER
--- MOD_NAME: Talisman
--- MOD_ID: Talisman
--- MOD_AUTHOR: [MathIsFun_, Mathguy24]
--- MOD_DESCRIPTION: A mod that increases Balatro's score limit.
--- PREFIX: talisman
--- VERSION: 2.0.0-alpha5

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

--[[SMODS.Joker{
  key = "test",
  name = "Joker Test",
  rarity = "cry_exotic",
  discovered = true,
  pos = {x = 9, y = 2},
  cost = 4,
  loc_txt = {
      name = "Infinitus",
      text = {
        "{C:mult,E:1}+10#2#1000#3#10{} Mult"
      }
  },
  loc_vars = function(self, info_queue, center)
    return {vars = {"#","{","}"}}
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and not context.before and not context.after then
          local mult = Big:create(10):arrow(1000,10)
          return {
              mult_mod = mult,
              colour = G.C.RED,
              message = "!"
          }
      end
  end,
}--]]

----------------------------------------------
------------MOD CODE END----------------------
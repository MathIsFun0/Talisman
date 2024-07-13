--- STEAMODDED HEADER
--- MOD_NAME: Talisman
--- MOD_ID: Talisman
--- MOD_AUTHOR: [MathIsFun_, Mathguy24]
--- MOD_DESCRIPTION: A mod that increases Balatro's score limit.
--- PREFIX: talisman
--- VERSION: 2.0.0-alpha1

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
        "{C:mult,R:1}+eeeeeee308{} Mult"
      }
  },
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and not context.before and not context.after then
          return {
              mult_mod = Big:create("eeeeeee308"),
              colour = G.C.RED,
              message = "!"
          }
      end
  end,
}--]]

----------------------------------------------
------------MOD CODE END----------------------
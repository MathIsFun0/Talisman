--- STEAMODDED HEADER
--- MOD_NAME: Talisman
--- MOD_ID: Talisman
--- MOD_AUTHOR: [MathIsFun_, Mathguy24, jenwalter666, cg-223]
--- MOD_DESCRIPTION: A mod that increases Balatro's score limit and skips scoring animations.
--- PREFIX: talisman
--- VERSION: 2.2.0c

----------------------------------------------
------------MOD CODE -------------------------

if SMODS.Atlas then
  SMODS.Atlas({
    key = "modicon",
    path = "icon.png",
    px = 32,
    py = 32
  })
end

if SMODS.Sound then
	SMODS.Sound({
		key = "xchip",
		path = "MultiplicativeChips.wav"
	})
	SMODS.Sound({
		key = "echip",
		path = "ExponentialChips.wav"
	})
	SMODS.Sound({
		key = "eechip",
		path = "TetrationalChips.wav"
	})
	SMODS.Sound({
		key = "eeechip",
		path = "PentationalChips.wav"
	})
	SMODS.Sound({
		key = "emult",
		path = "ExponentialMult.wav"
	})
	SMODS.Sound({
		key = "eemult",
		path = "TetrationalMult.wav"
	})
	SMODS.Sound({
		key = "eeemult",
		path = "PentationalMult.wav"
	})
end


if SMODS.current_mod then
  function SMODS.current_mod.load_mod_config() end
  function SMODS.current_mod.save_mod_config() end
  SMODS.current_mod.config_tab = Talisman.config_tab
  SMODS.current_mod.debug_info = {
    ["Break Infinity"] = Talisman.config_file.break_infinity
  }
  SMODS.current_mod.description_loc_vars = function()
    return { background_colour = G.C.CLEAR, text_colour = G.C.WHITE, scale = 1.2 }
  end
end
--[[SMODS.Joker{
  key = "test",
  name = "Joker Test",
  rarity = 4,
  discovered = true,
  pos = {x = 9, y = 2},
  cost = 4,
  loc_txt = {
      name = "Stat Stick",
      text = {
        "2 of {C:dark_edition,E:2,s:0.8}every scoring effect"
      }
  },
  loc_vars = function(self, info_queue, center)
    return {vars = {"#","{","}"}}
  end,
  calculate = function(self, card, context)
    if context.joker_main then
        return {
          mult_mod = 2,
          Xmult_mod = 2,
          Emult_mod = 2,
          EEmult_mod = 2,
          EEEmult_mod = 2,
          hypermult_mod = {22, 2},
          chip_mod = 2,
          Xchip_mod = 2,
          Echip_mod = 2,
          EEchip_mod = 2,
          EEEchip_mod = 2,
          hyperchip_mod = {22, 2}
        }
    end
  end,
}--]]

----------------------------------------------
------------MOD CODE END----------------------

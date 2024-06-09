local lovely = require("lovely")
local nativefs = require("nativefs")
Big = nativefs.load(lovely.mod_dir.."/Talisman/big-num/bignumber.lua")()
Notations = nativefs.load(lovely.mod_dir.."/Talisman/big-num/notations.lua")()


Talisman = {config_file = {disable_anims = false}}
if nativefs.read(lovely.mod_dir.."/Talisman/config.lua") then
    Talisman.config_file = STR_UNPACK(nativefs.read(lovely.mod_dir.."/Talisman/config.lua"))
end
if not SpectralPack then
  SpectralPack = {}
  local ct = create_tabs
  function create_tabs(args)
      if args and args.tab_h == 7.05 then
          args.tabs[#args.tabs+1] = {
              label = "Spectral Pack",
              tab_definition_function = function() return {
                  n = G.UIT.ROOT,
                  config = {
                      emboss = 0.05,
                      minh = 6,
                      r = 0.1,
                      minw = 10,
                      align = "cm",
                      padding = 0.2,
                      colour = G.C.BLACK
                  },
                  nodes = SpectralPack
              } end
          }
      end
      return ct(args)
  end
end
SpectralPack[#SpectralPack+1] = UIBox_button{ label = {"Talisman"}, button = "talismanMenu", colour = G.C.MONEY, minw = 5, minh = 0.7, scale = 0.6}
G.FUNCS.talismanMenu = function(e)
  local tabs = create_tabs({
      snap_to_nav = true,
      tabs = {
          {
              label = "Talisman",
              chosen = true,
              tab_definition_function = function()
                tal_nodes = {{n=G.UIT.R, config={align = "cm"}, nodes={
                  {n=G.UIT.O, config={object = DynaText({string = "Select features to enable:", colours = {G.C.WHITE}, shadow = true, scale = 0.4})}},
                }},create_toggle({label = "Disable Scoring Animations", ref_table = Talisman.config_file, ref_value = "disable_anims"})}
                return {
                n = G.UIT.ROOT,
                config = {
                    emboss = 0.05,
                    minh = 6,
                    r = 0.1,
                    minw = 10,
                    align = "cm",
                    padding = 0.2,
                    colour = G.C.BLACK
                },
                nodes = tal_nodes
            }
              end
          },
      }})
  G.FUNCS.overlay_menu{
          definition = create_UIBox_generic_options({
              back_func = "options",
              contents = {tabs}
          }),
      config = {offset = {x=0,y=10}}
  }
end

-- We call this after init_game_object to leave room for mods that add more poker hands
Talisman.igo = function(obj)
    for _, v in pairs(obj.hands) do
        v.mult = Big:new(v.mult)
    end
    return obj
end

local nf = number_format
function number_format(num)
    if type(num) == 'table' then
        num = Big:new(num)
        G.E_SWITCH_POINT = G.E_SWITCH_POINT or 100000000000
        if num < Big:new(G.E_SWITCH_POINT) then
            return nf(num:to_number())
        elseif num.e < G.E_SWITCH_POINT/1000 then
            return Notations.ScientificNotation.format_mantissa(num.m, 3).."e"..Notations.ThousandNotation:format(Big:new(num.e))
        elseif num.e == 10^1000 then
            return "Infinity"
        else
            return "e"..Notations.ScientificNotation:format(Big:new(num.e), 3)
        end
    else return nf(num) end
end

local mf = math.floor
function math.floor(x)
    if type(x) == 'table' then return x:floor() end
    return mf(x)
end

local l10 = math.log10
function math.log10(x)
    if type(x) == 'table' then return l10(math.min(x:to_number(),1e300)) end--x:log10() end
    return l10(x)
end

local lg = math.log
function math.log(x, y)
    if not y then y = 2.718281828459045 end
    if type(x) == 'table' then return lg(math.min(x:to_number(),1e300),y) end --x:log(y) end
    return lg(x,y)
end

-- There's too much to override here so we just fully replace this function
-- Note that any ante scaling tweaks will need to manually changed...
function get_blind_amount(ante)
    local k = Big:new(0.75)
    if not G.GAME.modifiers.scaling or G.GAME.modifiers.scaling == 1 then 
      local amounts = {
        Big:new(300),  Big:new(800), Big:new(2000),  Big:new(5000),  Big:new(11000),  Big:new(20000),   Big:new(35000),  Big:new(50000)
      }
      if ante < 1 then return Big:new(100) end
      if ante <= 8 then return amounts[ante] end
      local a, b, c, d = amounts[8],1.6,ante-8, 1 + 0.2*(ante-8)
      local amount = a*(b+(k*c)^d)^c
      amount.m = math.floor(10*amount.m)/10
      amount:normalize()
      return amount
    elseif G.GAME.modifiers.scaling == 2 then 
      local amounts = {
        Big:new(300),  Big:new(900), Big:new(2600),  Big:new(8000), Big:new(20000),  Big:new(36000),  Big:new(60000),  Big:new(100000)
        --300,  900, 2400,  7000,  18000,  32000,  56000,  90000
      }
      if ante < 1 then return Big:new(100) end
      if ante <= 8 then return amounts[ante] end
      local a, b, c, d = amounts[8],1.6,ante-8, 1 + 0.2*(ante-8)
      local amount = math.floor(a*(b+(k*c)^d)^c)
      amount.m = math.floor(10*amount.m)/10
      amount:normalize()
      return amount
    elseif G.GAME.modifiers.scaling == 3 then 
      local amounts = {
        Big:new(300),  Big:new(1000), Big:new(3200),  Big:new(9000),  Big:new(25000),  Big:new(60000),  Big:new(110000),  Big:new(200000)
        --300,  1000, 3000,  8000,  22000,  50000,  90000,  180000
      }
      if ante < 1 then return Big:new(100) end
      if ante <= 8 then return amounts[ante] end
      local a, b, c, d = amounts[8],1.6,ante-8, 1 + 0.2*(ante-8)
      local amount = math.floor(a*(b+(k*c)^d)^c)
      amount.m = math.floor(10*amount.m)/10
      amount:normalize()
      return amount
    end
  end

function check_and_set_high_score(score, amt)
  if G.GAME.round_scores[score] and Big:new(math.floor(amt)) > Big:new(G.GAME.round_scores[score].amt) then
    G.GAME.round_scores[score].amt = Big:new(math.floor(amt))
  end
  if  G.GAME.seeded  then return end
  --[[if G.PROFILES[G.SETTINGS.profile].high_scores[score] and math.floor(amt) > G.PROFILES[G.SETTINGS.profile].high_scores[score].amt then
    if G.GAME.round_scores[score] then G.GAME.round_scores[score].high_score = true end
    G.PROFILES[G.SETTINGS.profile].high_scores[score].amt = math.floor(amt)
    G:save_settings()
  end--]] --going to hold off on modifying this until proper save loading exists
end

function is_number(x)
  if type(x) == 'number' then return true end
  if getmetatable(x) == BigMeta then return true end
  return false
end

function scale_number(number, scale, max)
  scale = Big:new(scale)
  G.E_SWITCH_POINT = G.E_SWITCH_POINT or 100000000000
  if not number or not is_number(number) then return scale end
  if not max then max = 10000 end
  if Big:new(number).e == 10^1000 then
    scale = scale*math.floor(math.log(max*10, 10))/7
  end
  if Big:new(number) >= Big:new(G.E_SWITCH_POINT) then
    if (Big:new(number).e <= 999) then
      scale = scale*math.floor(math.log(max*10, 10))/math.floor(math.log(1000000*10, 10))
    else
      scale = scale*math.floor(math.log(max*10, 10))/math.floor(math.max(7,string.len(number_format(number))-1))
    end
  elseif Big:new(number) >= Big:new(max) then
    scale = scale*math.floor(math.log(max*10, 10))/math.floor(math.log(number*10, 10))
  end
  return math.min(3, scale:to_number())
end

local tsj = G.FUNCS.text_super_juice
function G.FUNCS.text_super_juice(e, _amount)
  if _amount > 2 then _amount = 2 end
  return tsj(e, _amount)
end

local max = math.max
function math.max(x, y)
  if getmetatable(x) == BigMeta or getmetatable(y) == BigMeta then
    x = Big:new(x)
    y = Big:new(y)
    if (x > y) then
      return x
    else
      return y
    end
  end
  return max(x,y)
end

local min = math.min
function math.min(x, y)
  if getmetatable(x) == BigMeta or getmetatable(y) == BigMeta then
    x = Big:new(x)
    y = Big:new(y)
    if (x < y) then
      return x
    else
      return y
    end
  end
  return min(x,y)
end

local sqrt = math.sqrt
function math.sqrt(x)
  if getmetatable(x) == BigMeta then return x:sqrt() end
  return sqrt(x)
end

--patch to remove animations
local cest = card_eval_status_text
function card_eval_status_text(a,b,c,d,e,f)
    if not Talisman.config_file.disable_anims then cest(a,b,c,d,e,f) end
end
local jc = juice_card
function juice_card(x)
    if not Talisman.config_file.disable_anims then jc(x) end
end
function tal_uht(config, vals)
    local col = G.C.GREEN
    if vals.chips and G.GAME.current_round.current_hand.chips ~= vals.chips then
        local delta = (is_number(vals.chips) and is_number(G.GAME.current_round.current_hand.chips)) and (vals.chips - G.GAME.current_round.current_hand.chips) or 0
        if Big:new(delta) < Big:new(0) then delta = number_format(delta); col = G.C.RED
        elseif Big:new(delta) > Big:new(0) then delta = '+'..number_format(delta)
        else delta = number_format(delta)
        end
        if type(vals.chips) == 'string' then delta = vals.chips end
        G.GAME.current_round.current_hand.chips = vals.chips
        G.hand_text_area.chips:update(0)
    end
    if vals.mult and G.GAME.current_round.current_hand.mult ~= vals.mult then
        local delta = (is_number(vals.mult) and is_number(G.GAME.current_round.current_hand.mult))and (vals.mult - G.GAME.current_round.current_hand.mult) or 0
        if Big:new(delta) < Big:new(0) then delta = number_format(delta); col = G.C.RED
        elseif Big:new(delta) > Big:new(0) then delta = '+'..number_format(delta)
        else delta = number_format(delta)
        end
        if type(vals.mult) == 'string' then delta = vals.mult end
        G.GAME.current_round.current_hand.mult = vals.mult
        G.hand_text_area.mult:update(0)
    end
    if vals.handname and G.GAME.current_round.current_hand.handname ~= vals.handname then
        G.GAME.current_round.current_hand.handname = vals.handname
    end
    if vals.chip_total then G.GAME.current_round.current_hand.chip_total = vals.chip_total;G.hand_text_area.chip_total.config.object:pulse(0.5) end
    if vals.level and G.GAME.current_round.current_hand.hand_level ~= ' '..localize('k_lvl')..tostring(vals.level) then
        if vals.level == '' then
            G.GAME.current_round.current_hand.hand_level = vals.level
        else
            G.GAME.current_round.current_hand.hand_level = ' '..localize('k_lvl')..tostring(vals.level)
            if type(vals.level) == 'number' then 
                G.hand_text_area.hand_level.config.colour = G.C.HAND_LEVELS[math.min(vals.level, 7)]
            else
                G.hand_text_area.hand_level.config.colour = G.C.HAND_LEVELS[1]
            end
        end
    end
    return true
end
local uht = update_hand_text
function update_hand_text(config, vals)
    if Talisman.config_file.disable_anims then
        if G.latest_uht then
          local chips = G.latest_uht.vals.chips
          local mult = G.latest_uht.vals.mult
          if not vals.chips then vals.chips = chips end
          if not vals.mult then vals.mult = mult end
        end
        G.latest_uht = {config = config, vals = vals}
    else uht(config, vals)
    end
end
local upd = Game.update
function Game:update(dt)
    upd(self, dt)
    if G.latest_uht and G.latest_uht.config and G.latest_uht.vals then
        tal_uht(G.latest_uht.config, G.latest_uht.vals)
        G.latest_uht = nil
    end
    if Talisman.dollar_update then
      G.HUD:get_UIE_by_ID('dollar_text_UI').config.object:update()
      G.HUD:recalculate()
      Talisman.dollar_update = false
    end
end

--wrap everything in calculating contexts so we can do more things with it
Talisman.calculating_joker = false
Talisman.calculating_score = false
Talisman.calculating_card = false
Talisman.dollar_update = false
local ccj = Card.calculate_joker
function Card:calculate_joker(context)
  Talisman.calculating_joker = true
  local ret = ccj(self, context)
  Talisman.calculating_joker = false
  return ret
end
local cuc = Card.use_consumable
function Card:use_consumable(x,y)
  Talisman.calculating_score = true
  local ret = cuc(self, x,y)
  Talisman.calculating_score = false
  return ret
end
local gfep = G.FUNCS.evaluate_play
G.FUNCS.evaluate_play = function(e)
  Talisman.calculating_score = true
  local ret = gfep(e)
  Talisman.calculating_score = false
  return ret
end
--[[local ec = eval_card
function eval_card()
  Talisman.calculating_card = true
  local ret = ec()
  Talisman.calculating_card = false
  return ret
end--]]
local sm = Card.start_materialize
function Card:start_materialize(a,b,c)
  if Talisman.config_file.disable_anims and (Talisman.calculating_joker or Talisman.calculating_score or Talisman.calculating_card) then return end
  return sm(self,a,b,c)
end
local sd = Card.start_dissolve
function Card:start_dissolve(a,b,c,d)
  if Talisman.config_file.disable_anims and (Talisman.calculating_joker or Talisman.calculating_score or Talisman.calculating_card) then self:remove() return end
  return sd(self,a,b,c,d)
end
local ss = Card.set_seal
function Card:set_seal(a,b,immediate)
  return ss(self,a,b,Talisman.config_file.disable_anims and (Talisman.calculating_joker or Talisman.calculating_score or Talisman.calculating_card) or immediate)
end

--Easing fixes
--Changed this to always work; it's less pretty but fine for held in hand things
local edo = ease_dollars
function ease_dollars(mod, instant)
  if Talisman.config_file.disable_anims then--and (Talisman.calculating_joker or Talisman.calculating_score or Talisman.calculating_card) then
    mod = mod or 0
    if mod < 0 then inc_career_stat('c_dollars_earned', mod) end
    G.GAME.dollars = G.GAME.dollars + mod
    Talisman.dollar_update = true
  else return edo(mod, instant) end
end

local su = G.start_up
function G:start_up()
  su(self)
  function STR_UNPACK(str)
    local chunk, err = loadstring(str)
    if chunk then
      setfenv(chunk, {Big = Big, BigMeta = BigMeta})  -- Use an empty environment to prevent access to potentially harmful functions
      local success, result = pcall(chunk)
      if success then
      return result
      else
      print("Error unpacking string: " .. result)
      return nil
      end
    else
      print("Error loading string: " .. err)
      return nil
    end
    end
end

--some debugging functions
--[[local callstep=0
function printCallerInfo()
  -- Get debug info for the caller of the function that called printCallerInfo
  local info = debug.getinfo(3, "Sl")
  callstep = callstep+1
  if info then
      print("["..callstep.."] "..(info.short_src or "???")..":"..(info.currentline or "unknown"))
  else
      print("Caller information not available")
  end
end
local emae = EventManager.add_event
function EventManager:add_event(x,y,z)
  printCallerInfo()
  return emae(self,x,y,z)
end--]]
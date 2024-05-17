local lovely = require("lovely")
Big = dofile(lovely.mod_dir.."/Talisman/big-num/bignumber.lua")
Notations = dofile(lovely.mod_dir.."/Talisman/big-num/notations.lua")

local igo = Game.init_game_object
function Game:init_game_object()
    obj = igo(self)
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
            return Notations.ThousandNotation:format(num)
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

local cashs = check_and_set_high_score
function check_and_set_high_score(score, amt)
  if type(amt) == 'table' then
    if G.GAME.round_scores[score] and Big:new(math.floor(amt)) > Big:new(G.GAME.round_scores[score].amt) then
      G.GAME.round_scores[score].amt = Big:new(math.floor(amt))
    end
    if  G.GAME.seeded  then return end
    --[[if G.PROFILES[G.SETTINGS.profile].high_scores[score] and math.floor(amt) > G.PROFILES[G.SETTINGS.profile].high_scores[score].amt then
      if G.GAME.round_scores[score] then G.GAME.round_scores[score].high_score = true end
      G.PROFILES[G.SETTINGS.profile].high_scores[score].amt = math.floor(amt)
      G:save_settings()
    end--]] --going to hold off on modifying this until proper save loading exists
  else
    return cashs(score, amt)
  end
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
    scale = scale*math.floor(math.log(max*10, 10))/10
  end
  if Big:new(number) >= Big:new(G.E_SWITCH_POINT) then
    if (Big:new(number).e <= 9999) then
      scale = scale*math.floor(math.log(max*10, 10))/math.floor(math.log(1000000*10, 10))
    else
      scale = scale*math.floor(math.log(max*10, 10))/math.floor(math.max(7,string.len(number_format(number))-1))
    end
  end
  return math.min(3, scale:to_number())
end

local tsj = G.FUNCS.text_super_juice
function G.FUNCS.text_super_juice(e, _amount)
  if _amount > 2 then _amount = 2 end
  return tsj(e, _amount)
end
local lovely = require("lovely")
local nativefs = require("nativefs")
Notation = nativefs.load(lovely.mod_dir .. "/Talisman/big-num/notations/notation.lua")()
BalaNotation = {}
BalaNotation.__index = BalaNotation
BalaNotation.__tostring = function()
	return "BalaNotation"
end
setmetatable(BalaNotation, Notation)

function BalaNotation:new()
	return setmetatable({}, BalaNotation)
end

function BalaNotation:format(n, places)
	if not self:isFinite(n) then
		return "Infinity"
	end

	local log10 = to_big(n:log10())

	if log10 < to_big(1000000) then
		return self:formatStandard(n, places)
	elseif log10 < to_big(10) ^ 1000000 then
		return self:formatENotation(n, places)
	elseif n.array and n.array[2] and #n.array == 2 and n.array[2] <= 8 then
		return self:formatMultiE(n, places)
	elseif n.array and #n.array < 8 then
		return self:formatHashNotation(n, places)
	else
		return self:formatCompressedHash(n, places)
	end
end

function BalaNotation:e_ify(num)
	if type(num) == "table" then
		num = num:to_number()
	end
	if num >= 10 ^ 6 then
		local x = string.format("%.4g", num)
		local fac = math.floor(math.log(tonumber(x), 10))
		return string.format("%.3f", x / (10 ^ fac)) .. "e" .. fac
	end
	return string
		.format(num ~= math.floor(num) and (num >= 100 and "%.0f" or num >= 10 and "%.1f" or "%.2f") or "%.0f", num)
		:reverse()
		:gsub("(%d%d%d)", "%1,")
		:gsub(",$", "")
		:reverse()
end

function BalaNotation:formatStandard(n, places)
	local mantissa, exponent

	if type(n) == "number" then
		exponent = math.floor(math.log(n.array[1], 10))
		mantissa = n.array[1] / 10 ^ exponent
		mantissa = math.floor(mantissa * 10 ^ places + 0.5) / 10 ^ places
		return mantissa .. "e" .. self:e_ify(exponent)
	elseif n.m then -- BigNum
		mantissa = math.floor(n.m * 10 ^ places + 0.5) / 10 ^ places
		exponent = n.e
	elseif n.array[2] == 1 then -- OmegaNum
		mantissa = 10 ^ (n.array[1] - math.floor(n.array[1]))
		mantissa = math.floor(mantissa * 10 ^ places + 0.5) / 10 ^ places
		exponent = math.floor(n.array[1])
	end

	return mantissa .. "e" .. self:e_ify(exponent)
end

-- Formats for E notation (e1.234e56789)
function BalaNotation:formatENotation(n, places)
	if n.m then --BigNum
		local exponent = math.floor(math.log(n.e, 10))
		local mantissa = n.e / 10 ^ exponent
		mantissa = math.floor(mantissa * 10 ^ places + 0.5) / 10 ^ places
		return "e" .. mantissa .. "e" .. self:e_ify(exponent)
	elseif n.array[2] == 2 then --OmegaNum
		local mantissa = 10 ^ (n.array[1] - math.floor(n.array[1]))
		mantissa = math.floor(mantissa * 10 ^ places + 0.5) / 10 ^ places
		local exponent = math.floor(n.array[1])
		return "e" .. mantissa .. "e" .. self:e_ify(exponent)
	else
		local exponent = math.floor(math.log(n.array[1], 10))
		local mantissa = n.array[1] / 10 ^ exponent
		mantissa = math.floor(mantissa * 10 ^ places + 0.5) / 10 ^ places
		return "e" .. mantissa .. "e" .. self:e_ify(exponent)
	end
end

-- Formats for multiple E notation (eeeeeee1.234e56789)
function BalaNotation:formatMultiE(n, places)
	local mantissa = 10 ^ (n.array[1] - math.floor(n.array[1]))
	mantissa = math.floor(mantissa * 10 ^ places + 0.5) / 10 ^ places
	local exponent = math.floor(n.array[1])

	return string.rep("e", n.array[2] - 1) .. mantissa .. "e" .. self:e_ify(exponent)
end

-- Formats for hash notation (e12#34#56#78)
function BalaNotation:formatHashNotation(n, places)
	local r = "e"
		.. self:e_ify(math.floor(n.array[1] * 10 ^ places + 0.5) / 10 ^ places)
		.. "#"
		.. self:e_ify(n.array[2])
	for i = 3, #n.array do
		r = r .. "#" .. self:e_ify(n.array[i] + 1)
	end
	return r
end

-- Formats for compressed hash notation (e12#34##5678)
function BalaNotation:formatCompressedHash(n, places)
	return "e"
		.. self:e_ify(math.floor(n.array[1] * 10 ^ places + 0.5) / 10 ^ places)
		.. "#"
		.. self:e_ify(n.array[#n.array])
		.. "##"
		.. self:e_ify(#n.array - 2)
end

-- Check if number is finite
function BalaNotation:isFinite(n)
	if not n.array then
		return true
	end

	if n.isFinite then
		return n:isFinite()
	end

	return true
end

return BalaNotation

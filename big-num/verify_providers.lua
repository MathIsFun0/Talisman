-- Running this script validates if BigNum providers implement the required interface

local BigNumProvider = require("provider")
local Big = require("bignumber")
local OmegaNum = require("omeganum")

-- check if all required methods are implemented
local function verify_provider(name, provider)
	print("Verifying " .. name .. " provider...")

	local status, result = pcall(function()
		return BigNumProvider.validate(provider)
	end)

	if status then
		print("✓ " .. name .. " implements all required methods!")
		return true
	else
		print("✗ " .. name .. " failed validation: " .. result)
		return false
	end
end

local big_provider = Big
local omega_provider = OmegaNum

local big_valid = verify_provider("Big", big_provider)
local omega_valid = verify_provider("OmegaNum", omega_provider)

local bigNumber = Big:new(10000)
local isBigNuber = BigNumProvider.isBigNum(bigNumber)
print(isBigNum)

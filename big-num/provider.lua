-- BigNumProvider
-- Serves as an interface that bignum libraries must implement to work with the notation system.
-- Each provider must implement all the required methods listed in the 'methods' table.
-- The extended_methods are optional but recommended for full functionality.
--
-- Usage:
--   1. Create a provider that implements all required methods
--   2. Validate it with BigNumProvider.validate(yourProvider)
--   3. Implement it ingame

BigNumProvider = {
	-- Required methods
	methods = {
		-- Creation/conversion
		"new", -- Create a new big number
		"parse", -- Parse from string
		"to_number", -- Convert to regular number

		-- Basic arithmetic
		"add", -- Addition
		"sub", -- Subtraction
		"mul", -- Multiplication
		"div", -- Division
		"pow", -- Power
		"log10", -- Log base 10
		"ln", -- Natural log

		-- Comparison
		"eq", -- Equals
		"lt", -- Less than
		"gt", -- Greater than
		"lte", -- Less than or equal
		"gte", -- Greater than or equal

		-- Formatting
		"to_string", -- Convert to string
	},

	-- Additional methods (nice to have but not required)
	extended_methods = {
		"floor", -- Floor function
		"ceil", -- Ceiling function
		"round", -- Round
		"mod", -- Modulo
		"tetrate", -- Tetration
		"slog", -- Super-logarithm
		"logBase", -- Log with arbitrary base
	},
}

function BigNumProvider.validate(provider)
	local missing = {}
	for _, method in ipairs(BigNumProvider.methods) do
		if not provider[method] then
			table.insert(missing, method)
		end
	end

	if #missing > 0 then
		error("BigNumProvider validation failed. Missing methods: " .. table.concat(missing, ", "))
	end

	return true
end

-- Test if a value is a big number from any provider
function BigNumProvider.isBigNum(value)
	if type(value) ~= "table" then
		return false
	end

	local mt = getmetatable(value)
	return mt and (mt.__type == "BigNumber" or mt.__type == "OmegaNumber")
end

return BigNumProvider

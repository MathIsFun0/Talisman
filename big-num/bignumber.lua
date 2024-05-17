-- class table
Big = {
    m = 0,
    e = 0
}

-- metatable
BigMeta = {}
BigMeta.__index = Big

--- Create a new Big number
--
-- numbers are stored in the form `m * 10 ^ e`
function Big:new(m, e)
    if type(m) == "table" then
        return setmetatable({m = m.m, e = m.e}, BigMeta):normalized()
    end
    if e == nil then e = 0 end

    if type(m) == "string" then
        return Big.parse(m)
    end

    return setmetatable({m = m, e = e}, BigMeta):normalized()
end

function Big:normalize()
    if self.m == 0 then
        self.e = 0
    else
        local n_log = math.floor(math.log(math.abs(self.m), 10))
        self.m = self.m / 10 ^ n_log
        self.e = self.e + n_log
        self.e = math.floor(self.e)
    end
end

function Big:normalized()
    if (tostring(self.e) == "nan" or tostring(self.e) == "inf") then
        self.m = 0/0
        self.e = 10^1000
        return self
    end
    self:normalize()
    return self
end

function Big:add(b)
    if type(b) == "number" then b = Big:new(b) end
    local delta = b.e - self.e

    if delta > 14 then return b end
    if delta < -14 then return self end

    return Big:new(self.m + b.m * 10 ^ delta, self.e):normalized()
end

function BigMeta.__add(b1, b2)
    if type(b1) == "number" then return Big:new(b1) + b2 end
    return b1:add(b2)
end

function Big:sub(b)
    if type(b) == "number" then b = Big:new(b) end
    local nb = Big:new(b.m * -1, b.e) --negate b
    return self:add(nb)
end

function BigMeta.__sub(b1, b2)
    if type(b1) == "number" then return Big:new(b1) - b2 end
    return b1:sub(b2)
end

function Big:mul(b)
    if type(b) == "number" then b = Big:new(b) end
    return Big:new(self.m * b.m, self.e + b.e):normalized()
end

function BigMeta.__mul(b1, b2)
    if type(b1) == "number" then return Big:new(b1) * b2 end
    return b1:mul(b2)
end

function Big:div(b)
    if type(b) == "number" then b = Big:new(b) end
    return Big:new(self.m / b.m, self.e - b.e):normalized()
end

function BigMeta.__div(b1, b2)
    if type(b1) == "number" then return Big:new(b1) / b2 end
    return b1:div(b2)
end

function Big:negate()
    return self:mul(Big:new(-1))
end

function BigMeta.__unm(b1)
    return b1:negate()
end

function Big:log10()
    -- The default value of 0 is to make Balatro happy...
    if self.e == nan and self.m == nan then return 0 end
    if self:lte(Big:new(0)) then return 0 end
    return self.e + math.log(self.m, 10)
end

function Big:log(base)
    -- The default value of 0 is to make Balatro happy...
    if self.e == nan and self.m == nan then return 0 end
    if self:lte(Big:new(0)) then return 0 end
    return self:log10() / math.log(base, 10)
end

function Big:ln()
    return self:log(math.exp(1))
end

function Big:ld()
    return self:log(2)
end

function Big:pow(pow)
    -- faster than self:eq(Big:new(0))
    if self.m == 0 and self.e == 0 then
        return Big:new(0)
    end
    local log = self:log10()
    local new_log = log * pow
    return Big:new(10 ^ (new_log % 1), math.floor(new_log)):normalized()
end

function BigMeta.__pow(b1, n)
    if type(n) == "table" then n = n:to_number() end
    if type(b1) ~= "table" then b1 = Big:new(b1) end
    return b1:pow(n)
end

function Big.exp(n)
    return Big:new(math.exp(1)):pow(n)
end

function Big:recp()
    return self:pow(-1)
end

function Big:sqrt()
    return self:pow(0.5)
end

function Big:cbrt()
    return self:pow(1 / 3)
end

function Big:round()
    if self.e > 100 then return self end
    local num = self:to_number()
    if num % 1 < 0.5 then
        return Big:new(math.floor(num))
    else
        return Big:new(math.ceil(num))
    end
end

function Big:floor()
    if self.e > 100 then return self end
    return Big:new(math.floor(self:to_number()))
end

function Big:ceil()
    if self.e > 100 then return self end
    return Big:new(math.ceil(self:to_number()))
end

function Big:floor_m(digits)
    if self.e > 100 then return self end
    return Big:new(math.floor(self.m * 10 ^ digits) / 10 ^ digits, self.e)
end

function Big:ceil_m(digits)
    if self.e > 100 then return self end
    return Big:new(math.ceil(self.m * 10 ^ digits) / 10 ^ digits, self.e)
end

function Big:sin()
    return Big:new(math.sin(self:to_number()))
end

function Big:asin()
    return Big:new(math.asin(self:to_number()))
end

function Big:cos()
    return Big:new(math.cos(self:to_number()))
end

function Big:acos()
    return Big:new(math.acos(self:to_number()))
end

function Big:tan()
    return Big:new(math.tan(self:to_number()))
end

function Big:is_positive()
    return self.m >= 0
end

function Big:is_negative()
    return self.m < 0
end

function Big:is_naneinf()
    return tostring(self.m) == "nan" and (tostring(self.e) == "nan" or tostring(self.e) == "inf")
end

function Big:compare(b)
    b = Big:new(b)
    if self.m == b.m and self.e == b.e then
        return 0
    end

    if self:is_positive() and b:is_negative() then
        return 1
    end
    if self:is_negative() and b:is_positive() then
        return -1
    end

    if self.e > b.e then return 1 end
    if self.e < b.e then return -1 end

    if self:is_positive() and self.m > b.m then return 1 end
    if self:is_positive() and self.m < b.m then return -1 end
    if self:is_negative() and self.m > b.m then return -1 end
    if self:is_negative() and self.m < b.m then return 1 end
end

function Big:gt(b)
    return self:compare(b) == 1
end

function Big:gte(b)
    return self:compare(b) >= 0
end

function Big:lt(b)
    return self:compare(b) == -1
end

function BigMeta.__lt(b1, b2)
    return b1:lt(b2)
end

function Big:lte(b)
    return self:compare(b) <= 0
end

function BigMeta.__le(b1, b2)
    if b2:is_naneinf() then
        return b1:is_naneinf()
    end
    if b1:is_naneinf() then
        return false
    end
    return b1:lte(b2)
end

function Big:gt(b)
    return self:compare(b) == 1
end

function Big:eq(b)
    return self:compare(b) == 0
end

function BigMeta.__eq(b1, b2)
    return b1:eq(b2)
end

function Big:neq(b)
    return self:compare(b) ~= 0
end

function Big:to_string()
    return self.m.."e"..self.e
end

function Big:to_number()
    return self.m * 10 ^ self.e
end

function BigMeta.__tostring(b)
    return b:to_string()
end

function Big.parse(str)
    local to_n = tonumber(str)
    if to_n ~= nil and to_n < math.huge then
        return Big:new(to_n):normalized()
    end

    local parts = {}
    for m, e in str:gmatch("(.+)e(.+)") do
        parts = {m, e}
    end
    return Big:new(tonumber(parts[1]), math.floor(tonumber(parts[2]))):normalized()
end

return Big
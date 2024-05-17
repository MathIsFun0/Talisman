# lua-big-number

A simple big number library for Lua, inspired by https://github.com/Patashu/break_infinity.js

## Features

1. floating-point precision in the range [~e-e14 - ~ee14]
2. Hard limit should be about ee308, or 10^2¹⁰²⁴
3. method names identical or very similar to https://github.com/Patashu/break_infinity.js
4. non-mutable methods -> easy chaining `Big:new(2):add(Big:new(2)):mul(Big:new(2))`
5. Operator overloading `Big:new(3) * Big:new(5) ^ 2`

## Usage

1. Add `bignumber.lua` into your project
2. `Big = dofile("/path/to/bignumber.lua")`

## Example

```lua
Big = dofile("lua-big-number/bignumber.lua")

local big1 = Big:new(100)
local big2 = Big:new(10)
local added = big1:add(big2)
print(added) -- will output 1.1e2
print(big1 * big2) -- will output 1.0e3
print(big1 + (big1 * big2 - big2) / (big1 ^ 0.4)) -- will output 2.5690442605365e2

-- comparisons
print(big1 > big2) -- true
print(big1 == big2) -- false

-- You can define a shorthand for Big:new()
local N = function(n) return Big:new(n) end

print(N(2) ^ 4096 / N("4.3e401")) -- 2.4288113521237e831
```
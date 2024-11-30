--OmegaNum port by Mathguy
Big = {
    array = {},
    sign = 1
}

maxArrow = 1e3

OmegaMeta = {}
OmegaMeta.__index = Big

external = true

omegaNumError = "[OmegaNumError] "
invalidArgument = omegaNumError .. "Invalid argument: "

isOmegaNum = "/^[-\\+]*(Infinity|NaN|(10(\\^+|\\{[1-9]\\d*\\})|\\(10(\\^+|\\{[1-9]\\d*\\})\\)\\^[1-9]\\d* )*((\\d+(\\.\\d*)?|\\d*\\.\\d+)?([Ee][-\\+]*))*(0|\\d+(\\.\\d*)?|\\d*\\.\\d+))$/"

MAX_SAFE_INTEGER = 9007199254740991
MAX_E = math.log(MAX_SAFE_INTEGER, 10)
LONG_STRING_MIN_LENGTH = 17

R = {}

R.ZERO = 0
R.ONE = 1
R.E = math.exp(1)
R.LN2 = math.log(2, R.E)
R.LN10 = math.log(10, R.E)
R.LOG2E = math.log(R.E, 2)
R.LOG10E = math.log(R.E, 0)
R.PI = math.pi
R.SQRT1_2 = math.sqrt(0.5)
R.SQRT2 = math.sqrt(2)
R.MAX_SAFE_INTEGER=MAX_SAFE_INTEGER
R.MIN_SAFE_INTEGER=-9007199254740992
R.MAX_DISP_INTEGER=1000000
R.NaN=0/0
R.NEGATIVE_INFINITY = -1/0
R.POSITIVE_INFINITY = 1/0
R.E_MAX_SAFE_INTEGER="e"..tostring(R.MAX_SAFE_INTEGER)
R.EE_MAX_SAFE_INTEGER="ee"..tostring(R.MAX_SAFE_INTEGER)
R.TETRATED_MAX_SAFE_INTEGER="10^^"..tostring(R.MAX_SAFE_INTEGER)

--------------make the numbers look good----------------------
function thousands_format(number)
    return string.format("%.2f", number)
end

function AThousandNotation(n, places)
    local raw = string.format("%." .. places .."f", n)
    local result = ""
    local comma = string.find(raw, "%.")

    if comma == nil then
        comma = #raw
    else
        comma = comma - 1
    end

    for i = 1, #raw do
        result = result .. string.sub(raw, i, i)
        if (comma - i) % 3 == 0 and i < comma then
            result = result .. ","
        end
    end
    return result
end

------------------------------------------------------

function Big:new(arr)
    return setmetatable({array = arr, sign = 1}, OmegaMeta):normalize()
end

function Big:isNaN()
    return self.array[1] ~= self.array[1]
end

function Big:isInfinite()
    return (self.array[1] == R.POSITIVE_INFINITY) or (self.array[1] == R.NEGATIVE_INFINITY)
end

function Big:isFinite()
    return (not self:isInfinite() and not self:isNaN())
end

function Big:isint()
    if (self.sign==-1) then
        return self:abs():isint()
    end
    if (self:gt(R.MAX_SAFE_INTEGER)) then
        return true;
    end
    local num = self:to_number()
    return (math.floor(num) == num);
end

function Big:compareTo(other)
    other = Big:create(other)
    if ((self.array[1] ~= self.array[1]) or (other.array[1] ~= other.array[1])) then
        return R.NaN;
    end
    if ((self.array[1]==R.POSITIVE_INFINITY) and (other.array[1]~=R.POSITIVE_INFINITY)) then
        return self.sign
    end
    if ((self.array[1]~=R.POSITIVE_INFINITY) and (other.array[1]==R.POSITIVE_INFINITY)) then
        return other.sign
    end
    if ((#self.array==1) and (self.array[1]==0) and (#other.array==1) and (other.array[1]==0)) then
        return 0
    end
    if (self.sign~=other.sign) then
        return self.sign    
    end
    local m = self.sign;
    local r = nil;
    if (#self.array>#other.array) then
        r = 1;
    elseif (#self.array<#other.array) then
        r = -1;
    else
        for i=#self.array,1,-1 do
            if (self.array[i]>other.array[i]) then
                r = 1;
                break;
            elseif (self.array[i]<other.array[i]) then
                r = -1
                break
            end
            r = r or 0;
        end
    end
    return r * m;
end

function Big:lt(other)
    return self:compareTo(other) < 0
end

function Big:gt(other)
    return self:compareTo(other) > 0
end

function Big:lte(other)
    return self:compareTo(other) <= 0
end

function Big:gte(other)
    return self:compareTo(other) >= 0
end

function Big:eq(other)
    return self:compareTo(other) == 0
end

function Big:neg()
    local x = self:clone();
    x.sign = x.sign * -1;
    return x;
end

function Big:abs()
    local x = self:clone();
    x.sign = 1;
    return x;
end

function Big:min(other)
    if (self:lt(other)) then
        return self:clone()
    else
        return Big:create(other)
    end
end

function Big:max(other)
    if (self:gt(other)) then
        return self:clone()
    else
        return Big:create(other)
    end
end

function Big:normalize()
    local b = nil
    local x = self
    if ((x.array == nil) or (type(x.array) ~= "table") or (#x.array == 0)) then
        x.array = {0}
    end
    if (#x.array == 1) and (x.array[1] == 0) then
        x.sign = 1
        return x
    end
    if (#x.array == 1) and (x.array[1] < 0) then
        x.sign = -1
        x.array[1] = -x.array[1]
    end
    if ((x.sign~=1) and (x.sign~=-1)) then
    --   if (typeof x.sign!="number") x.sign=Number(x.sign);
        if (x.sign < 0) then
            x.sign = -1;
        else
            x.sign = 1;
        end
    end
    local l = 0
    for i ,j in pairs(x.array) do
        if i > l then
                l = i
        end
    end
    for i=1,l do
        local e = x.array[i];
        if ((e == nil)) then
            x.array[i] = 0
            e = 0
        end
        if (e ~= e) then
            x.array={R.NaN};
            return x;
        end
        if (e == R.POSITIVE_INFINITY) or (e == R.NEGATIVE_INFINITY) then
            x.array = {R.POSITIVE_INFINITY};
            return x;
        end
        if (i ~= 1) then
            x.array[i]=math.floor(e)
        end
    end
    local doOnce = true
    while (doOnce or b) do
    --   if (OmegaNum.debug>=OmegaNum.ALL) console.log(x.toString());
        b=false;
        while ((#x.array ~= 0) and (x.array[#x.array]==0)) do
            x.array[#x.array] = nil;
            b=true;
        end
        if (x.array[1] > R.MAX_DISP_INTEGER) then --modified, should make printed values easier to display
            x.array[2]=(x.array[2] or 0) + 1;
            x.array[1]= math.log(x.array[1], 10);
            b=true;
        end
        while ((x.array[1] < math.log(R.MAX_DISP_INTEGER,10)) and ((x.array[2] ~= nil) and (x.array[2] ~= 0))) do
            x.array[1] = math.pow(10,x.array[1], 10);
            x.array[2] = x.array[2] - 1
            b=true;
        end
        -- if ((#x.array>2) and ((x.array[2] == nil) or (x.array[2] == 0))) then
        --     local i = 3
        --     while (x.array[i] == nil) or (x.array[i] == 0) do
        --         i = i + 1
        --     end
        --     x.array[i-1]=x.array[1];
        --     x.array[1]=1;
        --     x.array[i] = x.array[i] - 1
        --     b=true;
        -- end
        doOnce = false;
        l = #x.array
        for i=1,l do
            if (x.array[i]>R.MAX_SAFE_INTEGER) then
                x.array[i+1]=(x.array[i+1] or 0)+1;
                x.array[1]=x.array[i]+1;
                for j=2,i do
                    x.array[j]=0;
                end
                b=true;
            end
        end
    end
    if (#x.array == 0) then 
        x.array = {0}
    end
    return x;
end

function Big:toString()
    if (self.sign==-1) then 
        return "-" .. self:abs():toString()
    end
    if (self.array[1] ~= self.array[1]) then
        return "NaN" 
    end
    -- if (!isFinite(this.array[0])) return "Infinity";
    local s = "";
    if (#self.array>=2) then
        for i=#self.array,3,-1 do
            local q = nil
            if (i >= 6) then
                q = "{"..(i-1).."}"
            else
                q = string.rep("^", i-1)
            end
            if (self.array[i]>1) then
                s = s .."(10" .. q .. ")^" .. AThousandNotation(self.array[i], 0) .. " "
            elseif (self.array[i]==1) then
                s= s .."10" .. q;
            end
        end
    end
    if (self.array[2] == nil) or (self.array[2] == 0) then
        if (self.array[1] <= 9e9) then
            s = s .. AThousandNotation(self.array[1], 2)
        else
            local exponent = math.floor(math.log(self.array[1], 10))
            local mantissa = math.floor((self.array[1] / (10^exponent))*100)/100
            s = s .. AThousandNotation(mantissa, 2) .. "e" .. AThousandNotation(exponent, 0)
        end
    elseif (self.array[2]<3) then
        s = s .. string.rep("e", self.array[2]-1) .. AThousandNotation(math.pow(10,self.array[1]-math.floor(self.array[1])), 2) .. "e" .. AThousandNotation(math.floor(self.array[1]), 0);
    elseif (self.array[2]<8) then
        s = s .. string.rep("e", self.array[2]) .. AThousandNotation(self.array[1], 0)
    else 
        s = s .. "(10^)^" .. AThousandNotation(self.array[2], 0) .. " " .. AThousandNotation(self.array[1],0)
    end
    return s
end

function log10LongString(str) 
    return math.log(tonumber(string.sub(str, 1, LONG_STRING_MIN_LENGTH)), 10)+(string.len(str)- LONG_STRING_MIN_LENGTH);
end

function Big:parse(input)   
    -- if (typeof input!="string") throw Error(invalidArgument+"Expected String");
    -- var isJSON=false;
    -- if (typeof input=="string"&&(input[0]=="["||input[0]=="{")){
    --   try {
    --     JSON.parse(input);
    --   }finally{
    --     isJSON=true;
    --   }
    -- }
    -- if (isJSON){
    --   return OmegaNum.fromJSON(input);
    -- }
    local x = Big:new({0})
    -- if (!isOmegaNum.test(input)){
    --   console.warn(omegaNumError+"Malformed input: "+input);
    --   x.array=[NaN];
    --   return x;
    -- }
    local negateIt = false
    while ((string.sub(input, 1, 1)=="-") or (string.sub(input, 1, 1)=="+")) do
        if (string.sub(input, 1, 1)=="-") then
            negateIt = not negateIt
        end
        input = string.sub(input, 2);
    end
    if (input=="NaN") or (input=="nan") then
        x.array = {R.NaN}
    elseif (input=="Infinity") or (input=="inf") then
        x.array = {R.POSITIVE_INFINITY}
    else
        local a = 0
        local b = 0
        local c = 0
        local d = 0
        local i = 0
        while (string.len(input) > 0) do
            local passTest = false
            if true then
                local j = 1
                if string.sub(input, 1, 1) == "(" then
                    j = j + 1
                end
                if (string.sub(input, j, j+1) == "10") and ((string.sub(input, j+2, j+2) == "^") or (string.sub(input, j+2, j+2) == "{")) then
                    passTest = true
                end
            end
            if (passTest) then
                if (string.sub(input, 1, 1) == "(") then
                input = string.sub(input, 2);
                end
                local arrows = -1;
                if (string.sub(input, 3, 3)=="^") then
                    arrows = 3
                    while (string.sub(input, arrows, arrows) == "^") do
                        arrows = arrows + 1
                    end
                    arrows = arrows - 3
                    a = arrows
                    b = arrows + 2;
                else
                    a = 1
                    while (string.sub(input, a, a) ~= "}") do
                        a = a + 1
                    end
                    arrows=tonumber(string.sub(input, 4, a - 1))+1;
                    b = a + 1
                end
                --[[if (arrows >= maxArrow) then
                -- console.warn("Number too large to reasonably handle it: tried to "+arrows.add(2)+"-ate.");
                    x.array = {R.POSITIVE_INFINITY};
                    break;
                end--]]
                input = string.sub(input, b + 1);
                if (string.sub(input, 1, 1) == ")") then
                    a = 1
                    while (string.sub(input, a, a) ~= " ") do
                        a = a + 1
                    end
                    c = tonumber(string.sub(input, 3, a - 1));
                    input = string.sub(input, a+1);
                else
                    c = 1
                end
                if (arrows==1) then
                    x.array[2] = (x.array[2] or 0) + c;
                elseif (arrows==2) then
                    a = x.array[2] or 0;
                    b = x.array[1] or 0;
                    if (b>=1e10) then
                        a = a + 1
                    end
                    if (b>=10) then
                        a = a + 1
                    end
                    x.array[1]=a;
                    x.array[2]=0;
                    x.array[3]=(x.array[3] or 0)+c;
                else
                    a=x.array[arrows] or 0;
                    b=x.array[arrows-1] or 0;
                    if (b>=10) then
                        a = a + 1
                    end
                    for i=1, arrows do
                        x.array[i] = 0;
                    end
                    x.array[1]=a;
                    x.array[arrows+1] = (x.array[arrows+1] or 0) + c;
                end
            else
                break
            end
        end
        a = {""}
        while (string.len(input) > 0) do
            if ((string.sub(input, 1, 1) == "e") or (string.sub(input, 1, 1) == "E")) then
                a[#a + 1] = ""
            else
                a[#a] = a[#a] .. string.sub(input, 1, 1)
            end
            input = string.sub(input, 2);
        end
        if a[#a] == "" then
            a[#a] = nil
        end
        b={x.array[1],0};
        c=1;
        for i=#a, 1, -1 do
            if ((b[1] < MAX_E) and (b[2]==0)) then
                b[1] = math.pow(10,c*b[1]);
            elseif (c==-1) then
                if (b[2]==0) then
                    b[1]=math.pow(10,c*b[1]);
                elseif ((b[2]==1) and (b[1]<=308)) then
                    b[1] = math.pow(10,c*math.pow(10,b[1]));
                else
                    b[1]=0;
                end
                b[2]=0;
            else
                b[2] = b[2] + 1;
            end
            local decimalPointPos = 1;
            while ((string.sub(a[i], decimalPointPos, decimalPointPos) ~= ".") and (decimalPointPos <= #a[i])) do
                decimalPointPos = decimalPointPos + 1
            end 
            if decimalPointPos == #a[i] + 1 then
                decimalPointPos = -1
            end
            local intPartLen = -1
            if (decimalPointPos == -1) then
                intPartLen = #a[i] + 1
            else
                intPartLen = decimalPointPos
            end
            if (b[2] == 0) then
                if (intPartLen - 1 >= LONG_STRING_MIN_LENGTH) then
                    b[1] = math.log10(b[1]) + log10LongString(string.sub(a[i], 1, intPartLen - 1))
                    b[2] = 1;
                elseif ((a[i] ~= nil) and (a[i] ~= "")) then
                    b[1] = b[1] * tonumber(a[i]);
                end
            else
                d=-1
                if (intPartLen - 1 >= LONG_STRING_MIN_LENGTH) then
                    d = log10LongString(string.sub(a[i], 1,intPartLen - 1))
                else
                    if (a[i] ~= nil) and (a[i] ~= "") and (tonumber(a[i]) ~= nil) then
                        d = math.log(tonumber(a[i]), 10)
                    else
                        d = 0
                    end
                end
                if (b[2]==1) then
                    b[1] = b[1] + d;
                elseif ((b[2]==2) and (b[1]<MAX_E+math.log(d, 10))) then
                    b[1] = b[1] + math.log(1+math.pow(10,Math.log10(d)-b[0]), 10);
                end
            end
            if ((b[1]<MAX_E) and (b[2] ~= 0) and (b[2] ~= nil)) then
                b[1]=math.pow(10,b[1]);
                b[2] = b[2] - 1;
            elseif (b[1]>MAX_SAFE_INTEGER) then
                b[1] = math.log(b[1], 10);
                b[2] = b[2] + 1;
            end
        end
        x.array[1]= b[1];
        x.array[2]= (x.array[2] or 0) + b[2];
    end
    if (negateIt) then
        x.sign = x.sign * -1
    end
    x:normalize();
    return x;
end

function Big:to_number()
    -- //console.log(this.array);
    if (self.sign==-1) then
        return -1*(self:neg():to_number());
    end
    if ((#self.array>=2) and ((self.array[2]>=2) or (self.array[2]==1) and (self.array[1]>308))) then
        return R.POSITIVE_INFINITY;
    end
    if (#self.array >= 3) and ((self.array[1] >= 3) or (self.array[2] >= 1) or (self.array[3] >= 1)) then
        return R.POSITIVE_INFINITY;
    end
    if (#self.array >= 4) and ((self.array[1] > 1) or (self.array[2] >= 1) or (self.array[3] >= 1)) then
        for i = 4, #self.array do
            if self.array[i] > 0 then
                return R.POSITIVE_INFINITY;
            end
        end
    end
    if (type(self.array[1]) == "table") then
        self.array[1] = self.array[1]:to_number()
    end
    if (self.array[2]==1) then
        return math.pow(10,self.array[1]);
    end
    return self.array[1];
end

function Big:floor()
    if (self:isint()) then
        return self:clone()
    end
    return Big:create(math.floor(self:to_number()));
end

function Big:ceil()
    if (self:isint()) then
        return self:clone()
    end
    return Big:create(math.ceil(self:to_number()));
end

function Big:clone()
    local newArr = {}
    for i, j in ipairs(self.array) do
        newArr[i] = j
    end
    local result = Big:new(newArr)
    result.sign = self.sign
    return result
end

function Big:create(input)
    if ((type(input) == "number")) then
        return Big:new({input})
    elseif ((type(input) == "string")) then
        return Big:parse(input)
    elseif ((type(input) == "table") and getmetatable(input) == OmegaMeta) then
        return input:clone()
    else
        return Big:new(input)
    end
end

function Big:add(other)
    local x = self:clone()
    other = Big:create(other)
    -- if (OmegaNum.debug>=OmegaNum.NORMAL){
    --   console.log(this+"+"+other);
    --   if (!debugMessageSent) console.warn(omegaNumError+"Debug output via 'debug' is being deprecated and will be removed in the future!"),debugMessageSent=true;
    -- }
    if (x.sign==-1) then
        return x:neg():add(other:neg()):neg()
    end
    if (other.sign==-1) then
        return x:sub(other:neg());
    end
    if (x:eq(R.ZERO)) then
        return other;
    end
    if (other:eq(R.ZERO)) then
        return x;
    end
    if (x:isNaN() or other:isNaN() or (x:isInfinite() and other:isInfinite() and x:eq(other:neg()))) then
        return Big:create(R.NaN);
    end
    if (x:isInfinite()) then
        return x;
    end
    if (other:isInfinite()) then
        return other;
    end
    local p=x:min(other);
    local q=x:max(other);
    local t = -1;
    if (p.array[2] == 2) and not p:gt(R.E_MAX_SAFE_INTEGER) then
        p.array[2] = 1
        p.array[1] = 10 ^ p.array[1]
    end
    if (q.array[2] == 2) and not q:gt(R.E_MAX_SAFE_INTEGER) then
        q.array[2] = 1
        q.array[1] = 10 ^ q.array[1]
    end
    if (q:gt(R.E_MAX_SAFE_INTEGER) or q:div(p):gt(R.MAX_SAFE_INTEGER)) then
        t = q;
    elseif (q.array[2] == nil) or (q.array[2] == 0) then
        t= Big:create(x:to_number()+other:to_number());
    elseif (q.array[2]==1) then
        if (p.array[2] ~= nil) and (p.array[2] ~= 0) then
            a = p.array[1]
        else
            a = math.log(p.array[1], 10)
        end
        t = Big:new({a+math.log(math.pow(10,q.array[1]-a)+1, 10),1});
    end
    p = nil
    q = nil
    return t;
end

function Big:sub(other)
    local x = self:clone()
    other = Big:create(other)
    -- if (OmegaNum.debug>=OmegaNum.NORMAL) console.log(x+"-"+other);
    if (x.sign==-1) then
        return x:neg():sub(other:neg()):neg()
    end
    if (other.sign==-1) then
        return x:add(other:neg())
    end
    if (x:eq(other)) then
        return Big:create(R.ZERO)
    end
    if (other:eq(R.ZERO)) then
        return x;
    end
    if (x:isNaN() or other:isNaN() or (x:isInfinite() and other:isInfinite() and x:eq(other:neg()))) then
        return Big:create(R.NaN)
    end
    if (x:isInfinite()) then
        return x
    end
    if (other:isInfinite()) then
        return other:neg()
    end
    local p = x:min(other);
    local q = x:max(other);
    local n = other:gt(x);
    local t = -1;
    if (p.array[2] == 2) and not p:gt(R.E_MAX_SAFE_INTEGER) then
        p.array[2] = 1
        p.array[1] = 10 ^ p.array[1]
    end
    if (q.array[2] == 2) and not q:gt(R.E_MAX_SAFE_INTEGER) then
        q.array[2] = 1
        q.array[1] = 10 ^ q.array[1]
    end
    if (q:gt(R.E_MAX_SAFE_INTEGER) or q:div(p):gt(R.MAX_SAFE_INTEGER)) then
        t = q;
        if n then
            t = t:neg()
        else
            t = t
        end
    elseif (q.array[2] == nil) or (q.array[2] == 0) then
        t = Big:create(x:to_number()-other:to_number());
    elseif (q.array[2]==1) then
        if (p.array[2] ~= nil) and (p.array[2] ~= 0) then
            a = p.array[1]
        else
            a = math.log(p.array[1], 10)
        end
        
        t = Big:new({a+math.log(math.pow(10,q.array[1]-a)-1, 10),1});
        if n then
            t = t:neg()
        else
            t = t
        end
    end
    p = nil
    q = nil
    return t;
end

function Big:div(other)
    local x = self:clone();
    other = Big:create(other);
    -- if (OmegaNum.debug>=OmegaNum.NORMAL) then
    --     console.log(x+"/"+other);
    if (x.sign*other.sign==-1) then
        return x:abs():div(other:abs()):neg()
    end
    if (x.sign==-1) then
        return x:abs():div(other:abs())
    end
    if (x:isNaN() or other:isNaN() or (x:isInfinite() and other:isInfinite() and x:eq(other:neg()))) then
        return Big:create(R.NaN)
    end
    if (other:eq(R.ZERO)) then
        Big:create(R.POSITIVE_INFINITY)
    end
    if (other:eq(R.ONE)) then
        return x:clone()
    end
    if (x:eq(other)) then
        return Big:create(R.ONE)
    end
    if (x:isInfinite()) then
        return x
    end
    if (other:isInfinite()) then
        return Big:create(R.ZERO)
    end
    if (x:max(other):gt(R.EE_MAX_SAFE_INTEGER)) then
        if x:gt(other) then
            return x:clone()
        else
            return Big:create(R.ZERO)
        end
    end
    local n = x:to_number()/other:to_number();
    if (n<=MAX_SAFE_INTEGER) then
        return Big:create(n)
    end
    local pw = Big:create(10):pow(x:log10():sub(other:log10()))
    local fp = pw:floor()
    if (pw:sub(fp):lt(Big:create(1e-9))) then
        return fp
    end
    return pw
end

function Big:mul(other)
    local x = self:clone();
    other = Big:create(other);
    -- if (OmegaNum.debug>=OmegaNum.NORMAL) console.log(x+"*"+other);
    if (x.sign*other.sign==-1) then
        return x:abs():mul(other:abs()):neg()
    end
    if (x.sign==-1) then
        return x:abs():mul(other:abs())
    end
    if (x:isNaN() or other:isNaN() or (x:isInfinite() and other:isInfinite() and x:eq(other:neg()))) then
        return Big:create(R.NaN)
    end
    if (other:eq(R.ZERO)) then
        return Big:create(R.ZERO)
    end
    if (other:eq(R.ONE)) then
        return x:clone()
    end
    if (x:isInfinite()) then
        return x
    end
    if (other:isInfinite()) then
        return other
    end
    if (x:max(other):gt(R.EE_MAX_SAFE_INTEGER)) then
        return x:max(other)
    end
    local n = x:to_number()*other:to_number()
    if (n<=MAX_SAFE_INTEGER) then
        return Big:create(n)
    end
    return Big:create(10):pow(x:log10():add(other:log10()));
end

function Big:rec()
    if (self:isNaN() or self:eq(R.ZERO)) then
        return Big:create(R.NaN)
    end
    if (self:abs():gt("2e323")) then
        return Big:create(R.ZERO)
    end
    return Big:create(R.ONE):div(self)
end

function Big:logBase(base)
    if base == nil then
        base = Big:create(R.E)
    end
    return self:log10():div(base:log10())
end

function Big:log10()
    local x = self:clone();
    -- if (OmegaNum.debug>=OmegaNum.NORMAL) console.log("log"+this);
    if (x:lt(R.ZERO)) then
        return Big:create(R.NaN)
    end
    if (x:eq(R.ZERO)) then
        return Big:create(R.NEGATIVE_INFINITY)
    end
    if (x:lte(R.MAX_SAFE_INTEGER)) then 
        return Big:create(math.log(x:to_number(), 10))
    end
    if (not x:isFinite()) then
        return x;
    end
    if (x:gt(R.TETRATED_MAX_SAFE_INTEGER)) then
        return x;
    end
    x.array[2] = x.array[2] - 1;
    return x:normalize()
end

function Big:ln()
    base = Big:create(R.E)
    return self:log10():div(base:log10())
end

function Big:pow(other)
    other = Big:create(other);
    -- if (OmegaNum.debug>=OmegaNum.NORMAL) console.log(this+"^"+other);
    if (other:eq(R.ZERO)) then
        return Big:create(R.ONE)
    end
    if (other:eq(R.ONE)) then
        return self:clone()
    end
    if (other:lt(R.ZERO)) then
        return self:pow(other:neg()):rec()
    end
    if (self:lt(R.ZERO) and other:isint()) then
        if (other:mod(2):lt(R.ONE)) then
            return self:abs():pow(other)
        end
        return self:abs():pow(other):neg()
    end
    if (self:lt(R.ZERO)) then
        return Big:create(R.NaN)
    end
    if (self:eq(R.ONE)) then
        return Big:create(R.ONE)
    end
    if (self:eq(R.ZERO)) then
        return Big:create(R.ZERO)
    end
    if (self:max(other):gt(R.TETRATED_MAX_SAFE_INTEGER)) then
        return self:max(other);
    end
    if (self:eq(10)) then
        if (other:gt(R.ZERO)) then
            other.array[2] = (other.array[2] or 0) + 1;
            other:normalize();
            return other;
        else
            return Big:create(math.pow(10,other:to_number()));
        end
    end
    if (other:lt(R.ONE)) then
        return self:root(other:rec())
    end
    local n = math.pow(self:to_number(),other:to_number())
    if (n<=MAX_SAFE_INTEGER) then
        return Big:create(n);
    end
    return Big:create(10):pow(self:log10():mul(other));
end

function Big:exp()
    return Big:create(R.E, self)
end

function Big:root(other)
    other = Big:create(other)
    -- if (OmegaNum.debug>=OmegaNum.NORMAL) console.log(this+"root"+other);
    if (other:eq(R.ONE)) then
        return self:clone()
    end
    if (other:lt(R.ZERO)) then
        return self:root(other:neg()):rec()
    end
    if (other:lt(R.ONE)) then
        return self:pow(other:rec())
    end
    if (self:lt(R.ZERO) and other:isint() and other:mod(2):eq(R.ONE)) then
        return self:neg():root(other):neg()
    end
    if (self:lt(R.ZERO)) then
        return Big:create(R.NaN)
    end
    if (self:eq(R.ONE)) then
        return Big:create(R.ONE)
    end
    if (self:eq(R.ZERO)) then
        return Big:create(R.ZERO)
    end
    if (self:max(other):gt(R.TETRATED_MAX_SAFE_INTEGER)) then
        if self:gt(other) then
            return self:clone()
        else
            Big:create(R.ZERO)
        end
    end
    return Big:create(10):pow(self:log10():div(other));
end

function Big:slog(base)
    if base == nil then
        base = 10
    end
    local x = Big:create(self)
    base = Big:create(base)
    if (x:isNaN() or base:isNaN() or (x:isInfinite() and base:isInfinite())) then
        return Big:create(R.NaN)
    end
    if (x:isInfinite()) then
        return x;
    end
    if (base:isInfinite()) then
        return Big:create(R.ZERO)
    end
    if (x:lt(R.ZERO)) then
        return Big:create(-R.ONE)
    end
    if (x:lt(R.ONE)) then
        return Big:create(R.ZERO)
    end
    if (x:eq(base)) then
        return Big:create(R.ONE)
    end
    if (base:lt(math.exp(1/R.E))) then
        local a = base:tetrate(1/0)
        if (x:eq(a)) then
            return Big:create(R.POSITIVE_INFINITY)
        end
        if (x:gt(a)) then
            return Big:create(R.NaN)
        end
    end
    if (x:max(base):gt("10^^^" .. R.MAX_SAFE_INTEGER)) then
        if (x:gt(base)) then
            return x;
        end
        return Big:create(R.ZERO)
    end
    if (x:max(base):gt(R.TETRATED_MAX_SAFE_INTEGER)) then
        if x:gt(base) then
            x.array[3] = x.array[3] - 1
            x:normalize()
            return x:sub(x.array[2])
        end
        return Big:create(R.ZERO)
    end
    local r = 0
    local t = (x.array[2] or 0) - (base.array[2] or 0)
    if (t > 3) then
        local l = t - 3
        r = r + l
        x.array[2] = x.array[2] - l
    end
    for i = 0, 99 do
        if x:lt(R.ZERO) then
            x = base:pow(x)
            r = r - 1
        elseif (x:lte(R.ONE)) then
            return Big:create(r + x:to_number() - 1)
        else
            r = r + 1
            x = x:logBase(base)
        end
    end
    if (x:gt(10)) then
        return Big:create(r)
    end
end

function Big:tetrate(other)
    local t = self:clone()
    other = Big:create(other)
    local negln = nil
    if (t:isNaN() or other:isNaN()) then
        return Big:create(R.NaN)
    end
    if (other:isInfinite() and other.sign > 0) then
        negln = t:ln():neg()
        return negln:lambertw():div(negln)
    end
    if (other:lte(-2)) then
        return Big:create(R.NaN)
    end
    if (t:eq(R.ZERO)) then
        if (other:eq(R.ZERO)) then
            return Big:create(R.NaN)
        end
        if (other:mod(2):eq(R.ZERO)) then
            return Big:create(R.ZERO)
        end
        return Big:create(R.ONE)
    end
    if (t:eq(R.ONE)) then
        if (other:eq(-1)) then
            return Big:create(R.NaN)
        end
        return Big:create(R.ONE)
    end
    if (other:eq(-1)) then
        return Big:create(R.ZERO)
    end
    if other:eq(R.ZERO) then
        return Big:create(R.ONE)
    end
    if other:eq(R.ONE) then
        return t
    end
    if other:eq(2) then
        return t:pow(t)
    end
    if t:eq(2) then
        if other:eq(3) then
            return Big:create({16})
        end
        if other:eq(4) then
            return Big:create({65536})
        end
    end
    local m = t:max(other)
    if (m:gt(Big:create("10^^^" .. tostring(R.MAX_SAFE_INTEGER)))) then
        return m
    end
    if (m:gt(R.TETRATED_MAX_SAFE_INTEGER) or other:gt(MAX_SAFE_INTEGER)) then
        if (t:lt(math.exp(1/R.E))) then
            negln = t:ln():neg()
            return negln:lambertw():div(negln)
        end
        local j = t:slog(10):add(other)
        j.array[3]=(j.array[3] or 0) + 1
        j:normalize()
        return j
    end
    local y = other:to_number()
    local f = math.floor(y)
    local r = t:pow(y-f)
    local l = Big:create(R.NaN)
    local i = 0
    local m = Big:create(R.E_MAX_SAFE_INTEGER)
    while ((f ~= 0) and r:lt(m) and (i < 100)) do
        if (f > 0) then
            r = t:pow(r)
            if (l:eq(r)) then
                f = 0
                break
            end
            l = r
            f = f - 1
        else
            r = r:logBase(t)
            if (l:eq(r)) then
                f = 0
                break
            end
            l = r
            f = f + 1
        end
    end
    if ((i == 100) or t:lt(math.exp(1/R.E))) then
        f = 0
    end
    r.array[2] = (r.array[2] or 0) + f
    r:normalize()
    return r;
end

function Big:arrow(arrows, other)
    local t = self:clone()
    arrows = Big:create(arrows)
    if (not arrows:isint() or arrows:lt(R.ZERO)) then
        return Big:create(R.NaN)
    end
    if arrows:eq(R.ZERO) then
        return t:mul(other)
    end
    if arrows:eq(R.ONE) then
        return t:pow(other)
    end
    if arrows:eq(2) then
        return t:tetrate(other)
    end
    other = Big:create(other)
    if (other:lt(R.ZERO)) then
        return Big:create(R.NaN)
    end
    if (other:eq(R.ZERO)) then
        return Big:create(R.ONE)
    end
    if (other:eq(R.ONE)) then
        return t:clone()
    end
    --[[if (arrows:gte(maxArrow)) then
        return Big:create(R.POSITIVE_INFINITY)
    end--]]
    local arrowsNum = arrows:to_number()
    if (other:eq(2)) then
        return t:arrow(arrows:sub(R.ONE), t)
    end
    if (t:max(other):gt("10{"..tostring(arrowsNum+1).."}"..tostring(R.MAX_SAFE_INTEGER))) then
        return t:max(other)
    end
    local r = nil
    if (t:gt("10{"..tostring(arrowsNum).."}"..tostring(R.MAX_SAFE_INTEGER)) or other:gt(R.MAX_SAFE_INTEGER)) then
        if (t:gt("10{"..tostring(arrowsNum).."}"..tostring(R.MAX_SAFE_INTEGER))) then
            r = t:clone()
            r.array[arrowsNum + 1] = r.array[arrowsNum + 1] - 1
            r:normalize()
        elseif (t:gt("10{"..tostring(arrowsNum - 1).."}"..tostring(R.MAX_SAFE_INTEGER))) then
            r = Big:create(t.array[arrowsNum])
        else
            r = Big:create(R.ZERO)
        end
        local j = r:add(other)
        j.array[arrowsNum+1] = (j.array[arrowsNum+1] or 0) + 1
        j:normalize()
        return j
    end
    local y = other:to_number()
    local f = math.floor(y)
    local arrows_m1 = arrows:sub(R.ONE)
    local i = 0
    local m = Big:create("10{"..tostring(arrowsNum - 1).."}"..tostring(R.MAX_SAFE_INTEGER))
    r = t:arrow(arrows_m1, y-f)
    while (f ~= 0) and r:lt(m) and (i<100) do
        if (f > 0) then
            r = t:arrow(arrows_m1, r)
            f = f - 1
        end
        i = i + 1
    end
    if (i == 100) then
        f = 0
    end
    r.array[arrowsNum] = (r.array[arrowsNum] or 0) + f
    r:normalize()
    return r
end

function Big:mod(other)
    other = Big:create(other)
    if (other:eq(R.ZERO)) then
        Big:create(R.ZERO)
    end
    if (self.sign*other.sign == -1) then
        return self:abs():mod(other:abs()):neg()
    end
    if (self.sign==-1) then
        return self:abs():mod(other:abs())
    end
    return self:sub(self:div(other):floor():mul(other))
end

function Big:lambertw()
    local x = self:clone()
    if (x:isNaN()) then
        return x;
    end
    if (x:lt(-0.3678794411710499)) then
        print("lambertw is unimplemented for results less than -1, sorry!")
        local a = nil
        return a.b
    end
    if (x:gt(R.TETRATED_MAX_SAFE_INTEGER)) then
        return x;
    end
    if (x:gt(R.EE_MAX_SAFE_INTEGER)) then
        x.array[1] = x.array[1] - 1
        return x;
    end
    if (x:gt(R.E_MAX_SAFE_INTEGER)) then
        return Big:d_lambertw(x)
    else
        return Big:create(Big:f_lambertw(x.sign*x.array[1]))
    end
end

function Big:f_lambertw(z)
    local tol = 1e-10
    local w = nil
    local wn = nil
    local OMEGA = 0.56714329040978387299997
    if (not Big:create(z):isFinite()) then
        return z;
    end
    if z == 0 then
        return z;
    end
    if z == 1 then
        return OMEGA
    end
    if (z < 10) then
        w = 0
    else
        w = math.log(z) - math.log(math.log(z))
    end
    for i=0,99 do
        wn = (z*math.exp(-w)+w*w)/(w+1)
        if (math.abs(wn-w)<tol*math.abs(wn)) then
            return wn
        end
        w=wn
    end
    print("Iteration failed to converge: "+z)
    local a = nil
    return a.b
end

function Big:d_lambertw(z)
    local tol = 1e-10
    z = Big:create(z)
    local w = nil
    local ew = nil
    local wewz = nil
    local wn = nil
    local OMEGA = 0.56714329040978387299997
    if (not z:isFinite()) then
        return z;
    end
    if (z == 0) then
        return z
    end
    if (z == 1) then
        return OMEGA
    end
    w = z:ln()
    for i=0, 99 do
        ew = w:neg():exp()
        wewz = w:sub(z:mul(ew))
        wn = w:sub(wewz:div(w:add(R.ONE):sub((w:add(2)):mul(wewz):div((w:mul(2):add(2))))))
        if (wn:sub(w):abs():lt(wn:abs():mul(tol))) then
            return wn
        end
        w = wn
    end
    print("Iteration failed to converge: "+z)
    local a = nil
    return a.b
end

------------------------metastuff----------------------------

function OmegaMeta.__add(b1, b2)
    if type(b1) == "number" then 
        return Big:create(b1):add(b2)
    end
    return b1:add(b2)
end

function OmegaMeta.__sub(b1, b2)
    if type(b1) == "number" then 
        return Big:create(b1):sub(b2) 
    end
    return b1:sub(b2)
end

function OmegaMeta.__mul(b1, b2)
    if type(b1) == "number" then 
        return Big:create(b1):mul(b2) 
    end
    return b1:mul(b2)
end

function OmegaMeta.__div(b1, b2)
    if type(b1) == "number" then 
        return Big:create(b1):div(b2) 
    end
    return b1:div(b2)
end
function OmegaMeta.__mod(b1, b2)
    if type(b1) == "number" then
        return Big:create(b1):mod(b2)
    end
    return b1:mod(b2)
end

function OmegaMeta.__unm(b)
    return b:neg()
end

function OmegaMeta.__pow(b1, b2)
    if type(b1) == "number" then 
        return Big:create(b1):pow(b2) 
    end
    return b1:pow(b2)
end

function OmegaMeta.__le(b1, b2)
    b1 = Big:create(b1)
    return b1:lte(b2)
end

function OmegaMeta.__lt(b1, b2)
    b1 = Big:create(b1)
    return b1:lt(b2)
end

function OmegaMeta.__ge(b1, b2)
    b1 = Big:create(b1)
    return b1:gte(b2)
end

function OmegaMeta.__gt(b1, b2)
    b1 = Big:create(b1)
    return b1:gt(b2)
end

function OmegaMeta.__eq(b1, b2)
    b1 = Big:create(b1)
    return b1:eq(b2)
end

function OmegaMeta.__tostring(b)
    return number_format(b)
end


---------------------------------------

return Big


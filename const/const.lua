-- 参考
-- https://qiita.com/iigura/items/7f337ac766935d1dbcee
--
-- const.lua
--[[
    example:
        const=require("const")
        const.define("PI",3.14)
        const.overwrite("PI",math.atan(1)*4)
        const.undef("PI")
]]
do
    local constTable = {}
    local constPackage = {}

    constPackage.define = function(inName, inValue)
        if constTable[inName] ~= nil then
            error("const.define: '" .. inName .. "' is already defined.")
        end
        _G[inName] = nil
        constTable[inName] = inValue
    end

    constPackage.overwrite = function(inName, inValue)
        constTable[inName] = inValue
    end

    constPackage.undef = function(inName)
        if constTable[inName] ~= nil then
            constTable[inName] = nil
        end
    end

    local setter = function(inTable, inName, inValue)
        if inTable == _G and constTable[inName] ~= nil then
            error("'" .. inName .. "' is a const.")
        end
        rawset(inTable, inName, inValue)
    end

    setmetatable(
        _G,
        {
            __index = constTable,
            __newindex = setter
        }
    )

    return constPackage
end

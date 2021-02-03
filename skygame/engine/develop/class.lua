--[[
功能: 创建一个类方法
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--

local setmetatableindex_
setmetatableindex_ = function(t, index)
    if type(t) == "userdata" then
        local peer = tolua.getpeer(t)
        if not peer then
            peer = {}
            tolua.setpeer(t, peer)
        end
        setmetatableindex_(peer, index)
    else
        local mt = getmetatable(t)
        if not mt then mt = {} end
        if not mt.__index then
            mt.__index = index
            setmetatable(t, mt)
        elseif mt.__index ~= index then
            setmetatableindex_(mt, index)
        end
    end
end
setmetatableindex = setmetatableindex_

function class(classname, ...)
    local cls = {__cname = classname}

    local supers = {...}
    for _, super in ipairs(supers) do
        local superType = type(super)
        assert(superType == "nil" or superType == "table" or superType == "function",
            string.format("class() - create class \"%s\" with invalid super class type \"%s\"",
                classname, superType))
        
        super._extendProc()
        super._inheritProc()

        if superType == "function" then
            assert(cls.__create == nil,
                string.format("class() - create class \"%s\" with more than one creating function",
                    classname));
            -- if super is function, set it to __create
            cls.__create = super
        elseif superType == "table" then
            -- if super[".isclass"] then
            --     -- super is native class
            --     assert(cls.__create == nil,
            --         string.format("class() - create class \"%s\" with more than one creating function or native class",
            --             classname));
            --     cls.__create = function() return super:create() end
            -- else
            --end

            -- super is pure lua class
            cls.__supers = cls.__supers or {}
            cls.__supers[#cls.__supers + 1] = super
            if not cls.super then
                -- set first super pure lua class as class.super
                cls.super = super
            end
        else
            error(string.format("class() - create class \"%s\" with invalid super type",
                        classname), 0)
        end
    end

    cls.__index = cls
    if not cls.__supers or #cls.__supers == 1 then
        setmetatable(cls, {__index = cls.super})
    else
        setmetatable(cls, {__index = function(_, key)
            local supers = cls.__supers
            for i = 1, #supers do
                local super = supers[i]
                if super[key] then return super[key] end
            end
        end})
    end

    if not cls.ctor then
        -- add default constructor
        cls.ctor = function() end
    end
    cls.new = function(...)
        local instance
        if cls.__create then
            instance = cls.__create(...)
        else
            instance = {}
        end
        setmetatableindex(instance, cls)
        instance.class = cls

        instance._extendProc()
        instance._inheritProc()

        instance:ctor(...)
        return instance
    end
    
    --[[同类 不同文件 同名函数 继承并扩展， 要覆盖直接重写函数即可
        eg: PlayerData.extend("AddNew")
        写在函数名前面
    ]]
    cls._extendlist = {}
    function cls.extend(funcname)
        cls._extendlist[funcname] = cls[funcname] --先把旧的函数保存下来
    end
    function cls._extendProc()
        if cls._extendlist == nil then return end --已经转化过一次了
        for funcname, oldproc in pairs(cls._extendlist) do
            local newproc = cls[funcname]
            cls[funcname] = function(...)
                oldproc(...)
                return newproc(...)
            end
        end
        cls._extendlist = nil
    end

    --[[基类函数自动继承
        eg: PlayerData.inherit("ctor")
        写在函数名前面
    ]]
    cls._inheritlist = {}
    function cls.inherit(funcname)
        cls._inheritlist[funcname] = 1 --这个时候函数还没声明
    end
    function cls._inheritProc()
        if cls._inheritlist == nil then return end
        for funcname, _ in pairs(cls._inheritlist) do
            local newproc = cls[funcname]
            local baselist = {}
            for _, super in ipairs(supers) do   --遍历基类
                local f = super[funcname]
                if f then
                    table.insert(baselist, f)
                end
            end
            cls[funcname] = function(...)
                for i,basefunc in ipairs(baselist) do
                    basefunc(...)
                end
                return newproc(...)
            end
        end
        cls._inheritlist = nil
    end

    if cls.__IsDB and _G["autocheckmysqltable"] then
        _G["autocheckmysqltable"][cls.__cname] = cls
    end

    return cls
end

--用于代码提示
function extend(class)
    return class
end
local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Maid = require(Knit.Util.Maid)

local AttributeWrapper = {}


function AttributeWrapper.new(instance, defaultAttributes)
    
    local self = setmetatable({_instance=instance}, AttributeWrapper)

    self._maid = Maid.new()
    self:__init(defaultAttributes)

    return self
    
end

function AttributeWrapper:__init(defaultAttributes)
    for i,v in pairs(defaultAttributes) do
        self:__newindex(i, v)
    end
end

function AttributeWrapper:__index(index)
    local attributes = self._instance:GetAttributes();
    return AttributeWrapper[index] or attributes[index] or nil;
end

function AttributeWrapper:__newindex(index, value)
    if typeof(value) ~= 'table' then
        self._instance:SetAttribute(index, value);
    end
end

function AttributeWrapper:__tostring(table)
    return self._instance:GetAttributes();
end

function AttributeWrapper:__len(table)
    return #self:__tostring(table)
end

-- function AttributeWrapper:Init()

-- end


-- function AttributeWrapper:Deinit()
-- end


function AttributeWrapper:Destroy()
    self._maid:Destroy()
end


return AttributeWrapper
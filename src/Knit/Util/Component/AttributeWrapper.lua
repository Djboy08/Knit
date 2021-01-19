local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Maid = require(Knit.Util.Maid)

local AttributeWrapper = {}


function AttributeWrapper.new(instance, defaultAttributes)
    
    local self = setmetatable({_instance=instance}, AttributeWrapper)
    self._maid = Maid.new()
    self.attributes = {}
    self:__init(defaultAttributes)
    self._maid:GiveTask(instance.AttributeChanged:Connect(function(name) 
        self.attributes[name] = instance:GetAttribute(name)
    end))
    self._maid:GiveTask(function() self.attributes = nil end)

    return self
    
end

function AttributeWrapper:__init(defaultAttributes)
    local current_attributes = self._instance:GetAttributes()
    for i,v in pairs(current_attributes) do
        self:__newindex(i, v)
    end
    for i,v in pairs(defaultAttributes) do
        self:__newindex(i, v)
    end
end

function AttributeWrapper:__index(index)

    local Attributes = rawget(self, 'attributes')
    return AttributeWrapper[index] or rawget(self, index) or rawget(Attributes, index);
    -- if AttributeWrapper[index] then

    --     return AttributeWrapper[index]
    -- elseif rawget(self, index) then

    --     return assert(rawget(self, index), "Missing property")
    -- elseif rawget(Attributes, index) then

    --     return assert(rawget(Attributes, index), "Missing attribute")
    -- end

end

function AttributeWrapper:__newindex(index, value)
    if typeof(value) ~= 'table' then

        self._instance:SetAttribute(index, value);
        self.attributes[index] = value;
        
    else

        rawset(self, index, value)

    end

end

-- function AttributeWrapper:__tostring(table)
--     return self._instance:GetAttributes();
-- end

function AttributeWrapper:GetAttributes(table)
    return self._instance:GetAttributes();
end

-- function AttributeWrapper:__len(table)
--     return #(self:__tostring(table))
-- end

-- function AttributeWrapper:Init()

-- end


-- function AttributeWrapper:Deinit()
-- end


function AttributeWrapper:Destroy()
    self._maid:Destroy()
end


return AttributeWrapper
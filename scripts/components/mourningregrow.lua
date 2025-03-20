local MourningRegrow = Class(function(self, inst)
    self.inst = inst

    self.onregrowfn = nil
    self.inst:AddTag("mourningregrow")
end)

function MourningRegrow:SetOnRegrowFn(fn)
    self.onregrowfn = fn
end

function MourningRegrow:Regrow(doer)
    if self.onregrowfn then
        return self.onregrowfn(self.inst, doer)
    end
    return false
end

return MourningRegrow

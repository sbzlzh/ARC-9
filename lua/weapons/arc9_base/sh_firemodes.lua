SWEP.FinishFiremodeAnimTime = 0

function SWEP:SwitchFiremode()
    if self:StillWaiting() then return end
    if #self:GetValue("Firemodes") < 2 then return end

    local fm = self:GetFiremode()

    local anim = "firemode_" .. tostring(fm)

    fm = fm + 1

    if fm > #self:GetValue("Firemodes") then
        fm = 1
    end

    if IsFirstTimePredicted() then
        self:EmitSound(self:RandomChoice(self:GetProcessedValue("FiremodeSound")), 75, 100, 1, CHAN_ITEM)
    end

    self:SetFiremode(fm)

    self:InvalidateCache()

    if self:HasAnimation(anim) then
        local t = self:PlayAnimation(anim, 1, false, true)

        self:SetFinishFiremodeAnimTime(CurTime() + t)
        -- self:SetFiremodePose()
    end
end

function SWEP:SetFiremodePose()
    local vm = self:GetVM()

    local pp = self:GetFiremode()

    if pp > #self:GetValue("Firemodes") then
        pp = 1
        self:SetFiremode(pp)
    end

    pp = self:RunHook("HookP_ModifyFiremodePoseParam", pp) or pp

    if self:GetFinishFiremodeAnimTime() < CurTime() then
        vm:SetPoseParameter("firemode", pp)
    else
        vm:SetPoseParameter("firemode", 1)
    end
end

function SWEP:GetCurrentFiremode()
    mode = self:GetCurrentFiremodeTable().Mode

    mode = self:RunHook("Hook_TranslateMode") or mode

    return mode
end

function SWEP:GetCurrentFiremodeTable()
    local fm = self:GetFiremode()

    if fm > #self:GetValue("Firemodes") then
        fm = 1
        self:SetFiremode(fm)
    end

    return self:GetValue("Firemodes")[fm]
end

function SWEP:ToggleSafety(onoff)
    onoff = onoff or !self:GetSafe()

    self:SetSafe(onoff)
end

function SWEP:ThinkFiremodes()
    if IsFirstTimePredicted() and self:GetOwner():KeyPressed(IN_ATTACK2) and self:GetOwner():KeyDown(IN_USE) then
        self:ToggleSafety()
    end

    if IsFirstTimePredicted() and self:GetOwner():KeyPressed(IN_ZOOM) then
        self:SwitchFiremode()
    end

    self:SetFiremodePose()
end
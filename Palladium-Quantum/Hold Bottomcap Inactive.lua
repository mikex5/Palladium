local sButton = Var "Button"
local sPlayer = Var "Player"
local sColor = Var "Color"
if sColor == "" then sColor = "192nd" end

return Def.ActorFrame {
    InitCommand=function(self) self:SetHeight(16) end,
    Def.Sprite {
        Texture=string.find(sButton, "Strum") and 'sprites/StrumHoldCap.png' or 'sprites/TapHoldCap.png',
        InitCommand=function(self)
            if string.find(sButton, "Strum") then
                local c = color(PalladiumQuantumColorTable[sColor])
                self:zoomy(0.5):y(16):diffuse((c[1]) * .5, (c[2]) * .5, (c[3]) * .5, 1)
            else
                self:zoom(0.5):y(16):diffuse(color(PalladiumQuantumColorTable[sColor]))
            end
        end,
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if params.Active then
                self:diffuse(color(PalladiumQuantumColorTable["Fever"]))
            else
                if string.find(sButton, "Strum") then
                    local c = color(PalladiumQuantumColorTable[sColor])
                    self:diffuse((c[1]) * .5, (c[2]) * .5, (c[3]) * .5, 1)
                else
                    self:diffuse(color(PalladiumQuantumColorTable[sColor]))
                end
            end
        end
    }
}

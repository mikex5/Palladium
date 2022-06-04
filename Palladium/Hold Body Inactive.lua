local sButton = Var "Button"
local sPlayer = Var "Player"

return Def.ActorFrame {
    InitCommand=function(self) self:SetHeight(16) end,
    Def.Sprite {
        Texture=string.find(sButton, "Strum") and 'sprites/StrumHold.png' or 'sprites/TapHold.png',
        InitCommand=function(self)
            if string.find(sButton, "Strum") then
                local c = color(PalladiumColorTable[sButton])
                self:zoomy(0.5):diffuse((c[1]) * .5, (c[2]) * .5, (c[3]) * .5, 1)
            else
                self:zoom(0.5):diffuse(color(PalladiumColorTable[sButton]))
            end
        end,
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if params.Active then
                self:diffuse(color(PalladiumColorTable["Fret 6"]))
            else
                if string.find(sButton, "Strum") then
                    local c = color(PalladiumColorTable[sButton])
                    self:diffuse((c[1]) * .5, (c[2]) * .5, (c[3]) * .5, 1)
                else
                    self:diffuse(color(PalladiumColorTable[sButton]))
                end
            end
        end
    }
}

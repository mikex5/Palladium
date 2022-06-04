local sButton = Var "Button"
local sPlayer = Var "Player"

return Def.ActorFrame {
    InitCommand=function(self) self:SetHeight(16) end,
    Def.Sprite {
        Texture=string.find(sButton, "Strum") and 'sprites/StrumHoldCap.png' or 'sprites/TapHoldCap.png',
        InitCommand=function(self)
            self:zoom(0.5):y(16):diffuse(color(PalladiumFocusColorTable[sButton]))
            if string.find(sButton, "Strum") then
                self:zoomx(1)
            end
        end,
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if params.Active then
                self:diffuse(color(PalladiumFocusFeverTable[sButton]))
            else
                self:diffuse(color(PalladiumFocusColorTable[sButton]))
            end
        end
    },
    Def.ActorFrame {
        InitCommand=function(self) self:blend('BlendMode_Add') end,
        Def.Sprite {
            Texture=string.find(sButton, "Strum") and NOTESKIN:GetPath("","_blank") or 'sprites/TapHoldCapActive_glow.png',
            InitCommand=function(self) self:zoom(0.5):y(16):diffuse(color(PalladiumFocusColorTable[sButton])) end,
            FeverMessageCommand=function(self,params)
                if params.pn ~= sPlayer then return end
                if params.Active then
                    self:diffuse(color(PalladiumFocusFeverTable[sButton]))
                else
                    self:diffuse(color(PalladiumFocusColorTable[sButton]))
                end
            end
        },
        Def.Sprite {
            Texture=string.find(sButton, "Strum") and NOTESKIN:GetPath("","_blank") or 'sprites/TapHoldCapActive_center.png',
            InitCommand=function(self) self:zoom(0.5):y(16):diffusealpha(0.6) end
        },
    }
}

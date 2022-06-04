local sButton = Var "Button"
local sPlayer = Var "Player"
local sColor = Var "Color"
if sColor == "" then sColor = "192nd" end

return Def.ActorFrame {
    InitCommand=function(self) self:SetHeight(16) end,
    Def.Sprite {
        Texture=string.find(sButton, "Strum") and 'sprites/StrumHold.png' or 'sprites/TapHold.png',
        InitCommand=function(self)
            self:zoom(0.5):diffuse(color(PalladiumQuantumColorTable[sColor]))
            if string.find(sButton, "Strum") then
                self:zoomx(1)
            end
        end,
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if params.Active then
                self:diffuse(color(PalladiumQuantumColorTable["Fever"]))
            else
                self:diffuse(color(PalladiumQuantumColorTable[sColor]))
            end
        end
    },
    Def.ActorFrame {
        InitCommand=function(self) self:blend('BlendMode_Add') end,
        Def.Sprite {
            Texture=string.find(sButton, "Strum") and NOTESKIN:GetPath("","_blank") or 'sprites/TapHoldActive_glow.png',
            InitCommand=function(self) self:zoom(0.5):diffuse(color(PalladiumQuantumColorTable[sColor])) end,
            FeverMessageCommand=function(self,params)
                if params.pn ~= sPlayer then return end
                if params.Active then
                    self:diffuse(color(PalladiumQuantumColorTable["Fever"]))
                else
                    self:diffuse(color(PalladiumQuantumColorTable[sColor]))
                end
            end
        },
        Def.Sprite {
            Texture=string.find(sButton, "Strum") and NOTESKIN:GetPath("","_blank") or 'sprites/TapHoldActive_center.png',
            InitCommand=function(self) self:zoom(0.5):diffusealpha(0.6) end
        },
    }
}

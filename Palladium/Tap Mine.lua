local sButton = Var "Button"
local sEffect = Var "Effect"
local sPlayer = Var "Player"

return Def.ActorFrame {
    Def.Model { --mine color
        InitCommand=function(self)
            self:rotationx(90):diffuse(color(PalladiumColorTable[sButton]))
        end,
        Meshes=string.find(sButton, "Strum") and "strum color.txt" or "bomb color.txt",
        Materials=(string.find(sButton, "Strum") and "resource/Strum mats.txt") or "bomb color.txt",
        Bones="bomb color.txt",
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if string.find(sButton, "Strum") then
                self:diffuse(0.1,0.1,0.1,1)
            elseif params.Active then
                self:diffuse(color(PalladiumColorTable["Fret 6"]))
            else
                self:diffuse(color(PalladiumColorTable[sButton]))
            end
        end
    },
    Def.Model { --regular mine
        InitCommand=function(self)
            self:rotationx(90)
        end,
        Meshes=string.find(sButton, "Strum") and "strum.txt" or "bomb.txt",
        Materials=(string.find(sButton, "Strum") and "resource/Strum mats.txt") or "bomb.txt",
        Bones="bomb.txt",
    }
}
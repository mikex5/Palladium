local sButton = Var "Button"
local sEffect = Var "Effect"
local sPlayer = Var "Player"
local sColor = Var "Color"
if sColor == "" then sColor = "4th" end

return Def.ActorFrame {
    Def.Model { --mine color
        InitCommand=function(self)
            self:rotationx(90):diffuse(color(PalladiumQuantumColorTable[sColor]))
        end,
        Meshes=string.find(sButton, "Strum") and "strum color.txt" or "bomb color.txt",
        Materials=(string.find(sButton, "Strum") and "resource/Strum mats.txt") or "bomb color.txt",
        Bones="bomb color.txt",
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
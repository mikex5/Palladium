local sButton = Var "Button"
local sEffect = Var "Effect"
local sPlayer = Var "Player"
local sColor = Var "Color"
if sColor == "" then sColor = "4th" end

return Def.ActorFrame {
    Def.Model { --mine color
        InitCommand=function(self)
            self:rotationx(90):diffuse(color(PalladiumQuantumColorTable[sColor]))
            if string.find(sButton, "Strum") then
                local color1 = color(PalladiumQuantumColorTable[sColor])
                local color2 = color("0.1,0.1,0.1,1")
                self:diffuse(color1[1] * color2[1], color1[2] * color2[2], color1[3] * color2[3], 1)
            end
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
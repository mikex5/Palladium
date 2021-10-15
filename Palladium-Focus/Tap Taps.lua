local sButton = Var "Button"
local sEffect = Var "Effect"
local sPlayer = Var "Player"

return Def.ActorFrame {
    Def.Model { --fever note color
        InitCommand=function(self)
            if string.find(sButton, "Strum") then
                local color1 = color(PalladiumColorTable[sButton])
                local color2 = color(PalladiumColorTable["Fret 6"])
                self:rotationx(90):diffuse((color1[1] + color2[1]) * 0.5, (color1[2] + color2[2]) * 0.5, (color1[3] + color2[3]) * 0.5, 1)
            else
                self:rotationx(90):diffuse(color(PalladiumColorTable[sButton]))
            end
            if tonumber(sEffect) <= 0 then
                self:diffusealpha(0)
                self.isHidden = true
            else
                self.isHidden = false
            end
        end,
        --If this is not a fever note from the get-go, don't even bother loading the real model
        Meshes=(tonumber(sEffect) <= 0 and "non.txt") or (string.find(sButton, "Strum") and "strum color.txt") or "star color.txt",
        Materials=(string.find(sButton, "Strum") and "resource/Strum mats.txt") or "resource/Fret taps mats.txt",
        Bones="star color.txt",
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if params.Active then
                    self:diffuse(color(PalladiumColorTable["Fret 6"]))
                else
                    if string.find(sButton, "Strum") then
                        local color1 = color(PalladiumColorTable[sButton])
                        local color2 = color(PalladiumColorTable["Fret 6"])
                        self:diffuse((color1[1] + color2[1]) * 0.5, (color1[2] + color2[2]) * 0.5, (color1[3] + color2[3]) * 0.5, 1)
                    else
                        self:diffuse(color(PalladiumColorTable[sButton]))
                    end
                end
                if self.isHidden then
                    self:diffusealpha(0)
                end
            end
        end,
        FeverMissedMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if params.Missed then
                    self:diffusealpha(0)
                    self.isHidden = true
                else
                    self:diffusealpha(1)
                    self.isHidden = false
                end
            end
        end
    },
    Def.Model { --fever note glow
        InitCommand=function(self)
            self:rotationx(90):diffuse(color(PalladiumColorTable["Fret 6"]))
            if tonumber(sEffect) <= 0 then
                self:diffusealpha(0)
                self.isHidden = true
            else
                self.isHidden = false
            end
        end,
        --If this is not a fever note from the get-go, don't even bother loading the real model
        Meshes=(tonumber(sEffect) <= 0 and "non.txt") or (string.find(sButton, "Strum") and "strum.txt") or "star glow.txt",
        Materials=(string.find(sButton, "Strum") and "resource/Strum hopo mats.txt") or "resource/Fret mats.txt",
        Bones="star glow.txt",
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                self:diffuse(color(PalladiumColorTable["Fret 6"]))
                if self.isHidden then
                    self:diffusealpha(0)
                end
            end
        end,
        FeverMissedMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if params.Missed then
                    self:diffusealpha(0)
                    self.isHidden = true
                else
                    self:diffusealpha(1)
                    self.isHidden = false
                end
            end
        end
    },
    Def.Model { --fever note
        InitCommand=function(self)
            self:rotationx(90)
            if tonumber(sEffect) <= 0 then
                self:diffusealpha(0)
                self.isHidden = true
            else
                self.isHidden = false
            end
        end,
        --If this is not a fever note from the get-go, don't even bother loading the real model
        Meshes=(tonumber(sEffect) <= 0 and "non.txt") or (string.find(sButton, "Strum") and "non.txt") or "star.txt",
        Materials=(string.find(sButton, "Strum") and "resource/Strum mats.txt") or "resource/Fret taps mats.txt",
        Bones="star.txt",
        FeverMissedMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if params.Missed then
                    self:diffusealpha(0)
                    self.isHidden = true
                else
                    self:diffusealpha(1)
                    self.isHidden = false
                end
            end
        end
    },
    Def.Model { --regular note color
        InitCommand=function(self)
            self:rotationx(90):diffuse(color(PalladiumColorTable[sButton]))
            if tonumber(sEffect) > 0 then
                self:diffusealpha(0)
                self.isHidden = true
            else
                self.isHidden = false
            end
        end,
        Meshes=string.find(sButton, "Strum") and "strum color.txt" or "gem color.txt",
        Materials=(string.find(sButton, "Strum") and "resource/Strum mats.txt") or "resource/Fret taps mats.txt",
        Bones="gem color.txt",
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if params.Active then
                self:diffuse(color(PalladiumColorTable["Fret 6"]))
            else
                self:diffuse(color(PalladiumColorTable[sButton]))
            end
            if self.isHidden then
                self:diffusealpha(0)
            end
        end,
        FeverMissedMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if params.Missed then
                    self:diffusealpha(1)
                    self.isHidden = false
                else
                    self:diffusealpha(0)
                    self.isHidden = true
                end
            end
        end
    },
    Def.Model { --regular note
        InitCommand=function(self)
            self:rotationx(90)
            if tonumber(sEffect) > 0 then
                self:diffusealpha(0)
                self.isHidden = true
            else
                self.isHidden = false
            end
        end,
        Meshes=string.find(sButton, "Strum") and "strum.txt" or "gem.txt",
        Materials=(string.find(sButton, "Strum") and "resource/Strum mats.txt") or "resource/Fret taps mats.txt",
        Bones="gem.txt",
        FeverMissedMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if params.Missed then
                    self:diffusealpha(1)
                    self.isHidden = false
                else
                    self:diffusealpha(0)
                    self.isHidden = true
                end
            end
        end
    },
    Def.Model { --anti shiny thing
        InitCommand=function(self) self:backfacecull(false):rotationx(90):zoomx(1.5):zoomz(1.5) end,
        Meshes=string.find(sButton, "Strum") and "non.txt" or "shine.txt",
        Materials="resource/Darkshine mats.txt",
        Bones="shine.txt"
    }
}
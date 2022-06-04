local sButton = Var "Button"
local sEffect = Var "Effect"
local sPlayer = Var "Player"

return Def.ActorFrame {
    Def.Model { --fever note color
        InitCommand=function(self)
            self:rotationx(90):diffuse(color(PalladiumColorTable[sButton]))
            if tonumber(sEffect) <= 0 then
                self:diffusealpha(0)
                self.isHidden = true
            else
                self.isHidden = false
            end
        end,
        --If this is not a fever note from the get-go, don't even bother loading the real model
        Meshes=(tonumber(sEffect) <= 0 and "models/non.txt") or (string.find(sButton, "Strum") and "models/strum color.txt") or "models/star color.txt",
        Materials=(string.find(sButton, "Strum") and "models/materials/Strum mats.txt") or "models/materials/Fret taps mats.txt",
        Bones="models/star color.txt",
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if params.Active then
                    self:diffuse(color(PalladiumColorTable["Fret 6"]))
                else
                    self:diffuse(color(PalladiumColorTable[sButton]))
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
        Meshes=(tonumber(sEffect) <= 0 and "models/non.txt") or (string.find(sButton, "Strum") and "models/strum.txt") or "models/star glow.txt",
        Materials=(string.find(sButton, "Strum") and "models/materials/Strum fever mats.txt") or "models/materials/Fret mats.txt",
        Bones="models/star glow.txt",
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
        Meshes=(tonumber(sEffect) <= 0 and "models/non.txt") or (string.find(sButton, "Strum") and "models/non.txt") or "models/star.txt",
        Materials=(string.find(sButton, "Strum") and "models/materials/Strum mats.txt") or "models/materials/Fret taps mats.txt",
        Bones="models/star.txt",
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
        Meshes=string.find(sButton, "Strum") and "models/strum color.txt" or "models/gem color.txt",
        Materials=(string.find(sButton, "Strum") and "models/materials/Strum mats.txt") or "models/materials/Fret taps mats.txt",
        Bones="models/gem color.txt",
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
        Meshes=string.find(sButton, "Strum") and "models/strum.txt" or "models/gem.txt",
        Materials=(string.find(sButton, "Strum") and "models/materials/Strum mats.txt") or "models/materials/Fret taps mats.txt",
        Bones="models/gem.txt",
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
        InitCommand=function(self) self:backfacecull(false):rotationx(90):rotationy(90) end,
        Meshes=string.find(sButton, "Strum") and "models/non.txt" or "models/shine.txt",
        Materials="models/materials/Darkshine mats.txt",
        Bones="models/shine.txt"
    }
}
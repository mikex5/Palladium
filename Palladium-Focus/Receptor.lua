local sButton = Var "Button"
local sPlayer = Var "Player"
if not GHReceptor then GHReceptor = {} end
if not GHReceptor[sPlayer] then GHReceptor[sPlayer] = {} end
if not GHReceptor[sPlayer][sButton] then GHReceptor[sPlayer][sButton] = {} end

local Buttons = {
    "Fret 1",
    "Fret 2",
    "Fret 3",
    "Fret 4",
    "Fret 5"
}

local offsetChart =
{
    ["Fret 1"] = -20,
    ["Fret 2"] = -10,
    ["Fret 3"] = 0,
    ["Fret 4"] = 10,
    ["Fret 5"] = 20,
    ["Fret 6"] = 30,
    ["Strum Up"] = 0
}

local feverActive = false

if sButton == "Strum Up" then
    return Def.ActorFrame{
    PressCommand=function(self) --Function to make the receptors bop
        local FretActive = false
        for _,v in ipairs(Buttons) do
            if GHReceptor[sPlayer][v][2] then
                FretActive = true
            end
        end
        if not FretActive then
            for _,v in ipairs(Buttons) do
                GHReceptor[sPlayer][v][3]:stoptweening():diffusealpha(1):z(6):sleep(.1):bounceend(.1):z(0):diffusealpha(1)
                GHReceptor[sPlayer][v][4]:stoptweening():diffusealpha(1):z(6):sleep(.1):bounceend(.1):z(0):diffusealpha(1)
            end
        end
    end
    }
end

local Push = Def.ActorFrame{
    Def.Model {
        InitCommand=function(self)
            self:rotationx(90):diffuse(color(PalladiumFocusColorTable[sButton]))
            GHReceptor[sPlayer][sButton][3] = self
        end,
        PressCommand=function(self) self:diffusealpha(0) end,
        LiftCommand=function(self) self:sleep(self:GetTweenTimeLeft()):diffusealpha(1) end,
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if params.Active then
                self:diffuse(color(PalladiumFocusColorTable["Fret 6"]))
            else
                self:diffuse(color(PalladiumFocusColorTable[sButton]))
            end
            if GHReceptor[sPlayer][sButton][2] then
                self:diffusealpha(0)
            end
        end,
        Meshes="inner_receptor_idle color.txt",
        Materials="inner_receptor_idle color.txt",
        Bones="inner_receptor_idle color.txt"
    },
    Def.Model {
        InitCommand=function(self)
            self:rotationx(90):rotationy(136 + offsetChart[sButton]):diffusealpha(1)
            GHReceptor[sPlayer][sButton][4] = self
        end,
        PressCommand=function(self) self:diffusealpha(0) end,
        LiftCommand=function(self) self:sleep(self:GetTweenTimeLeft()):diffusealpha(1) end,
        Meshes="inner_receptor_idle.txt",
        Materials="inner_receptor_idle.txt",
        Bones="inner_receptor_idle.txt"
    },
    Def.Model {
        InitCommand=function(self)
            self:diffuse(color(PalladiumFocusColorTable[sButton])):diffusealpha(0):rotationx(90):rotationy(120 + offsetChart[sButton])
            GHReceptor[sPlayer][sButton][5] = self
        end,
        PressCommand=function(self) self:diffusealpha(1):decelerate(.1):z(-3) end,
        LiftCommand=function(self) self:sleep(self:GetTweenTimeLeft()):diffusealpha(0):z(0) end,
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if params.Active then
                self:diffuse(color(PalladiumFocusColorTable["Fret 6"]))
            else
                self:diffuse(color(PalladiumFocusColorTable[sButton]))
            end
            if not GHReceptor[sPlayer][sButton][2] then
                self:diffusealpha(0)
            end
        end,
        Meshes="inner_receptor_active color.txt",
        Materials="inner_receptor_active color.txt",
        Bones="inner_receptor_active color.txt"
    },
    Def.Model {
        InitCommand=function(self)
            self:diffusealpha(0):rotationx(90):rotationy(136 + offsetChart[sButton])
            GHReceptor[sPlayer][sButton][6] = self
        end,
        PressCommand=function(self) self:diffusealpha(1):decelerate(.1):z(-3) end,
        LiftCommand=function(self) self:sleep(self:GetTweenTimeLeft()):diffusealpha(0):z(0) end,
        Meshes="inner_receptor_active.txt",
        Materials="inner_receptor_active.txt",
        Bones="inner_receptor_active.txt"
    },
    Def.Model {
        InitCommand=function(self)
            self:diffusealpha(0):rotationx(90)
            GHReceptor[sPlayer][sButton][7] = self
        end,
        PressCommand=function(self) self:diffusealpha(1):zoomy(0.5):z(-3) end,
        LiftCommand=function(self) self:sleep(self:GetTweenTimeLeft()):diffusealpha(0):zoomy(1):z(0) end,
        Meshes="metal.txt",
        Materials="metal.txt",
        Bones="metal.txt"
    }
}

local hitCommand = function(self)
    GHReceptor[sPlayer][sButton][3]:stoptweening():diffusealpha(0):z(16):sleep(.1):accelerate(.1):z(0)
    GHReceptor[sPlayer][sButton][4]:stoptweening():diffusealpha(0):z(16):sleep(.1):accelerate(.1):z(0)
    GHReceptor[sPlayer][sButton][5]:stoptweening():diffusealpha(1):z(16):sleep(.1):accelerate(.1):z(-3)
    GHReceptor[sPlayer][sButton][6]:stoptweening():diffusealpha(1):z(16):sleep(.1):accelerate(.1):z(-3)
    GHReceptor[sPlayer][sButton][7]:stoptweening():diffusealpha(1):z(18):zoomy(4):sleep(.1):accelerate(.1):z(-3):zoomy(.5)
end

return Def.ActorFrame {
    InitCommand=function(self)
        GHReceptor[sPlayer][sButton][1] = self
        GHReceptor[sPlayer][sButton][2] = false
    end,
    PressCommand=function(self)
        GHReceptor[sPlayer][sButton][2] = true
    end,
    LiftCommand=function(self)
        GHReceptor[sPlayer][sButton][2] = false
    end,
    W1Command=hitCommand,
    W2Command=hitCommand,
    W3Command=hitCommand,
    W4Command=hitCommand,
    W5Command=hitCommand,
    Def.Sprite { --Secret sauce of this noteskin, the indicator rings
        Texture="resource/indicator_ring.png",
        InitCommand=function(self)
            self:z(-1):zoom(1):diffuse(1,1,1,1)
            self.Amount=0
            self.curColor=color(1,1,1,1)
        end,
        ComboChangedMessageCommand=function(self,params)
            if params.Player ~= sPlayer then return end
            local curCombo = params.PlayerStageStats:GetCurrentCombo()
            if curCombo >= 30 then
                self.curColor = color(".8,.1,1,1")
            elseif curCombo >= 20 then
                self.curColor = color(".1,.8,.1,1")
            elseif curCombo >= 10 then
                self.curColor = color("1,.8,.1,1")
            else
                self.curColor = color("1,1,1,1")
            end
            if self.Amount >= 50 then
                self:diffuseshift():effectcolor1(color(PalladiumFocusColorTable["Fret 6"])):effectcolor2(self.curColor):effectperiod(2)
            else
                self:stopeffect():stoptweening():diffuse(self.curColor)
            end
        end,
        FeverScoreMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            self.Amount = params.Amount;
            if not self.Active then
                if self.Amount >= 50 then 
                    self:diffuseshift():effectcolor1(color(PalladiumFocusColorTable["Fret 6"])):effectcolor2(self.curColor):effectperiod(2)
                else
                    self:stopeffect():stoptweening():diffuse(self.curColor)
                end
            end
        end,
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if params.Active then
                self:stopeffect():stoptweening():diffuse(self.curColor)
            end
        end,
    },
    Def.Model {
        InitCommand=function(self) self:rotationx(90):diffuse(color(PalladiumFocusColorTable[sButton])) end,
        Meshes="outer_receptor color.txt",
        Materials="outer_receptor color.txt",
        Bones="outer_receptor color.txt",
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if params.Active then
                self:diffuse(color(PalladiumFocusColorTable["Fret 6"]))
            else
                self:diffuse(color(PalladiumFocusColorTable[sButton]))
            end
        end
    },
    Def.Model {
        InitCommand=function(self) self:rotationx(90) end,
        Meshes="outer_receptor.txt",
        Materials="outer_receptor.txt",
        Bones="outer_receptor.txt",
    },
    Push
}
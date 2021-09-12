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

local feverExplosion = Def.ActorFrame{}

local starBurst = function(self,params)
    if params.Amount > self.prevAmount then
        self:stoptweening():x(self.startPos):z(8):diffuse(color(PalladiumColorTable["Fret 6"])):decelerate(math.random(30,100) / 100):z(math.random(60,90)):x(self.startPos+math.random(-100,100)):rotationz(math.random(-179,179)):diffusealpha(0)
        self.prevAmount = params.Amount
    end
end

for i = 1,16 do
    feverExplosion[#feverExplosion+1] = Def.ActorFrame{
        InitCommand=function(self)
            self:diffusealpha(0):zoom(.8):rotationx(90):x((25*i) - 212)
            self.startPos = (25*i) - 212
            self.prevAmount = 0
        end,
        FeverMissedMessageCommand=function(self,params)
            if params.Missed then
                self.comboSuccess = false
            else
                self.comboSuccess = true
            end
        end,
        FeverScoreMessageCommand=starBurst,
        FeverMessageCommand=function(self,params)
            self.prevAmount = 0
        end,
        Def.Sprite {
            Texture='partfever.png'
        }
    }
end

if sButton == "Strum Up" then
    return Def.ActorFrame{
        Def.ActorFrame{ --Fever meter
            OnCommand=function(self) self:z(-5):x(10) end,
            Def.Quad{
                OnCommand=function(self)
                    self:zoomto(32,100):diffuse(0,0,0,1):xy(184,-48)
                end
            },
            Def.Quad{
                OnCommand=function(self)
                    self:zoomto(22,90):diffuse(1,.9,.3,1):xy(184,-48):croptop(1)
                end,
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    feverActive = params.Active
                    if params.Active then
                        self.Active = true
                        self:linear((self.Amount /125)*12.5):croptop(1)
                    else
                        self.Active = false
                    end
                end,
                FeverScoreMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    self.Amount = params.Amount;
                    self:stoptweening():linear(.1):croptop(1-(params.Amount /125))
                    if not self.Active then
                        if params.Amount >= 50 then 
                            self:diffuseshift():effectcolor1(color(PalladiumColorTable["Fret 6"])):effectcolor2(1,1,1,1):effectperiod(.5)
                        else 
                            self:stopeffect():diffuse(1,.9,.3,1)
                        end
                    else
                        self:stoptweening():stopeffect():linear((self.Amount /125)*12.5):croptop(1)
                    end
                end
            },
            Def.Sprite{
                InitCommand=function(self)
                    self:xy(184,-48):draworder(110)
                end,
                Texture='feveroverlay.png'
            },
            PressCommand=function(self) --Function to make the receptors bop? why here?
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
        },
        Def.ActorFrame{ --Score and multiplier
            OnCommand=function(self) self:z(-5):x(-8) end,
            Def.Quad{
                OnCommand=function(self) 
                    self:zoomto(80,100):diffuse(0,0,0,1):xy(-210,-48)
                end
            },
            Def.BitmapText{
                Text="1x",
                Font="Common Normal",
                OnCommand=function(self) self:zoom(2):halign(0):xy(-220,-70) end,
                ComboChangedMessageCommand=function(self,params)
                    if params.Player ~= sPlayer then return end
                    local curCombo = params.PlayerStageStats:GetCurrentCombo()
                    local percent = 1
                    self:diffuse(1,1,1,1)
                    
                    if curCombo >= 30 then
                        percent = 4
                        self:diffuse(.8,.1,1,1)
                    elseif curCombo >= 20 then
                        percent = 3
                        self:diffuse(.1,.8,.1,1)
                    elseif curCombo >= 10 then
                        percent = 2
                        self:diffuse(1,.8,.1,1)
                    end
                    
                    if feverActive then
                        percent = percent*2
                        self:diffuse(color(PalladiumColorTable["Fret 6"]))
                    end
                    
                    self:settext("x"..percent)
                end
            },
            Def.BitmapText{
                Text="0",
                Font="Common Normal",
                OnCommand=function(self) self:zoom(.6):halign(1):xy(-175,-15) end,
                ComboChangedMessageCommand=function(self,params)
                    if params.Player ~= sPlayer then return end
                    self:settext(params.PlayerStageStats:GetScore())
                end
            },
            Def.BitmapText{
                Text="oooooooooo",
                Font="Common Normal",
                OnCommand=function(self) self:zoom(.65):halign(1):xy(-175,-38):diffuse(1,1,1,1) end,
                ComboChangedMessageCommand=function(self,params)
                    if params.Player ~= sPlayer then return end
                    local curCombo = params.PlayerStageStats:GetCurrentCombo()
                    if curCombo >= 30 then
                        self:diffuse(.8,.1,1,1)
                    elseif curCombo >= 20 then
                        self:diffuse(.1,.8,.1,1)
                    elseif curCombo >= 10 then
                        self:diffuse(1,.8,.1,1)
                    else
                        self:diffuse(1,1,1,1)
                    end
                    
                    if feverActive then
                        self:diffuse(color(PalladiumColorTable["Fret 6"]))
                    end
                end
            },
            Def.BitmapText{
                Text="",
                Font="Common Normal",
                OnCommand=function(self) self:zoom(1.2):halign(0):xy(-246.5,-43):diffuse(1,1,1,1) end,
                ComboChangedMessageCommand=function(self,params)
                    if params.Player ~= sPlayer then return end
                    local curCombo = params.PlayerStageStats:GetCurrentCombo()
                    if curCombo >= 30 then
                        self:settext("..........")
                        self:diffuse(.8,.1,1,1)
                    elseif curCombo == 0 then
                        self:settext("")
                    else
                        local pips = curCombo % 10
                        if pips == 0 then pips = 10 end
                        self:settext(string.rep(".",pips))
                        
                        if curCombo >= 30 then
                            self:diffuse(.8,.1,1,1)
                        elseif curCombo >= 20 then
                            self:diffuse(.1,.8,.1,1)
                        elseif curCombo >= 10 then
                            self:diffuse(1,.8,.1,1)
                        else
                            self:diffuse(1,1,1,1)
                        end
                    end
                    
                    if feverActive then
                        self:diffuse(color(PalladiumColorTable["Fret 6"]))
                    end
                end
            },
        },
        Def.ActorFrame{ --Highway
            OnCommand=function(self) self:z(-8) end,
            Def.Quad{ --Highway edges
                InitCommand=function(self)
                    self:xy(-165,-205):zoomto(2,612):diffuse(1,1,1,1):diffusetopedge(1,1,1,0)
                end,
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Active then
                        self:diffuse(color(PalladiumColorTable["Fret 6"])):diffusetopedge(Alpha(color(PalladiumColorTable["Fret 6"]),0))
                    else
                        self:diffuse(1,1,1,1):diffusetopedge(1,1,1,0)
                    end
                end,
            },
            Def.Quad{
                InitCommand=function(self)
                    self:xy(165,-205):zoomto(2,612):diffuse(1,1,1,1):diffusetopedge(1,1,1,0)
                end,
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Active then
                        self:diffuse(color(PalladiumColorTable["Fret 6"])):diffusetopedge(Alpha(color(PalladiumColorTable["Fret 6"]),0))
                    else
                        self:diffuse(1,1,1,1):diffusetopedge(1,1,1,0)
                    end
                end,
            },
            Def.ActorFrame{ --Fever effects
                InitCommand=function(self)
                    self:y(-110):diffusealpha(0)
                end,
                Def.Sprite{
                    Texture="feversprite1.png",
                    InitCommand=function(self)
                        self:x(-102):diffuse(color(PalladiumColorTable["Fret 6"])):zoom(4)
                    end
                },
                Def.Sprite{
                    Texture="feversprite1.png",
                    InitCommand=function(self)
                        self:x(102):zoomx(-4):zoomy(4):diffuse(color(PalladiumColorTable["Fret 6"]))
                    end
                },
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Active then
                        self:y(-70):diffusealpha(1):linear(0.5):y(-800):diffusealpha(0)
                    else
                        self:diffusealpha(0):y(-64)
                    end
                end,
            },
            Def.ActorFrame{ --More fever effects
                InitCommand=function(self)
                    self:y(-369):diffusealpha(0)
                end,
                Def.Quad{
                    InitCommand=function(self)
                        self:x(-150):zoomto(32,940):diffuse(Alpha(color(PalladiumColorTable["Fret 6"]),0)):diffuselowerleft(color(PalladiumColorTable["Fret 6"]))
                    end
                },
                Def.Quad{
                    InitCommand=function(self)
                        self:x(150):zoomto(-32,940):diffuse(Alpha(color(PalladiumColorTable["Fret 6"]),0)):diffuselowerleft(color(PalladiumColorTable["Fret 6"]))
                    end
                },
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Active then
                        self:diffuseshift():diffusealpha(1):effectcolor1(1,1,1,1):effectcolor2(1,1,1,.5):effectperiod(1)
                    else
                        self:stopeffect():diffusealpha(0)
                    end
                end,
            }
        },
        feverExplosion
    }
end

local Push = Def.ActorFrame{
    Def.Model {
        InitCommand=function(self)
            self:rotationx(90):diffuse(color(PalladiumColorTable[sButton]))
            GHReceptor[sPlayer][sButton][3] = self
        end,
        PressCommand=function(self) self:diffusealpha(0) end,
        LiftCommand=function(self) self:sleep(self:GetTweenTimeLeft()):diffusealpha(1) end,
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if params.Active then
                self:diffuse(color(PalladiumColorTable["Fret 6"]))
            else
                self:diffuse(color(PalladiumColorTable[sButton]))
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
            self:diffuse(color(PalladiumColorTable[sButton])):diffusealpha(0):rotationx(90):rotationy(120 + offsetChart[sButton])
            GHReceptor[sPlayer][sButton][5] = self
        end,
        PressCommand=function(self) self:diffusealpha(1):decelerate(.1):z(-3) end,
        LiftCommand=function(self) self:sleep(self:GetTweenTimeLeft()):diffusealpha(0):z(0) end,
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if params.Active then
                self:diffuse(color(PalladiumColorTable["Fret 6"]))
            else
                self:diffuse(color(PalladiumColorTable[sButton]))
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
    Def.Quad {
        InitCommand=function(self)
            self:xy(0,-180):zoomto(2,320):diffuse(1,1,1,1):diffusetopedge(1,1,1,0)
        end
    },
    Def.Model {
        InitCommand=function(self) self:rotationx(90):diffuse(color(PalladiumColorTable[sButton])) end,
        Meshes="outer_receptor color.txt",
        Materials="outer_receptor color.txt",
        Bones="outer_receptor color.txt",
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if params.Active then
                self:diffuse(color(PalladiumColorTable["Fret 6"]))
            else
                self:diffuse(color(PalladiumColorTable[sButton]))
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
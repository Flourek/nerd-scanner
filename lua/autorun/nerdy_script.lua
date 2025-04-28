local function SpawnNerd(scanner)

    local plate = ents.Create("prop_physics")

    plate:SetModel("models/props/scanner_nerd/scanner_nerd.mdl")
    plate:SetParent(scanner)
    plate:SetLocalPos(Vector(5, 0, 0)) 
    plate:SetLocalAngles(Angle(0,0,0)) 

    plate:EmitSound("Scanner-Nerd/ahooga.wav")

    local startTime = CurTime()
    local identifier = tostring(startTime)

    hook.Add("Think", identifier, function()
        if IsValid(plate) then 

            local deltaTime = CurTime() - startTime
            local newY = Lerp(deltaTime / 3, 0, -16)
            plate:SetLocalPos(Vector(5, 0, newY))   
            
            if deltaTime >= 3 then
                hook.Remove("Think", identifier)    
            end       
        else
            hook.Remove("Think", identifier) 
        end
    end)

    local dropAfterTime = math.Rand(5, 7)
    timer.Simple(dropAfterTime, function() if IsValid(plate) then 
        plate:SetParent()
        plate:Spawn()
    end end)

    timer.Simple(30, function() if IsValid(plate) then plate:Remove() end end)
end

hook.Add("EntityEmitSound", "SpawnNerdOnCScannerFlash", function(data)

    if  data.Entity:IsValid() 
    and data.Entity:GetClass() == "npc_cscanner" 
    and data.SoundName == "npc/scanner/scanner_photo1.wav" 
    and data.Pitch == 70 then
        SpawnNerd(data.Entity)
    end 
end)

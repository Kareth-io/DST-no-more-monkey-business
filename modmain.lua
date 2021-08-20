if not (GLOBAL.TheNet:GetIsServer() or GLOBAL.TheNet:IsDedicated()) then 
	return
end

AddPrefabPostInit("monkey", function(inst)
	-- Have to copy the existing local functions
	-- Drops harassment focus
	local function SetHarassPlayer(inst, player)
    	if inst.harassplayer ~= player then
        	if inst._harassovertask ~= nil then
	            inst._harassovertask:Cancel()
            	inst._harassovertask = nil
        	end
        	if inst.harassplayer ~= nil then
	            inst:RemoveEventCallback("onremove", inst._onharassplayerremoved, inst.harassplayer)
            	inst.harassplayer = nil
        	end
        	if player ~= nil then
	            inst:ListenForEvent("onremove", inst._onharassplayerremoved, player)
            	inst.harassplayer = player
            	inst._harassovertask = inst:DoTaskInTime(120, SetHarassPlayer, nil)
        	end
    	end
	end

	-- Essentially checks if the Monkey is outside of its "Residential" area and if so puts that bitch on bricks.
	local function f_off_m8(inst)
    	if not inst.components.areaaware.current_area_data.id:find("^Residential") then
        	SetHarassPlayer(inst, nil)
        	inst.components.homeseeker.home:PushEvent("monkeydanger")
    	end
    end
    inst:ListenForEvent("changearea", f_off_m8)
end
)
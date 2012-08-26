-- These functions make the devour cards much shorter, and allow me to make slight fixes if needed

TARGET_CHEST_DEVOUR = 6

Devour_PlayTimeAction = function(target_definition_id, number)
-- use this as the PLAY_TIME_ACTION of the devour mechanic
-- the number argument stands for the "Devour number", use any number <= 0 for an unspecified number
	local filter = Object():LoadTargetDefinition(target_definition_id)
	local max_victims = filter:Count()

	if max_victims == 0 then
		return
	end

	local string = "CARD_QUERY_CHOOSE_CREATURE_TO_DEVOUR"
	if number ~= nil and number > 0 then
		string = "CARD_QUERY_CHOOSE_CREATURE_TO_DEVOUR_"..number
	end

	local player = EffectController()
	player:SetTargetCount(max_victims)
	for i=0,max_victims-1 do
		player:SetTargetPrompt( i, string )
	end
	player:ChooseTargets( target_definition_id, EffectDC():Make_Targets(TARGET_CHEST_DEVOUR) )
end

Devour_ResolutionTimeAction = function(target_definition_id, number)
-- use this as the RESOLUTION_TIME_ACTION of the devour mechanic
-- the number argument stands for the "Devour number", use -1 for Thromok
-- it returns the devour count, so it can be used for other purposes
	local filter = Object():LoadTargetDefinition(target_definition_id)
	local max_victims = filter:Count()

	if max_victims == 0 then
		return
	end

	local player = EffectController()
	local devour_count = 0
	for i=0,max_victims-1 do
		local victim = EffectDC():Get_Targets(TARGET_CHEST_DEVOUR):Get_CardPtr(i)
		if victim ~= nil then
			player:Sacrifice(victim)
			devour_count = devour_count + 1
		end
	end

	local source = EffectSource()
	if source == nil then
		source = Object()
	end

	local counters = 0
	if number ~= nil then
		if number == -1 then
			counters = devour_count*devour_count
		elseif number > 0 then
			counters = devour_count*number
		end
	end

	if source ~= nil then
		source:AddCounters( MTG():PlusOnePlusOneCounters(), counters )
	end

	return devour_count
end
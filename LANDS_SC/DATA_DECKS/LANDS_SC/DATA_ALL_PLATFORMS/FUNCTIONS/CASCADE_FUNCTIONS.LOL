-- These functions make the cascade cards much shorter, and allow me to make slight fixes if needed (DotP2012 had a flaw in subsequent cascade triggers)

Cascade_PlayTimeAction = function()
-- use this as the PLAY_TIME_ACTION of the cascade mechanic
	local spell = TriggerObject()
	if spell ~= nil then
		EffectDC():Set_Int( 5, spell:GetConvertedManaCost() )
	end
end

Cascade_ResolutionTimeAction1 = function()
-- use this as the first RESOLUTION_TIME_ACTION of the cascade mechanic
	local cmc = EffectDC():Get_Int(5)
	local player = EffectController()

	if cmc > 0 then
		local filter = Object():GetFilter()
		filter:Clear()
		filter:NotTargetted()
		filter:SetZone( ZONE_LIBRARY )
		filter:SetPlayer( player )
		filter:SetConvertedCostMax( cmc-1 )
		if filter:CountStopAt(1) == 0 then
			cmc = 0
			EffectDC():Set_Int(5, 0)
		end
	end
	if cmc > 0 and player:Library_Count() > 0 then

		local card = player:Library_GetNth(0)
		local exile_chest = EffectDC():Make_Chest(1)
		local cascade_spell = EffectDC():Make_Chest(2)
		local i = 1
		while card ~= nil do
			if card:GetCardType():Test( CARD_TYPE_LAND ) == 0 and card:GetConvertedManaCost() < cmc then
				card:RemoveFromGame()
				cascade_spell:Set_CardPtr(0, card)
				exile_chest:Set_CardPtr(0, card)
				return
			else
				card:RemoveFromGame()
				exile_chest:Set_CardPtr(i, card)
				EffectDC():Set_Int(3, i)
				i = i+1
			end
			card = player:Library_GetNth(0)
		end

	end
end

Cascade_ResolutionTimeAction2 = function()
-- use this as the second RESOLUTION_TIME_ACTION of the cascade mechanic
	local cmc = EffectDC():Get_Int(5)
	local player = EffectController()
	if cmc > 0 and player:Library_Count() > 0 then

		local browser = EffectDC():Get_Chest(2)
		local player = EffectController()
		if player ~= nil and browser ~= nil then
			player:SetTargetCount(1)
			player:SetTargetPrompt( 0, "CARD_QUERY_PLAY_OR_BOTTOM_LIBRARY" )
			player:ChooseTargetsFromDCWithFlags( NO_VALIDATION, browser, EffectDC():Make_Targets(0),
				QUERY_FLAG_CAN_BE_FINISHED_EARLY + QUERY_FLAG_CAN_BE_FINISHED_EARLY_FOR_AI_AS_WELL )
		end

	end
end

Cascade_ResolutionTimeAction3 = function()
-- use this as the third RESOLUTION_TIME_ACTION of the cascade mechanic
	local cmc = EffectDC():Get_Int(5)
	local player = EffectController()
	if cmc > 0 and player:Library_Count() > 0 then

		local cascade_spell = EffectDC():Get_Targets(0):Get_CardPtr(0)
		local player = EffectController()
		local exile_chest = EffectDC():Get_Chest(1)
		if cascade_spell ~= nil and player ~= nil then
			if cascade_spell:CanBePlayed( player ) then
				cascade_spell:PlayFreeFromAnywhere( player )
			end
			if exile_chest ~= nil then
				exile_chest:Set_CardPtr(0, nil)
			end
		end

	end
end

Cascade_ResolutionTimeAction4 = function()
-- use this as the fourth (and last) RESOLUTION_TIME_ACTION of the cascade mechanic
	local cmc = EffectDC():Get_Int(5)
	if cmc > 0 then

		local exile_chest = EffectDC():Get_Chest(1)
		local card_count = EffectDC():Get_Int(3)
		if exile_chest ~= nil then
			for i=0,card_count do
				local exiled_card = exile_chest:Get_CardPtr(i)
				if exiled_card ~= nil then
					exiled_card:GuidedReveal( ZONE_LIBRARY, ZONE_LIBRARY )
					exiled_card:PutInLibrary( -1 )
				end
			end
		end

	else
		local player = EffectController()
		local library_count = player:Library_Count()
		if library_count > 0 then
			for i=0,library_count-1 do
				local library_card = player:Library_GetNth(i)
				if library_card ~= nil then
					library_card:GuidedReveal( ZONE_LIBRARY, ZONE_LIBRARY )
					library_card:PutInLibrary( -1 )
				end
			end
		end
	end
end
IsPermanent = function(object)
-- returns true if object has a permanent type
	local types = object:GetCardType()
	return (types:Test( CARD_TYPE_ARTIFACT ) ~= 0 or
	types:Test( CARD_TYPE_ENCHANTMENT ) ~= 0 or
	types:Test( CARD_TYPE_LAND ) ~= 0 or
	types:Test( CARD_TYPE_CREATURE ) ~= 0 or
	types:Test( CARD_TYPE_PLANESWALKER ) ~= 0)
end

Morbid = function()
-- returns true if a creature died this turn
	local num_players = MTG():GetNumberOfPlayers()
	for i=0,num_players-1 do
		local player = MTG():GetNthPlayer(i)
		if player ~= nil then
			if MTG():Interrogate_CreaturesDiedThisTurn( player ) > 0 then
				return true
			end
		end
	end
	return false
end

HasAnyCounter = function(object)
-- returns true if object has any counter on it
	return object:GetBestOrWorstCounterType(1) ~= 0 or object:GetBestOrWorstCounterType(0) ~= 0
end

DomainCount = function(player)
-- returns the number of basic land types controlled by player
	local n = 0
	local filter = Object():GetFilter()
	filter:Clear()
	filter:SetZone( ZONE_IN_PLAY )
	filter:AddSubType( LAND_TYPE_FOREST )
	filter:SetController( player )
	filter:NotTargetted()
	if (filter:CountStopAt( 1 ) == 1) then
		n = n + 1
	end
	filter:Clear()
	filter:SetZone( ZONE_IN_PLAY )
	filter:AddSubType( LAND_TYPE_ISLAND )
	filter:SetController( player )
	filter:NotTargetted()
	if (filter:CountStopAt( 1 ) == 1) then
		n = n + 1
	end
	filter:Clear()
	filter:SetZone( ZONE_IN_PLAY )
	filter:AddSubType( LAND_TYPE_MOUNTAIN )
	filter:SetController( player )
	filter:NotTargetted()
	if (filter:CountStopAt( 1 ) == 1) then
		n = n + 1
	end
	filter:Clear()
	filter:SetZone( ZONE_IN_PLAY )
	filter:AddSubType( LAND_TYPE_PLAINS )
	filter:SetController( player )
	filter:NotTargetted()
	if (filter:CountStopAt( 1 ) == 1) then
		n = n + 1
	end
	filter:Clear()
	filter:SetZone( ZONE_IN_PLAY )
	filter:AddSubType( LAND_TYPE_SWAMP )
	filter:SetController( player )
	filter:NotTargetted()
	if (filter:CountStopAt( 1 ) == 1) then
		n = n + 1
	end
	return n
end

PermanentTypeCountInZone = function(zone)
-- returns the number of permanent types in zone
	local n = 0
	local filter = Object():GetFilter()
	filter:Clear()
	filter:SetZone( zone )
	filter:AddCardType( CARD_TYPE_ARTIFACT )
	filter:NotTargetted()
	if (filter:CountStopAt( 1 ) == 1) then
		n = n + 1
	end
	filter:Clear()
	filter:SetZone( zone )
	filter:AddCardType( CARD_TYPE_CREATURE )
	filter:NotTargetted()
	if (filter:CountStopAt( 1 ) == 1) then
		n = n + 1
	end
	filter:Clear()
	filter:SetZone( zone )
	filter:AddCardType( CARD_TYPE_ENCHANTMENT )
	filter:NotTargetted()
	if (filter:CountStopAt( 1 ) == 1) then
		n = n + 1
	end
	filter:Clear()
	filter:SetZone( zone )
	filter:AddCardType( CARD_TYPE_INSTANT )
	filter:NotTargetted()
	if (filter:CountStopAt( 1 ) == 1) then
		n = n + 1
	end
	filter:Clear()
	filter:SetZone( zone )
	filter:AddCardType( CARD_TYPE_LAND )
	filter:NotTargetted()
	if (filter:CountStopAt( 1 ) == 1) then
		n = n + 1
	end
	filter:Clear()
	filter:SetZone( zone )
	filter:AddCardType( CARD_TYPE_PLANESWALKER )
	filter:NotTargetted()
	if (filter:CountStopAt( 1 ) == 1) then
		n = n + 1
	end
	filter:Clear()
	filter:SetZone( zone )
	filter:AddCardType( CARD_TYPE_SORCERY )
	filter:NotTargetted()
	if (filter:CountStopAt( 1 ) == 1) then
		n = n + 1
	end
	filter:Clear()
	filter:SetZone( zone )
	filter:AddCardType( CARD_TYPE_TRIBAL )
	filter:NotTargetted()
	if (filter:CountStopAt( 1 ) == 1) then
		n = n + 1
	end
	return n
end

SkipNextTurn = function(player)
-- adds a turn to the teams the specified player doesn't belong to
	local currteam = 0
	local team = nil
	for i=0,MTG():GetNumberOfTeams()-1 do
		team = MTG():GetNthTeam( i )
		if team == MTG():GetCurrentTeam() then
			currteam = i
		end
	end
	local index = currteam
	for i=0,MTG():GetNumberOfTeams()-1 do
		if index < 0 then
			index = MTG():GetNumberOfTeams()-1
		end
		local team = MTG():GetNthTeam( index )
		if team ~= player:GetTeam() then
			team:TakeExtraTurn()
		end
		index = index - 1
	end
end

GetNextPlayingTeam = function()
-- returns the team that plays the next turn
	local currteam = 0
	for i=0,MTG():GetNumberOfTeams()-1 do
		if MTG():GetNthTeam( i ) == MTG():GetCurrentTeam() then
			currteam = i
		end
	end
        local nextteam = currteam-1
	if nextteam < 0 then
		nextteam = MTG():GetNumberOfTeams()-1
	end
	return MTG():GetNthTeam( nextteam )
end
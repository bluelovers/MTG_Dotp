-- Set IT_ES_ORDER to 1 if you use DotP2013 in Italian or Spanish, this way the added sub-types will have a more familiar ordering
IT_ES_ORDER = 0

COMPARTMENT_ID_TRANSFORMED = 5555
COMPARTMENT_ID_TRANSFORM_CHEST = 5556

IS_NOT_TRANSFORMED = 1
IS_TRANSFORMED = 2

ImmerwolfTest = function(object)
-- returns true if object cannot transform because of Immerwolf's ability
	local filter = Object():GetFilter()
	filter:Clear()
	filter:AddCardName( "IMMERWOLF" )
	filter:SetController( object:GetController() )
	filter:SetZone( ZONE_IN_PLAY )
	return filter:CountStopAt( 1 ) == 1 and
	object:GetSubType():Test( CREATURE_TYPE_WEREWOLF ) ~= 0 and object:GetSubType():Test( CREATURE_TYPE_HUMAN ) == 0
end

GetTransformData_Step1 = function(cardname)
-- spawns the token called cardname, then creates a pointer to it
	local backface = MTG():ObtainToken( cardname, EffectController() )
	if backface ~= nil then
		backface:PutIntoPlay( EffectController() )
		EffectDC():Set_CardPtr( COMPARTMENT_ID_TRANSFORM_CHEST, backface )
		EffectDC():Protect_CardPtr( COMPARTMENT_ID_TRANSFORM_CHEST )
	end
end

GetTransformData_Step2 = function()
-- stores the copiable values, then exiles the token
	local backface = EffectDC():Get_CardPtr( COMPARTMENT_ID_TRANSFORM_CHEST )
	if backface ~= nil then
		backface:StoreCopiableValues( ObjectDC():Make_Chest(COMPARTMENT_ID_TRANSFORM_CHEST) )
		backface:RemoveFromGame()
		ObjectDC():Set_Int( COMPARTMENT_ID_TRANSFORMED, IS_NOT_TRANSFORMED )
	end
end

Transform = function(object)
-- switches the register that allows object to transform
	if object:GetDataChest() ~= nil and ( not ImmerwolfTest(object) ) then
		local total = IS_NOT_TRANSFORMED + IS_TRANSFORMED
		object:GetDataChest():Set_Int( COMPARTMENT_ID_TRANSFORMED, total-object:GetDataChest():Get_Int(COMPARTMENT_ID_TRANSFORMED) )
	end
end

IsTransformed = function(object)
-- returns true if the register that allows object to transform is set to 1
	if object:GetDataChest() ~= nil then
		return object:GetDataChest():Get_Int( COMPARTMENT_ID_TRANSFORMED ) == IS_TRANSFORMED
	end
	return false
end

CanTransform = function(object)
-- returns true if object is actually a transform card
	if object:GetDataChest() ~= nil then
		return object:GetDataChest():Get_Int( COMPARTMENT_ID_TRANSFORMED ) == IS_NOT_TRANSFORMED or
		object:GetDataChest():Get_Int( COMPARTMENT_ID_TRANSFORMED ) == IS_TRANSFORMED
	end
	return false
end

ApplyTransformation = function(n_types, n_subtypes, ...)
-- sets EffectSource's characteristics so that it appears transformed. it adds n_types types and n_subtypes sub-types.
	if ObjectDC():Get_Chest( COMPARTMENT_ID_TRANSFORM_CHEST ) ~= nil then
		local source = EffectSource()
		source:UseCopiableValues( ObjectDC():Get_Chest(COMPARTMENT_ID_TRANSFORM_CHEST) )
		if n_types > 0 or n_subtypes > 0 then
			local characteristics = source:GetCurrentCharacteristics()
			if n_types > 0 then
				for i=1,n_types do
					characteristics:CardType_GetWritable( source ):Add( arg[i], source )
				end
			end
			if n_subtypes > 0 then
				local subtypes_start = n_types+1
				local subtypes_end = n_types+n_subtypes
				if IT_ES_ORDER == 1 then
					for i=subtypes_end,subtypes_start,-1 do
						characteristics:SubType_GetWritable( source ):Add( arg[i], source )
					end
				else
					for i=subtypes_start,subtypes_end do
						characteristics:SubType_GetWritable( source ):Add( arg[i], source )
					end
				end
			end
		end
	end
end

SomeoneCastNSpells = function(number)
-- returns true if a player has cast at least number spells this turn
	local num_players = MTG():GetNumberOfPlayers()
	for i=0,num_players-1 do
		local player = MTG():GetNthPlayer(i)
		if player ~= nil then
			if MTG():Interrogate_SpellsCastThisTurn(player, number) == number then
				return true
			end
		end
	end
	return false
end

NobodyCastSpells = function()
-- returns true if nobody has cast spells this turn
	local num_players = MTG():GetNumberOfPlayers()
	for i=0,num_players-1 do
		local player = MTG():GetNthPlayer(i)
		if player ~= nil then
			if MTG():Interrogate_SpellsCastThisTurn(player, 1) == 1 then
				return false
			end
		end
	end
	return true
end
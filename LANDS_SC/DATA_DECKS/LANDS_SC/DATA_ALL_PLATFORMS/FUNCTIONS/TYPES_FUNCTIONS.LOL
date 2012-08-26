AddCardTypeTo = function(type, object)
-- adds the selected card type to object
	object:GetCurrentCharacteristics():CardType_GetWritable(object):Add(type, object)
end

AddSubTypeTo = function(type, object)
-- adds the selected sub-type to object
	object:GetCurrentCharacteristics():SubType_GetWritable(object):Add(type, object)
end

LoseSubTypes = function(object)
-- makes object lose all sub-types
	object:GetCurrentCharacteristics():SubType_GetWritable(object):Clear()
end

LoseCreatureTypes = function(object)
-- makes object lose all creature sub-types (preserving the other ones, if any)
	local ncst_array = {}
	local ncst_count = 0
	for i=ARTIFACT_TYPE_CONTRAPTION,ARTIFACT_TYPE_FORTIFICATION do
		if object:GetSubType():Test(i) ~= 0 then
			ncst_array[ncst_count] = i
			ncst_count = ncst_count + 1
		end
	end
	for i=ENCHANTMENT_TYPE_AURA,ENCHANTMENT_TYPE_CURSE do
		if object:GetSubType():Test(i) ~= 0 then
			ncst_array[ncst_count] = i
			ncst_count = ncst_count + 1
		end
	end
	for i=LAND_TYPE_DESERT,LAND_TYPE_URZAS do
		if object:GetSubType():Test(i) ~= 0 then
			ncst_array[ncst_count] = i
			ncst_count = ncst_count + 1
		end
	end
	LoseSubTypes(object)
	for i=0,ncst_count-1 do
		AddSubTypeTo(ncst_array[i], object)
	end
end
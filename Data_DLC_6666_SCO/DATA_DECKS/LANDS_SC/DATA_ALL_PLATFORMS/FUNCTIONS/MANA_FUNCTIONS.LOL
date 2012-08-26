ColourToString = function(colour)
-- converts colour constants (i.e. COLOUR_RED) to mana strings (i.e. "{R}")
	local mana_table = {"{W}", "{U}", "{B}", "{R}", "{G}"}
	return mana_table[colour]
end

ManaString = function(colour, amount)
-- generates a mana string of the selected colour and amount
	local string = ""
	if amount == 0 then
		return "{0}"
	end
	for i=1,amount do
		string = string..ColourToString(colour)
	end
	return string
end

GetCostOfColour = function(object, colour)
-- returns the amount of mana of the selected colour in object's cost
	local filter = Object():GetFilter()
	filter:Clear()
	filter:NotTargetted()
	filter:SetCardInstance(object)
	return filter:ChromaCount(colour)
end

GetCostStringOfColour = function(object, colour)
-- same as GetCostOfColour, but it generates a string (useful for TapLand, CanAfford, etc.)
	local amount = GetCostOfColour(object, colour)
	return ManaString(colour, amount)
end

GetCostString = function(object)
-- returns the full mana cost string but it doesn't work with hybrid or phyrexian mana, for obvious reasons
	local cmc = object:GetConvertedManaCost()
	if cmc > 0 then
		local string = ""
		local coloured_mana = 0
		for i=1,5 do
			local amount = GetCostOfColour(object, i)
			coloured_mana = coloured_mana + amount
			if amount > 0 then
				string = string..GetCostStringOfColour(object, i)
			end
		end
		if cmc > coloured_mana then
			string = "{"..(cmc-coloured_mana).."}"..string
		end
		return string
	else
		return "{0}"
	end
end

GetTotalManaOfColour = function(player, colour)
-- returns the maximum amount of mana of the selected colour that player can afford
	local total = player:GetTotalMana()
	local string = ""
	for i=0,total do
		string = string..ColourToString(colour)
		if player:CanAfford(string) == 0 then
			return i
		end
	end
	return 0
end
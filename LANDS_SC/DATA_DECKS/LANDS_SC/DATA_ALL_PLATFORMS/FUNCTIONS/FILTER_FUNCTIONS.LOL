FilterPermanents = function()
-- filters permanents
	local filter = Object():GetFilter()
	filter:AddCardType( CARD_TYPE_ARTIFACT )
	filter:AddCardType( CARD_TYPE_ENCHANTMENT )
	filter:AddCardType( CARD_TYPE_LAND )
	filter:AddCardType( CARD_TYPE_CREATURE )
	filter:AddCardType( CARD_TYPE_PLANESWALKER )
end

FilterMultiColoured = function()
-- filters multicolored cards
	local filter = Object():GetFilter()
	for i=1,5 do
		filter:AddColour(i)
	end
	filter:SetMonoColoured( false )
end
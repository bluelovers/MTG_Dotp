IsEquipped = function( source )
	local filter = source:GetFilter()
    	filter:Clear()
    	filter:AddSubType( ARTIFACT_TYPE_EQUIPMENT )
    	filter:SetZone( ZONE_IN_PLAY )
    	filter:SetParent( source )
    	filter:NotTargetted()
	return filter:CountStopAt(1) == 1
end
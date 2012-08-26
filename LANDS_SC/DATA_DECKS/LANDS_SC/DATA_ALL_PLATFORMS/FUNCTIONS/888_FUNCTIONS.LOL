TopCardHasKinshipWith = function( source )
   if (source:GetController():Library_Count() > 0) then
      local filter = source:GetFilter()
      filter:Clear()
      filter:SetZone( ZONE_LIBRARY )
      filter:SetPlayer( source:GetController() )
      filter:SetSubTypes( source:GetSubType() )
      filter:AddExtra( FILTER_EXTRA_ANY_SUB_TYPE )
      filter:SetPortion( 1 )
      return (filter:CountStopAt( 1 ) == 1)
   else
      return false
   end
end
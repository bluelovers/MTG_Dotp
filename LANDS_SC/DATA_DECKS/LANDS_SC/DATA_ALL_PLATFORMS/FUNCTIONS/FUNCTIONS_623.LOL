GetNextCurrentTeam = function()
  local num_next = 0
  local num_players = MTG():GetNumberOfPlayers()
  for i=0,num_players-1 do      
  	local player = MTG():GetNthPlayer( i ) 
  	if player ~= nil and player:GetTeam() == MTG():GetCurrentTeam() then 
		  if i + 1 < num_players then
        num_next = i+1
      else
        num_next = 0
	  	end
	  end
	end
	return MTG():GetNthPlayer( num_next ):GetTeam()
end

PermanentColour = function(object)
  local colour = 0
  for i=1,5 do      
  	if object:GetColour():Test( i ) ~= 0 then 
		  colour = colour + 1
	  end
	end
  return colour
end

AnotherMulticoloredPermanentYouControl = function(object)
  local mun_mp = 0
  local filter = Object():GetFilter()
  filter:Clear()
  filter:NotTargetted()
  filter:SetZone( ZONE_IN_PLAY )
  filter:SetCardInstance( object )
  filter:AddExtra( FILTER_EXTRA_FLIP_CARD_INSTANCE )
  filter:SetController( object:GetController() )
  local total = filter:EvaluateObjects()
  if total > 0 then
    for i=0,total-1 do
      local card = filter:GetNthEvaluatedObject(i)    			
      if card ~= nil then			
    	  if PermanentColour(card) > 1 then	
    	    mun_mp = mun_mp + 1
    	  end
      end
    end    		
  end 
  return mun_mp
end

OddEvenNumbers = function(chest)
  local round_up = math.ceil(chest/2)
  local round_down = math.floor(chest/2)
  return round_up - round_down
end

FlipCoin = function()
  local chest = math.random(0, 1)
  return chest
end

FlipChance = function(player)
  local filter = Object():GetFilter()
  filter:Clear()
  filter:NotTargetted()
  filter:SetZone( ZONE_IN_PLAY )
  filter:SetController( player )
  filter:AddCardName( "KRARKS_THUMB" )
  local chance = filter:Count() + 1
  return chance
end

CountLandInHand = function(player)
  Object():GetFilter():Clear()
  Object():GetFilter():SetZone(ZONE_HAND)
  Object():GetFilter():AddCardType( CARD_TYPE_LAND ) 
  Object():GetFilter():SetPlayer(player)
  Object():GetFilter():NotTargetted()
  return Object():GetFilter():Count()
end
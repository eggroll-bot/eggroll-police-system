include( "shared.lua" )

function SWEP:DrawWorldModel( )
end

function SWEP:PreDrawViewModel( )
	return true
end

function SWEP:OwnerChanged( )
	if IsValid( self:GetOwner( ) ) then -- Make sure it was picked up and not dropped.
		self:Deploy( )
	end
end

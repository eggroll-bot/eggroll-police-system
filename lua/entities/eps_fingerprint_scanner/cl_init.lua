include( "shared.lua" )

function ENT:Initialize( )
	self:SetPoseParameter( "switch", 1 )
	self:InvalidateBoneCache( )
end

function ENT:Draw( )
	self:DrawModel( )
end

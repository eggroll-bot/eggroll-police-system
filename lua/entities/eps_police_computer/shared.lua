ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Police Computer"
ENT.Category = "Eggroll Police System"
ENT.Author = "TheAsian EggrollMaker"
ENT.Contact = "theasianeggrollmaker@gmail.com"
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Spawnable = true

function ENT:SetupDataTables( )
	self:NetworkVar( "Entity", 0, "ActiveUser" )
end

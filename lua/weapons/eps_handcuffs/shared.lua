SWEP.PrintName = "Handcuffs"
SWEP.Author = "TheAsian EggrollMaker"
SWEP.Contact = "theasianeggrollmaker@gmail.com"
SWEP.Purpose = "To handcuff suspects."
SWEP.Instructions = "Left Click: Handcuff suspect.\nRight Click: Release handcuffed suspect."

SWEP.Base = "weapon_base"

SWEP.UseHands = true

SWEP.Category = "Eggroll's Police System"
SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.Spawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false

function SWEP:Initialize( )
	self:SetHoldType( "normal" )
end

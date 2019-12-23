include( "shared.lua" )

function SWEP:DrawWorldModel( )
end

function SWEP:PreDrawViewModel( )
	return true
end

function SWEP:DrawHUD( )
	local handcuff_finish_time = self:GetNWInt( "FinishHandcuffingTime" )

	if handcuff_finish_time == 0 then -- Not handcuffing anyone.
		return
	end

	local scr_w = ScrW( )
	local scr_h = ScrH( )
	local x, y, w, h = scr_w / 2 - scr_w / 10, scr_h / 2 - scr_h / 30 - 60, scr_w / 5, scr_h / 15
	local time_left = handcuff_finish_time - CurTime( )
	local handcuff_finish_percentage = ( EggrollPoliceSystem.Config.TimeToHandcuff - time_left ) / EggrollPoliceSystem.Config.TimeToHandcuff

	if handcuff_finish_percentage <= 1 then -- Accounting for network delays.
		draw.RoundedBox( 8, x, y, w, h, Color( 10, 10, 10, 200 ) )
		draw.RoundedBox( 8, x + 5, y + 5, ( w - 10 ) * handcuff_finish_percentage, h - 10, Color( 0, 180, 0 ) )
		draw.SimpleText( "Handcuffing...", "CloseCaption_Normal", scr_w / 2, scr_h / 2 - 60, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
end

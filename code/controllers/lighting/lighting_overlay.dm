/atom/movable/lighting_overlay
	icon = 'icons/effects/effects.dmi'
	icon_state = "white"
	blend_mode = BLEND_MULTIPLY

	color = "#000000"

	invisibility = INVISIBILITY_LIGHTING
	layer = 10
	mouse_opacity = 0

	anchored = 1
	simulated = 0

	var/lumcount = 0

	var/col_lumcount_r = 0
	var/col_lumcount_g = 0
	var/col_lumcount_b = 0
	var/col_light_sources = 0

/atom/movable/lighting_overlay/New()
	..()
	verbs.Cut()

/atom/movable/lighting_overlay/proc/update_lumcount(lum, lumcount_r, lumcount_g, lumcount_b, removing = 0)
	lumcount = max(0, lumcount + lum)
	if(!removing)
		col_lumcount_r += lumcount_r
		col_lumcount_g += lumcount_g
		col_lumcount_b += lumcount_b
	else
		col_lumcount_r -= lumcount_r
		col_lumcount_g -= lumcount_g
		col_lumcount_b -= lumcount_b

	var/light_scale = min(lumcount, lighting_controller.lighting_states) / lighting_controller.lighting_states
	if(col_light_sources)
		color = rgb(min(1, col_lumcount_r / lighting_controller.lighting_states) * 255,
		            min(1, col_lumcount_g / lighting_controller.lighting_states) * 255,
		            min(1, col_lumcount_b / lighting_controller.lighting_states) * 255)
	else
		color = "#000000"
	alpha = 255 - light_scale * 255

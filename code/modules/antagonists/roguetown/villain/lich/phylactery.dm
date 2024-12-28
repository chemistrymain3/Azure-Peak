/obj/item/phylactery
	name = "phylactery"
	desc = "An object, shining with unholy power. Whatever it's for, it's definitely nothing good. It looks fragile. Throwing it will likely break it."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "soulstone"
	item_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	layer = HIGH_OBJ_LAYER
	w_class = WEIGHT_CLASS_TINY

	var/datum/antagonist/lich/possessor

/obj/item/phylactery/Initialize()
	. = ..()
	filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))

/obj/item/phylactery/proc/be_consumed(timer)
	var/offset = prob(50) ? -2 : 2
	animate(src, pixel_x = pixel_x + offset, time = 0.2, loop = -1) //start shaking
	visible_message(span_warning("[src] begins to glow and shake violently!"))
	spawn(timer)
		possessor.owner.current.forceMove(get_turf(src))
		possessor.rise_anew()
		qdel(src)

/obj/item/phylactery/proc/smash()
	var/offset = prob(50) ? -2 : 2
	animate(src, pixel_x = pixel_x + offset, time = 0.2, loop = -1) //start shaking
	visible_message(span_warning("[src] begins to glow and shake violently! RUN!"))
	sleep(10)
	explosion(src, light_impact_range = 1, flame_range = 3, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
	qdel(src)

/obj/item/phylactery/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	smash()

/obj/item/phylactery/attack_self(mob/user)
	user.visible_message(span_danger("[user] cracks [src] in their hands!"), \
						 span_danger("I crack [src] in my bare hands, and it starts to buzz like an angry bee."))
	smash()

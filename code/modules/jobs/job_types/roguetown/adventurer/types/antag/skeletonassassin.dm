/datum/advclass/skeletonassassin // Barely armored skeleton rogue. Good climbing, good speed, daggers, and bad invisibility.
	name = "Skeleton Assassin"
	tutorial = "In lyfe, you were nobility- one of many treacherous sycophants, jockeying for power and status. In death, blue blood no longer flows through your veins- but your propensity for backstabbing remains."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/skeleton_assassin
	category_tags = list(CTAG_SKELETON)

/datum/outfit/job/roguetown/greater_skeleton/skeleton_assassin/pre_equip(mob/living/carbon/human/H) //todo- see about drip for them. 
	..()
	shoes = /obj/item/clothing/shoes/roguetown/boots
	H.mind.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/climbing, 6, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/traps, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 5, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/stealing, 5, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/lockpicking, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/tracking, 3, TRUE)
	pants = /obj/item/clothing/under/roguetown/trou/leather/mourning
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	gloves = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves
	mask = /obj/item/clothing/mask/rogue/facemask
	head = /obj/item/clothing/head/roguetown/duelhat
	belt = /obj/item/storage/belt/rogue/leather/black
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	backl = /obj/item/storage/backpack/rogue/satchel/black
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
	backpack_contents = list(
						/obj/item/lockpickring/mundane)
	r_hand = /obj/item/reagent_containers/glass/cup/golden/poison //tempting goblet
	H.STASTR = 11
	H.STASPD = 14 
	H.STACON = 5 //fragile
	H.STAEND = 15
	H.STAINT = 1
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/invisibility/bad)

/obj/effect/proc_holder/spell/invoked/invisibility/bad
	name = "Death Cloak"
	overlay_state = "invisibility"
	desc = "Make another (or yourself) invisible for five seconds."

/obj/effect/proc_holder/spell/invoked/invisibility/bad/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.anti_magic_check(TRUE, TRUE))
			return FALSE
		target.visible_message(span_warning("[target] starts to fade into thin air!"), span_notice("You start to become invisible!"))
		animate(target, alpha = 0, time = 1 SECONDS, easing = EASE_IN)
		target.mob_timers[MT_INVISIBILITY] = world.time + 5 SECONDS
		addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, update_sneak_invis), TRUE), 5 SECONDS)
		addtimer(CALLBACK(target, TYPE_PROC_REF(/atom/movable, visible_message), span_warning("[target] fades back into view."), span_notice("You become visible again.")), 15 SECONDS)
		return TRUE
	revert_cast()
	return FALSE

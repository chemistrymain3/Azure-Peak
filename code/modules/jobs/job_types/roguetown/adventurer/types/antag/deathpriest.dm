/datum/advclass/deathpriest //skeletal mage. supportive.
	name = "Death Priest"
	tutorial = "You once worshipped Death, as a loyal follower of Necra. Now, you desecrate it- twisted into Zizo's service at the hand of the lych, you serve as the arcyne support of their army. Mend bone. Raise the dead. Castigate the living."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/death_priest
	maximum_possible_slots = 2
	category_tags = list(CTAG_SKELETON)

/datum/outfit/job/roguetown/greater_skeleton/death_priest/pre_equip(mob/living/carbon/human/H) //todo- see about drip for them. maybe we can give them bronze shit or someth
	..()
	head = /obj/item/clothing/head/roguetown/necromhood
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/necromancer
	belt = /obj/item/storage/belt/rogue/leather/rope
	backl = /obj/item/storage/backpack/rogue/satchel/black
	mask = /obj/item/clothing/mask/rogue/skullmask
	r_hand = /obj/item/rogueweapon/woodstaff
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/alchemy, 3, TRUE)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/bonechill/weak)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_lesser_undead)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/sickness)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/scaboroustouch)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/profane)

/obj/effect/proc_holder/spell/targeted/touch/scaboroustouch
	name = "Scaborous Touch"
	desc = "Fester open wounds on a target. Doing it again will turn the wound to Rot."
	clothes_req = FALSE
	drawmessage = "I utter the lesser secrets of Zaribel, and sickness brims on my hand..."
	dropmessage = "I release my focus, and death recedes."
	school = "transmutation"
	overlay_state = "raiseskele"
	sound = list('sound/misc/portal_enter.ogg')
	chargedrain = 0
	chargetime = 0
	charge_max = 10 SECONDS //cooldown
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	hand_path = /obj/item/melee/touch_attack/scaboroustouch

/obj/item/melee/touch_attack/scaboroustouch
	name = "\improper scaborous touch"
	desc = "Touch a creature to infect their open wounds. Touching someone already afflicted will instead spread the Rot."
	catchphrase = "Nilad ur'sht!"
	possible_item_intents = list(INTENT_HELP)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "pulling"
	icon_state = "grabbing_greyscale"
	color = "#004212"

/obj/item/melee/touch_attack/scaboroustouch/attack_self()
	attached_spell.remove_hand()

/obj/item/melee/touch_attack/scaboroustouch/afterattack(mob/target, mob/living/carbon/user, proximity)
	if(isliving(target))
		if(HAS_TRAIT(src, TRAIT_ZOMBIE_IMMUNE) || (target.mob_biotypes & MOB_UNDEAD))
			user.visible_message(span_danger("[user] draws a glyph in the air and touches [target], but nothing happens."))
			return
		if(!target.has_status_effect(/datum/status_effect/debuff/afflicted))
			target.apply_status_effect(/datum/status_effect/debuff/afflicted)
			if(iscarbon(target))
				var/mob/living/carbon/M = target
				M.reagents.add_reagent(/datum/reagent/infection/major/putrescent, 8) //gives them a poison that applies afflicted- purged with cure rot
			user.visible_message(span_crit("[user] touches [target] with an empty hand, and their skin putrefies instantly!"))
			to_chat(target, span_userdanger("My flesh peels away at a touch! IT HURTS!"))
			target.emote("painscream") // hurts
			target.Immobilize(0.5)
			attached_spell.remove_hand()
		else
			
	return

/obj/effect/proc_holder/spell/invoked/chanted/hollowvessel
	name = "Hollow Vessel"
	desc = "Chant a profaned sacrament of Necra, weakening the living and preparing the body for reanimation. Moving will disrupt the ritual."
	clothes_req = FALSE
	overlay_state = "raisedead"
	associated_skill = /datum/skill/magic/arcane
	chargedloop = /datum/looping_sound/invokeascendant
	cast_without_targets = TRUE
	var/list/weakening_lines = list(
		"Shadows clutch at my vision, closing in...",
		"The dead raising the dead raising the dead raising the dead raising the-",
		"I hear the screaming of the carriageman, and then silence. My body feels like it will sink into the earth...",
		"I see myself, on my deathbed. I am alone. My eyesockets are alight- NO!",
		"ZIZOZIZOZIZOZIZOZIZOZIZOZIZO-"
	)

/obj/effect/proc_holder/spell/invoked/chanted/hollowvessel/chant_effects(chant_amount, mob/living/carbon/human/user)
	. = ..()
	var/list/living_to_weaken = list()
	for (var/mob/living/carbon/human/L in view(src, 7))
		if(istype(L.wear_neck, /obj/item/clothing/neck/roguetown/psicross/necra))
			if(chant_amount == 1)
				to_chat(user, span_danger("The amulet glows, and the spell fails to take shape on [L]!"))
			continue
		if(target.anti_magic_check(TRUE, TRUE) || HAS_TRAIT(L, TRAIT_ANTIMAGIC) || L.mob_biotypes & MOB_UNDEAD)
			continue
		else
			living_to_weaken += L
	if (LAZYLEN(living_to_weaken))
			user.visible_message(span_crit("[user] begins to chant in an abhorrent language, and-"), span_notice("I begin to chant the rite of hollowing, and flesh festers and ruins around me. I must stay still to maintain the ritual."))
			for(var/mob/living/victim in living_to_weaken)
				victim.apply_status_effect(/datum/status_effect/hollowed, user)
				victim.rogfat_add(15)
				victim.adjustFireLoss(20)
				victim.emote("agony")

	else if
		to_chat(user, span_notice("I begin the rite of hollowing, but there are no living around me. Am I stupid?"))
	
	/datum/status_effect/debuff/hollowed
	id = "hollowed"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/hollowed
	effectedstats = list( "constitution" = -4, "fortune" = -4) //4 is death, after all
	duration = 30 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	examine_text = "SUBJECTPRONOUN withers under an aura of evil magic. Healing them is impossible."
	var/datum/weakref/debuffer
	var/range = 8
	var/list/weakening_lines = list(
		"Shadows clutch at my vision, closing in...",
		"The dead raising the dead raising the dead raising the dead raising the-",
		"I hear the screaming of the carriageman, and then silence. My body feels like it will sink into the earth...",
		"I see myself, on my deathbed. I am alone. My eyesockets are alight- NO!",
		"ZIZOZIZOZIZOZIZOZIZOZIZOZIZO-"
	)

/atom/movable/screen/alert/status_effect/debuff/hollowed
	name = "Hollowing"
	desc = "I am being unmade by evil sorcery, body and soul! I should flee the source!"
	icon_state = "stressvb"


/datum/status_effect/debuff/hollowed/on_creation(mob/living/new_owner, mob/living/caster)
	if (caster)
		debuffer = WEAKREF(caster)
	return ..()

/datum/status_effect/debuff/hollowed/on_apply()
	..()
	owner.add_client_colour(/datum/client_colour/blackandevil)
	if(owner.wCount.len > 0)
		playsound(owner, "smallslash", 100, TRUE, -1)
		to_chat(owner, span_danger("All my wounds are pried open by terrible magic!"))
		wound.sew_progress = 0
	sleep(14)
	to_chat(owner, span_gamedeadsay(pick(weakening_lines)))


/datum/status_effect/debuff/hollowed/on_remove()
	..()
	owner.remove_client_colour(/datum/client_colour/blackandevil)

/datum/status_effect/debuff/hollowed/tick()
	if (prob(5))
		to_chat(owner, span_gamedeadsay(pick(weakening_lines)))
	if(owner.wCount.len > 0)
		for(var/datum/wound/wound as anything in owner.get_wounds())
			wound.bleed_rate = min(wound.bleed_rate*1.1, initial(wound.bleed_rate)*2)
			wound.sew_progress = 0
			wound.woundpain = min(wound.woundpain*1.1, initial(wound.woundpain)*2)

/datum/status_effect/debuff/hollowed/process()
	var/mob/living/our_debuffer = debuffer.resolve()
	if (get_dist(our_debuffer, owner) > range)
		to_chat(owner, span_notice("I've escaped the evil magic!"))
		qdel(src)

			

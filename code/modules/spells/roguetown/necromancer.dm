/obj/effect/proc_holder/spell/invoked/bonechill
	name = "Bone Chill"
	overlay_state = "rituos"
	releasedrain = 30
	chargetime = 5
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = /datum/looping_sound/invokeascendant
	sound = 'sound/magic/whiteflame.ogg'
	associated_skill = /datum/skill/magic/arcane
	antimagic_allowed = TRUE
	charge_max = 30 SECONDS
	miracle = FALSE

/obj/effect/proc_holder/spell/invoked/bonechill/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.mob_biotypes & MOB_UNDEAD) //positive energy harms the undead)
			target.adjustBruteLoss(-100, updating_health = FALSE, forced = TRUE)
			target.adjustFireLoss(-100, updating_health = FALSE, forced = TRUE)
			target.heal_wounds(50, 50) //Heal every wound that is not permanent
			target.visible_message(span_danger("[target] reforms under the vile energy!"), span_notice("I'm remade by dark magic!"))
			return TRUE
		target.visible_message(span_info("Necrotic energy floods over [target]!"), span_userdanger("I feel colder as the dark energy floods into me!"))
		if(iscarbon(target))
			target.apply_status_effect(/datum/status_effect/bonechill)
			target.adjustBruteLoss(40)
		else
			target.adjustBruteLoss(20)
		return TRUE
	return FALSE

/obj/effect/proc_holder/spell/invoked/bonechill/weak
	name = "Lesser Bonechill"
	charge_max = 15 SECONDS

/obj/effect/proc_holder/spell/invoked/bonechill/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.mob_biotypes & MOB_UNDEAD) //positive energy harms the undead
			var/obj/item/bodypart/affecting = target.get_bodypart(check_zone(user.zone_selected))
			if(affecting)
				if(affecting.heal_damage(50, 50))
					target.update_damage_overlays()
				if(affecting.heal_wounds(50))
					target.update_damage_overlays()
			target.visible_message(span_danger("[target] reforms under the vile energy!"), span_notice("I'm remade by dark magic!"))
			return TRUE
		target.visible_message(span_info("Necrotic energy floods over [target]!"), span_userdanger("I feel colder as the dark energy floods into me!"))
		if(iscarbon(target))
			target.apply_status_effect(/datum/status_effect/debuff/chilled)
			target.adjustBruteLoss(20)
		else
			target.adjustBruteLoss(20)
		return TRUE
	return FALSE



/obj/effect/proc_holder/spell/invoked/eyebite
	name = "Eyebite"
	overlay_state = "raiseskele"
	releasedrain = 30
	chargetime = 15
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = null
	req_items = list(/obj/item/clothing/suit/roguetown/shirt/robe/necromancer)
	sound = 'sound/items/beartrap.ogg'
	associated_skill = /datum/skill/magic/arcane
	antimagic_allowed = TRUE
	charge_max = 15 SECONDS
	miracle = FALSE

/obj/effect/proc_holder/spell/invoked/eyebite/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/carbon/target = targets[1]
		target.visible_message(span_info("A loud crunching sound has come from [target]!"), span_userdanger("I feel arcane teeth biting into my eyes!"))
		target.adjustBruteLoss(30)
		target.blind_eyes(2)
		target.blur_eyes(10)
		return TRUE
	return FALSE

/obj/effect/proc_holder/spell/invoked/create_skeleton
	name = "Create Greater Skeleton"
	desc = ""
	clothes_req = FALSE
	range = 7
	overlay_state = "animate"
	sound = list('sound/magic/magnet.ogg')
	releasedrain = 40
	chargetime = 30
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	charge_max = 30 SECONDS

/obj/effect/proc_holder/spell/invoked/create_skeleton/cast(list/targets, mob/living/carbon/human/user)
	. = ..()
	var/turf/T = get_turf(targets[1])
	if(isopenturf(T))
		var/mob/living/carbon/human/target = new /mob/living/carbon/human/species/skeleton/no_equipment(T)
		var/list/candidates = pollCandidatesForMob("Do you want to play as a Necromancer's skeleton?", ROLE_NECRO_SKELETON, null, null, 100, target, POLL_IGNORE_NECROMANCER_SKELETON)
		if(LAZYLEN(candidates))
			var/mob/C = pick(candidates)
			if(istype(C,/mob/dead/new_player))
				var/mob/dead/new_player/N = C
				N.close_spawn_windows()
			target.key = C.key
			target.visible_message(span_warning("[target]'s eyes light up with an eerie glow!"),runechat_message = TRUE)
			target.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser)
			target.equipOutfit(/datum/outfit/job/roguetown/greater_skeleton)
			var/datum/antagonist/lich/lichman = user.mind.has_antag_datum(/datum/antagonist/lich)
			var/datum/antagonist/skeleton/new_skele = new /datum/antagonist/skeleton()
			if(lichman) //is this guy a lich?
				new_skele.lich_lord = lichman
				user.minions += new_skele //create a list of all summons
				target.mind.add_antag_datum(new_skele) // assign the skeleton antag datum
		else
			target.visible_message(span_warning("[target]'s form crumbles into dust."))
			qdel(target)
			revert_cast()
		return TRUE
	to_chat(user, span_warning("The targeted location is blocked. My summon fails to come forth."))
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/raise_lesser_undead
	name = "Raise Lesser Undead"
	desc = ""
	clothes_req = FALSE
	overlay_state = "animate"
	range = 7
	sound = list('sound/magic/magnet.ogg')
	releasedrain = 40
	chargetime = 30
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	charge_max = 30 SECONDS
	var/cabal_affine = FALSE

/obj/effect/proc_holder/spell/invoked/raise_lesser_undead/cast(list/targets, mob/living/user)
	. = ..()
	var/turf/T = get_turf(targets[1])
	var/skeleton_roll = rand(1,100)
	if(isopenturf(T))
		switch(skeleton_roll)
			if(1 to 20)
				new /mob/living/simple_animal/hostile/rogue/skeleton/axe(T, user, cabal_affine)
			if(21 to 40)
				new /mob/living/simple_animal/hostile/rogue/skeleton/spear(T, user, cabal_affine)
			if(41 to 60)
				new /mob/living/simple_animal/hostile/rogue/skeleton/guard(T, user, cabal_affine)
			if(61 to 80)
				new /mob/living/simple_animal/hostile/rogue/skeleton/bow(T, user, cabal_affine)
			if(81 to 100)
				new /mob/living/simple_animal/hostile/rogue/skeleton(T, user, cabal_affine)
		return TRUE
	else
		to_chat(user, span_warning("The targeted location is blocked. My summon fails to come forth."))
		return FALSE

/obj/effect/proc_holder/spell/invoked/raise_dead
	name = "Raise Dead"
	cost = 1
	desc = ""
	clothes_req = FALSE
	range = 7
	overlay_state = "raiseskele"
	sound = list('sound/magic/magnet.ogg')
	releasedrain = 40
	chargetime = 2 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	charge_max = 2 SECONDS

/obj/effect/proc_holder/spell/invoked/raise_zombie/cast(list/targets, mob/living/carbon/human/user)
	. = ..()

	user.say("Hygf'akni'kthakchratah!")
	if(!("undead" in user.faction))
		user.faction |= "undead"

	var/mob/living/carbon/human/target = targets[1]

	if(!target || !istype(target, /mob/living/carbon/human))
		to_chat(user, span_warning("I need to cast this spell on a corpse."))
		return FALSE

	if(istype(target, /mob/living/carbon/human/species/goblin))
		to_chat(user, span_warning("I cannot raise goblins."))
		return FALSE
	
	if(target.stat != DEAD)
		to_chat(user, span_warning("Raising the living is NOT Zizo's domain."))
		return FALSE

	var/obj/item/bodypart/target_head = target.get_bodypart(BODY_ZONE_HEAD)
	if(!target_head)
		to_chat(user, span_warning("This corpse is headless."))
		return FALSE

	var/offer_refused = FALSE

	target.visible_message(span_warning("[target.real_name]'s body is engulfed by dark energy..."), runechat_message = TRUE)

	if(target.ckey) //player still inside body

		var/offer = alert(target, "Do you wish to be reanimated as a minion?", "RAISED BY NECROMANCER", "Yes", "No")
		var/offer_time = world.time

		if(offer == "No" || world.time > offer_time + 5 SECONDS)
			to_chat(target, span_danger("Another soul will take over."))
			offer_refused = TRUE

		else if(offer == "Yes")
			to_chat(target, span_danger("You rise as a minion."))
			target.turn_to_minion(user, target.ckey)
			target.visible_message(span_warning("[target.real_name]'s eyes light up with an evil glow."), runechat_message = TRUE)
			return TRUE

	if(!target.ckey || offer_refused) //player is not inside body or has refused, poll for candidates

		var/list/candidates = pollCandidatesForMob("Do you want to play as a Necromancer's minion?", null, null, null, 100, target, POLL_IGNORE_NECROMANCER_SKELETON)

		// theres at least one candidate
		if(LAZYLEN(candidates))
			var/mob/C = pick(candidates)
			target.turn_to_minion(user, C.ckey)
			target.visible_message(span_warning("[target.real_name]'s eyes light up with an eerie glow."), runechat_message = TRUE)

		//no candidates, oh well
		else
			user.visible_message(span_warning("[target.real_name]'s fails to rise."), runechat_message = TRUE)

		return TRUE

	return FALSE

/**
  * Turns a mob into a skeletonized minion. Used for raising undead minions.
  * If a ckey is provided, the minion will be controlled by the player.
  *
  * Vars:
  * * master: master of the minion.
  * * ckey (optional): ckey of the player that will control the minion.
  */
/mob/living/carbon/human/proc/turn_to_minion(mob/living/carbon/human/master, ckey)

	if(!master)
		return FALSE

	src.revive(TRUE, TRUE)

	if(ckey) //player
		src.ckey = ckey

	if(!mind)
		mind_initialize()

	mind.adjust_skillrank_up_to(/datum/skill/combat/maces, 3, TRUE)
	mind.adjust_skillrank_up_to(/datum/skill/combat/axes, 3, TRUE)
	mind.adjust_skillrank_up_to(/datum/skill/combat/crossbows, 3, TRUE)
	mind.adjust_skillrank_up_to(/datum/skill/combat/wrestling, 3, TRUE)
	mind.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 3, TRUE)
	mind.adjust_skillrank_up_to(/datum/skill/combat/swords, 3, TRUE)
	mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser)
	mind.current.job = null

	dna.species.species_traits |= NOBLOOD
	dna.species.soundpack_m = new /datum/voicepack/skeleton()
	dna.species.soundpack_f = new /datum/voicepack/skeleton()


	cmode_music = 'sound/music/combat_cult.ogg'

	patron = master.patron
	mob_biotypes = MOB_UNDEAD
	faction = list("undead")
	ambushable = FALSE
	underwear = "Nude"

	for(var/obj/item/bodypart/BP in bodyparts)
		BP.skeletonize()

	var/obj/item/organ/eyes/eyes = getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(src,1)
		QDEL_NULL(eyes)

	eyes = new /obj/item/organ/eyes/night_vision/zombie
	eyes.Insert(src)

	if(charflaw)
		QDEL_NULL(charflaw)

	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOLIMBDISABLE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_EASYDISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LIMBATTACHMENT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOSLEEP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SHOCKIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOROGSTAM, TRAIT_GENERIC)

	update_body()

	to_chat(src, span_userdanger("My master is [master.real_name]."))

	master.minions += src

	return TRUE

/obj/effect/proc_holder/spell/targeted/churnliving
	name = "Churn Living"
	cost = 1
	desc = "The best part about living forever is an eternity of ironic punishments."
	range = 5
	releasedrain = 30
	charge_max = 5 MINUTES //GET THE FUCK OFF ME blast. All or nothing.
	max_targets = 0
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/arcane
	invocation = "Zizo condemns!"
	invocation_type = "shout" 

/obj/effect/proc_holder/spell/targeted/churn/cast(list/targets,mob/living/user = usr)
	. = ..()
	var/list/living_to_churn = list()
	for(var/mob/living/L in targets)
		if(L.stat == DEAD)
			continue
	for (var/mob/living/carbon/human/L in view(src, 5))
		if(L.anti_magic_check(TRUE, TRUE) || HAS_TRAIT(L, TRAIT_ANTIMAGIC) || L.mob_biotypes & MOB_UNDEAD)
			continue
		else
			living_to_churn += L
	if (LAZYLEN(living_to_churn))
		user.visible_message(span_danger("[user] unmakes living flesh with a gesture!!"),runechat_message = TRUE)
		for(var/mob/living/victim in living_to_churn)
			victim.visible_message(span_danger("[victim] is smited by death magic!"), span_userdanger("ZIZOZIZOZIZOZIZOZIZO-"))
			victim.adjustBruteLoss(50)
			if(victim.blood_volume > BLOOD_VOLUME_OKAY)
				victim.blood_volume -= 100
				user.Beam(victim,icon_state="drainbeam",time=10)
			victim.Knockdown(10)
			victim.emote("agony")
			victim.flash_fullscreen("redflash3")
			playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
		to_chat(user, span_warning("I am weakened, having spent all my power. It will take time to recuperate."))
		user.Stun(10)
		user.apply_status_effect(/datum/status_effect/debuff/churn_spent)
	else
		to_chat(user, span_warning("There's nobody in range this can affect."))
		revert_cast()
	..()
	return TRUE

/obj/effect/proc_holder/spell/invoked/projectile/sickness
	name = "Ray of Sickness"
	desc = ""
	clothes_req = FALSE
	range = 15
	projectile_type = /obj/projectile/magic/sickness
	overlay_state = "raiseskele"
	sound = list('sound/misc/portal_enter.ogg')
	active = FALSE
	releasedrain = 30
	chargetime = 10
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	charge_max = 15 SECONDS

/obj/effect/proc_holder/spell/self/suicidebomb
	name = "Calcic Outburst"
	desc = "Explode in a wonderful blast of osseous shrapnel."
	overlay_state = "tragedy"
	chargedrain = 0
	chargetime = 0
	charge_max = 10 SECONDS
	sound = 'sound/magic/swap.ogg'
	warnie = "spellwarning"
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	stat_allowed = TRUE
	var/exp_heavy = 0
	var/exp_light = 3
	var/exp_flash = 3
	var/exp_fire = 0

/obj/effect/proc_holder/spell/self/suicidebomb/cast(list/targets, mob/living/user = usr)
	. = ..()
	if(!user)
		return
	if(user.stat == DEAD)
		return
	if(alert(user, "Do you wish to sacrifice this vessel in a powerful explosion?", "ELDRITCH BLAST", "Yes", "No") == "No")
		return FALSE
	playsound(get_turf(user), 'sound/magic/antimagic.ogg', 100)
	user.visible_message(span_danger("[user] begins to shake violently, a blindingly bright light beginning to emanate from them!"), span_danger("Powerful energy begins to expand outwards from inside me!"))

	user.Immobilize(50)
	user.Knockdown(50)

	var/turf/T = get_turf(user)
	sleep(5 SECONDS)

	var/datum/antagonist/lich/lichman = user.mind.has_antag_datum(/datum/antagonist/lich)
	if(lichman)
		if(user.stat != DEAD)
			lichman.consume_phylactery(0)
	else
		user.death()

	explosion(T, -1, exp_heavy, exp_light, exp_flash, 0, flame_range = exp_fire, soundin = 'sound/misc/explode/incendiary (1).ogg')

	return TRUE

/obj/effect/proc_holder/spell/self/suicidebomb/lesser
	name = "Lesser Calcic Outburst"
	exp_heavy = 0
	exp_light = 2
	exp_flash = 2
	exp_fire = 0

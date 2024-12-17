
/datum/antagonist/skeleton
	name = "Skeleton"
	increase_votepwr = FALSE
	var/datum/antagonist/lich/lich_lord

/datum/antagonist/skeleton/examine_friendorfoe(datum/antagonist/examined_datum,mob/examiner,mob/examined)
	if(istype(examined_datum, /datum/antagonist/vampirelord))
		var/datum/antagonist/vampirelord/V = examined_datum
		if(!V.disguised)
			return span_boldnotice("Another deadite.")
	if(istype(examined_datum, /datum/antagonist/zombie))
		return span_boldnotice("Another deadite.")
	if(istype(examined_datum, /datum/antagonist/skeleton))
		return span_boldnotice("Another deadite. My ally.")
	if(istype(examined_datum, /datum/antagonist/lich))
		return span_boldnotice("A lych! My master.")

/datum/antagonist/skeleton/on_gain()
	var/datum/game_mode/C = SSticker.mode
	C.skeletons |= owner
	. = ..()
	owner.special_role = name
	owner.current.verbs |= /mob/living/carbon/human/proc/deathspeak
//	if(!(locate(/datum/objective/escape) in objectives))
//		var/datum/objective/escape/boat/escape_objective = new
//		escape_objective.owner = owner
//		objectives += escape_objective
//		return
	return ..()

/datum/antagonist/skeleton/on_removal()
	return ..()


/datum/antagonist/skeleton/greet()
	owner.announce_objectives()
	to_chat(owner.current, span_userdanger("I am torn from the Undermaiden's grasp! I am a hollow vessel, bound to serve my master for eternity!"))
	..()

/datum/antagonist/skeleton/roundend_report()
	return

/datum/advclass/skeletonwarrior //Armored skeleton warrior. Choice between sword&board, polearm, or warhammer. Good STR, mediocre speed. 
	name = "Skeleton Defender"
	tutorial = "The lumbering bulwark of the dead. Kill until you die once more. Heavily armored, heavily armed- shield the lich and bury the living under dead weight."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/skeleton_warrior
	category_tags = list(CTAG_SKELETON)

/datum/outfit/job/roguetown/greater_skeleton/skeleton_warrior/pre_equip(mob/living/carbon/human/H) //todo- see about drip for them. maybe we can give them bronze shit or someth
	..()
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	pants = /obj/item/clothing/under/roguetown/platelegs
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	neck = /obj/item/clothing/neck/roguetown/gorget
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	backl = /obj/item/rogueweapon/shield/heater
	mask = /obj/item/clothing/mask/rogue/facemask/steel 
	head = /obj/item/clothing/head/roguetown/helmet/skullcap
	gloves = /obj/item/clothing/gloves/roguetown/plate
	H.mind.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.STASTR = rand(14,16)
	H.STASPD = 7
	H.STACON = 12 //durable
	H.STAEND = 15
	H.STAINT = 1
	H.adjust_blindness(-3)
	var/weapons = list("Sword","Spear", "Warhammer")
	var/weapon_choice = input("Choose your weapon.", "ARM THE DEAD") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Sword")
			beltr = /obj/item/rogueweapon/sword/long
		if("Spear")
			beltr = /obj/item/rogueweapon/spear/bronze
		if("Warhammer")
			beltr = /obj/item/rogueweapon/mace/warhammer

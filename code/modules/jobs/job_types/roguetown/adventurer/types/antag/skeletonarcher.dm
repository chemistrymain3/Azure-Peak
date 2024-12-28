/datum/advclass/skeletonarcher //Revived bogwardens, dragged out of the murk to kill their own. Ranged role with mild capability directly.
	name = "Dread Bogwarden"
	tutorial = "Your body and soul have been stolen by the bog you once called home- but your bolts remain as sharp as your skills. Rain death upon the living."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/skeleton_archer
	category_tags = list(CTAG_SKELETON)

/datum/outfit/job/roguetown/greater_skeleton/skeleton_archer/pre_equip(mob/living/carbon/human/H) //todo- see about drip for them. maybe we can give them bronze shit or someth
	..()
	head = /obj/item/clothing/head/roguetown/helmet/kettle
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	mask = /obj/item/clothing/mask/rogue/facemask
	neck = /obj/item/clothing/neck/roguetown/coif
	gloves = /obj/item/clothing/gloves/roguetown/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/stoneaxe/woodcut/wardenpick
	beltl = /obj/item/quiver/arrows
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	backpack_contents = list(/obj/item/rogueweapon/huntingknife = 1)
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/bows, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/crossbows, 5, TRUE) //they don't start with a crossbow
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE) //useless, but fitting
		H.mind.adjust_skillrank(/datum/skill/misc/tracking, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/masonry, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
		H.STASTR = rand(12, 14)
		H.STASPD = 9
		H.STACON = 7
		H.STAEND = 15
		H.STAINT = 1
		H.STAPER = 20 //steady diet of undead carrots

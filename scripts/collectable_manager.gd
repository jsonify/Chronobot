extends Node


static var total_award_amount : int

signal on_collectable_award_received

func give_pickup_award(collectable_award : int):
	total_award_amount += collectable_award
	
	on_collectable_award_received.emit(total_award_amount)

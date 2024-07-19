extends CanvasLayer

@onready var collectable_label = $MarginContainer/VBoxContainer2/HBoxContainer/CollectableLabel


func _ready():
	CollectableManager.on_collectable_award_received.connect(on_collectable_award_received)
	

func on_collectable_award_received(total_award : int):
	collectable_label.text = str(total_award)


func _on_pause_texture_button_pressed():
	GameManager.pause_game()

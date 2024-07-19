extends Node

var pause_menu_screen = preload("res://ui/pause_menu_screen.tscn")
var main_menu_screen = preload("res://ui/main_menu_screen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.set_default_clear_color(Color(0.44,0.12,0.53,1.00))
	SettingsManager.load_settings()

func start_game():
	if get_tree().paused == true:
		continue_game()
		return
		
	SceneManager.transition_to_scene("Level1")

func exit_game():
	get_tree().quit()
	

func pause_game():
	get_tree().paused = true
	var pause_menu_screen_instantiate = pause_menu_screen.instantiate()
	get_tree().get_root().add_child(pause_menu_screen_instantiate)
	
func main_menu():
	var main_menu_screen_instantiate = main_menu_screen.instantiate()
	get_tree().get_root().add_child(main_menu_screen_instantiate)

func continue_game():
	get_tree().paused = false

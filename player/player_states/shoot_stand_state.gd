extends NodeState

@export var character_body_2d: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var muzzle: Marker2D
@export var hold_gun_time: float = 2.0

var bullet = preload("res://Player/bullet.tscn")
var muzzle_position: Vector2


func on_process(_delta: float) -> void:
	pass

	
func on_physics_process(_delta: float) -> void:
	position_muzzle()

	if GameInputEvents.shoot_input():
		gun_shooting()

	# Transitioning states

	# Run state
	var direction: float = GameInputEvents.movement_input()
	if direction and character_body_2d.is_on_floor():
		transition.emit("Run")

	# Jump state
	if GameInputEvents.jump_input():
		transition.emit("Jump")


func enter() -> void:
	muzzle.position = Vector2(21, -27)
	muzzle_position = muzzle.position

	get_tree().create_timer(hold_gun_time).timeout.connect(on_hold_gun_timeout)
	animated_sprite_2d.play("shoot_stand")
	

func exit() -> void:
	animated_sprite_2d.stop()


func on_hold_gun_timeout() -> void:
	transition.emit("Idle")


func position_muzzle() -> void:
	if !animated_sprite_2d.flip_h:
		muzzle.position.x = muzzle_position.x
	elif animated_sprite_2d.flip_h:
		muzzle.position.x = -muzzle_position.x


func gun_shooting() -> void:
	var direction: float = -1 if animated_sprite_2d.flip_h == true else 1
	
	var bullet_instance = bullet.instantiate() as Node2D
	bullet_instance.direction = direction
	bullet_instance.move_x_direction = true
	bullet_instance.global_position = muzzle.global_position
	get_parent().add_child(bullet_instance)

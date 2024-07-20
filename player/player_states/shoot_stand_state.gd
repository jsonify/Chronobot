extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var muzzle : Marker2D

var bullet := preload("res://player/bullet.tscn")

var muzzle_position : Vector2

func on_process(delta : float):
	pass


func on_physics_process(delta : float):
	
	if GameInputEvents.shoot_input():
		gun_shooting()
	else:
		print("nope")

	# transitioning states
	
	# idle_state
	#if !GameInputEvents.movement_input():
		#transition.emit("Idle")


func enter():
	muzzle_position = Vector2(18, -27)
	muzzle_position = muzzle.position
	animated_sprite_2d.play("shoot_stand")


func exit():
	animated_sprite_2d.stop()


func gun_shooting():
	var direction := -1 if animated_sprite_2d.flip_h == true else 1
	
	var bullet_instance = bullet.instantiate() as Node2D
	bullet_instance.direction = direction
	bullet_instance.move_x_direction = true
	bullet_instance.global_position = muzzle.global_position
	get_parent().add_child(bullet_instance)

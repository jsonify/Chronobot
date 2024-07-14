extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var timer = $Timer

var enemy_death_effect = preload("res://enemies/enemy_death_effect.tscn")

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
#const GRAVITY = 1000

@export var speed : int = 1500
@export var patrol_points : Node
@export var wait_time : int = 3
@export var health_amount : int = 3

enum State {
	IDLE,
	WALK
}

var current_state : State
var direction : Vector2 = Vector2.LEFT
var number_of_points : int
var point_positions : Array[Vector2]
var current_point : Vector2
var current_point_position : int
var can_walk : bool = false

func _ready():
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point in patrol_points.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_position]
	else:
		print("No patrol points")
			
	timer.wait_time = wait_time
	
	current_state = State.WALK
	

func _physics_process(delta : float):
	enemy_gravity(delta)
	enemy_idle(delta)
	enemy_walk(delta)
	
	move_and_slide()
	player_animations()

func enemy_idle(delta):
	if !can_walk:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		current_state = State.IDLE
	else:
		pass
	
	
func enemy_walk(delta):
	if !can_walk:
		return
		
	if abs(position.x - current_point.x) > 0.5:
		velocity.x = direction.x * speed * delta
		current_state = State.WALK
	else:
		current_point_position += 1
		
		if current_point_position >= number_of_points:
			current_point_position = 0
		
		current_point = point_positions[current_point_position]
		
		if current_point.x > position.x:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT
	
		can_walk = false
		timer.start(wait_time)
		
	animated_sprite_2d.flip_h = direction.x > 0

func enemy_gravity(delta : float):
	velocity.y += GRAVITY * delta


func _on_timer_timeout():
	can_walk = true

func player_animations():
	if current_state == State.IDLE:
		animated_sprite_2d.play("idle")
	elif current_state == State.WALK:
		animated_sprite_2d.play("walk")


func _on_hurtbox_area_entered(area : Area2D):
	print("Hurtbox area entered")
	if area.get_parent().has_method("get_damage_amount"):
		var node = area.get_parent() as Node
		health_amount -= node.damage_amount
		print("Health amount: ", health_amount)
		
		if health_amount <= 0:
			death_effect()

func death_effect():
	var enemy_death_effect_instance = enemy_death_effect.instantiate() as Node2D
	enemy_death_effect_instance.global_position = global_position
	get_parent().add_child(enemy_death_effect_instance)
	queue_free()

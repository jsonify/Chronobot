extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var muzzle : Marker2D = $Muzzle
@onready var hit_animation_player = $HitAnimationPlayer

var bullet = preload("res://player/bullet.tscn")
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var speed : int = 1000
@export var max_horizontal_speed : int = 300
@export var slow_down_speed : int = 1700

@export var jump_strength : int = -400
@export var jump_horizontal_speed : int = 500
@export var max_jump_horizontal_speed : int = 300


enum State { 
	IDLE, 
	RUN, 
	JUMP,
	SHOOT,
	}

var current_state : State
var muzzle_position

func _ready():
	current_state = State.IDLE
	muzzle_position = muzzle.position

func _physics_process(delta : float):
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	player_muzzle_position()
	
	player_shooting(delta)
	
	move_and_slide()
	
	player_animations()
	#print("State: ", State.keys()[current_state])

func player_falling(delta : float):
	if !is_on_floor():
		velocity.y += GRAVITY * delta

func player_idle(_delta):
	if is_on_floor():
		current_state = State.IDLE

func player_run(delta : float):
	var direction = import_movement()
	if direction:
		velocity.x += direction * speed * delta
		velocity.x = clamp(velocity.x, -max_horizontal_speed, max_horizontal_speed)
		animated_sprite_2d.flip_h = direction < 0
		
	else:
		velocity.x = move_toward(velocity.x, 0, slow_down_speed * delta)
	
	if is_on_floor() and direction:
		current_state = State.RUN

func player_jump(delta : float):
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_strength
		current_state = State.JUMP
	
	if !is_on_floor() and current_state == State.JUMP:
		var direction = import_movement()
		velocity.x += direction * jump_horizontal_speed * delta
		velocity.x = clamp(velocity.x, -max_jump_horizontal_speed, max_jump_horizontal_speed)

func player_shooting(_delta):
	var direction = import_movement()
	
	if direction != 0 and Input.is_action_just_pressed("shoot"):
		var bullet_instance = bullet.instantiate() as Node2D
		bullet_instance.direction = direction
		bullet_instance.global_position = muzzle.global_position
		get_parent().add_child(bullet_instance)
		current_state = State.SHOOT

func player_muzzle_position():
	var direction = import_movement()
	if direction > 0:
		muzzle.position.x = muzzle_position.x
	elif direction < 0:
		muzzle.position.x = -muzzle_position.x
		

func player_animations():
	if current_state == State.IDLE:
		animated_sprite_2d.play("idle")
	elif current_state == State.RUN and animated_sprite_2d.animation != "run_shoot":
		animated_sprite_2d.play("run")
	elif current_state == State.JUMP:
		animated_sprite_2d.play("jump")
	elif current_state == State.SHOOT:
		animated_sprite_2d.play("run_shoot")

func import_movement():
	var direction : float = Input.get_axis("move_left","move_right")
	return direction


func _on_hurtbox_body_entered(body : Node2D):
	if body.is_in_group("Enemy"):
		print("Enemy entered ", body.damage_amount)
		hit_animation_player.play("hit")
		HealthManager.decrease_health(body.damage_amount)

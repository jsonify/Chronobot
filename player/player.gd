extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

const GRAVITY = 1000
@export var speed : int = 300
@export var jump_strength : int = -300
@export var jump_horizontal : int = 100

enum State { 
	IDLE, 
	RUN, 
	JUMP,
	}

var current_state : State

func _ready():
	current_state = State.IDLE

func _physics_process(delta : float):
	player_falling(delta)
	player_idle()
	player_run()
	player_jump(delta)
	#print("State: ", State.keys()[current_state])
	
	move_and_slide()
	
	player_animations()

func player_falling(delta : float):
	if !is_on_floor():
		velocity.y += GRAVITY * delta

func player_idle():
	if is_on_floor():
		current_state = State.IDLE

func player_run():
	
	var direction = import_movement()
	if direction:
		velocity.x = direction * speed
		animated_sprite_2d.flip_h = direction < 0
		
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if is_on_floor() and direction:
		current_state = State.RUN

func player_jump(delta : float):
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_strength
		current_state = State.JUMP
	
	if !is_on_floor() and current_state == State.JUMP:
		var direction = import_movement()
		velocity.x += direction * jump_horizontal * delta

func player_animations():
	if current_state == State.IDLE:
		animated_sprite_2d.play("idle")
	elif current_state == State.RUN:
		animated_sprite_2d.play("run")
	elif current_state == State.JUMP:
		animated_sprite_2d.play("jump")

func import_movement():
	var direction : float = Input.get_axis("move_left","move_right")
	return direction

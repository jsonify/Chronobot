extends CharacterBody2D

const GRAVITY = 1000

@export var speed : int = 1500
@export var patrol_points : Node

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

func _ready():
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point in patrol_points.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_position]
	else:
		print("No patrol points")
			
	current_state = State.WALK
	

func _physics_process(delta : float):
	enemy_gravity(delta)
	enemy_idle(delta)
	enemy_walk(delta)
	
	move_and_slide()

func enemy_idle(delta):
	velocity.x = move_toward(velocity.x, 0, speed * delta)
	current_state = State.IDLE
	
	
func enemy_walk(delta):
	velocity.x = direction.x * speed * delta
	current_state = State.WALK

func enemy_gravity(delta : float):
	velocity.y += GRAVITY * delta

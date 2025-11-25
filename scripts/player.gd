class_name Player
extends CharacterBody2D
## Player
##
## Handles 2D movement and updates the animation to match the player's
## walking or idle direction.

@export var move_speed: float = 30.0

var facing_direction: Vector2

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	facing_direction = Vector2.DOWN

func get_input():
	var input_direction = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down")

	# Check if the user has actually moved
	if (input_direction != Vector2.ZERO):
		facing_direction = input_direction

	velocity = input_direction * move_speed

## Gets the inputs and converts them to a direction
func _physics_process(_delta):
	get_input()
	move_and_slide()
	_animate()

## Uses velocity and direction to determine which animation to use and plays it
func _animate():
	var is_player_moving = velocity.length() > 0
	var is_direction_horizontal = abs(facing_direction.x) > abs(facing_direction.y)

	var player_state = "walk" if is_player_moving else "idle"
	var player_direction: String

	## Facing_direction (x, y) mapping: +x → right, -x → left, +y → down, -y → up
	if is_direction_horizontal:
		player_direction = "right" if (facing_direction.x > 0) else "left"
	else:
		player_direction = "down" if (facing_direction.y > 0) else "up"

	var player_animation_name = player_state + "_" + player_direction
	animated_sprite.play(player_animation_name)

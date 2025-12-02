class_name Player
extends CharacterBody2D
## Player
##
## Handles 2D movement and updates the animation to match the player's
## walking or idle direction.

@export var move_speed: float = 30.0

var facing_direction: Vector2 = Vector2.DOWN

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta):
	move_and_slide()

func update_input_direction(input_direction: Vector2):
	facing_direction = input_direction
	velocity = input_direction * move_speed
	_set_walk_animation()

func stop_moving():
	velocity = Vector2i(0, 0)
	_set_idle_animation()

func _set_idle_animation():
	animated_sprite.play("idle_" + _get_player_direction())

func _set_walk_animation():
	animated_sprite.play("walk_" + _get_player_direction())

# Determines the movement direction based on whether movement is horizontal
# or vertical, and whether the facing value is positive or negative.
func _get_player_direction() -> String:
	if abs(facing_direction.x) > abs(facing_direction.y):
		return "right" if (facing_direction.x > 0) else "left"
	else:
		return "down" if (facing_direction.y > 0) else "up"

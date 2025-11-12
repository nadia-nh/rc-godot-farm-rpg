extends CharacterBody2D

@export var move_speed: float = 30.0

func get_input():
    var input_direction = Input.get_vector(
        "move_left", "move_right", "move_up", "move_down")
    velocity = input_direction * move_speed

func _physics_process(_delta):
    get_input()
    move_and_slide()

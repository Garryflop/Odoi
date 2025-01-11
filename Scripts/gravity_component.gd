class_name GravityComponent
extends Node

@export_subgroup("Settings")
#@export var gravity: float = 1000.0

@export var jump_height : float = 100
@export var jump_time_to_peak : float = 0.5
@export var jump_time_to_descent : float = 0.4

@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var is_falling: bool = false


func handle_gravity(body: CharacterBody2D, delta: float) -> void:
	if not body.is_on_floor():
		body.velocity.y += (jump_gravity if body.velocity.y < 0.0 else fall_gravity) * delta
	
	is_falling = body.velocity.y > 0 and not body.is_on_floor()

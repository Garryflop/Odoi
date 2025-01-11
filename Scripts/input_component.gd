class_name InputComponent
extends Node


var input_horizontal: float = 0.0

func _process(_delta) -> void:
	input_horizontal = Input.get_axis("LEFT", "RIGHT")


func get_jump_input() -> bool:
	return Input.is_action_just_pressed("JUMP")


func get_jump_input_released() -> bool:
	return Input.is_action_just_released("JUMP")


func get_right_direction() -> bool:
	return Input.is_action_pressed("RIGHT")


func get_left_direction() -> bool:
	return Input.is_action_pressed("LEFT")


func get_dash_input() -> bool:
	return Input.is_action_just_pressed("DASH")


func get_distract_input() -> bool:
	return Input.is_action_pressed("DISTRACT")


func get_attack_input() -> bool:
	return Input.is_action_just_pressed("ATTACK")

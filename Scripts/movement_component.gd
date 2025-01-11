class_name MovementComponent
extends Node

@export_subgroup("Settings")
@export var speed: float = 100
@export var ground_accel_speed: float = 6.0
@export var ground_decel_speed: float = 8.0
@export var air_accel_speed: float = 10.0
@export var air_decel_speed: float = 3.0
@export var dash_speed : float = 150.0

@export_subgroup("Nodes")
@export var dash_duration : Timer
@export var dash_effect : Timer
@export var dash_delay : Timer

var can_dash : bool = true
var dashing : bool = false
var dash_direction : int

func handle_horizontal_movement(body: CharacterBody2D, direction: float) -> void:
	var velocity_change_speed: float = 0.0
	if body.is_on_floor():
		velocity_change_speed = ground_accel_speed if direction != 0 else ground_decel_speed
	else:
		velocity_change_speed = air_accel_speed if direction != 0 else air_decel_speed
	
	body.velocity.x = move_toward(body.velocity.x, direction * speed, velocity_change_speed)


func dash(body: CharacterBody2D, direction: float, input_dash: bool) -> void:
	
	if !can_dash and body.is_on_floor():
		can_dash = true
	if input_dash and can_dash:
		dashing = true
		can_dash = false
		dash_duration.start()
		dash_effect.start()
	if dashing:

		body.velocity.x = (-1 if direction else 1) * dash_speed 
		body.velocity.y = 0


func create_dash_effect():
	var player_node_duplicate : Sprite2D = get_parent().get_node("Sprite2D").duplicate()
	player_node_duplicate.modulate.a = 0.9
	get_parent().get_parent().add_child(player_node_duplicate)
	player_node_duplicate.global_position = get_parent().global_position
	
	var anim_time = dash_duration.wait_time/3
	await get_tree().create_timer(anim_time).timeout
	player_node_duplicate.modulate.a = 0.6
	await get_tree().create_timer(anim_time).timeout
	player_node_duplicate.modulate.a = 0.2
	await get_tree().create_timer(anim_time).timeout
	player_node_duplicate.queue_free()



func _on_dash_duration_timer_timeout():
	dashing = false
	dash_effect.stop()


func _on_dash_effect_timer_timeout():
	create_dash_effect()

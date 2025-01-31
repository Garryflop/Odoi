class_name AdvancedJumpComponent
extends Node

@export_subgroup("Nodes")
@export var jump_buffer_timer: Timer
@export var coyote_timer: Timer

@export_subgroup("Settings")
#@export var jump_velocity: float = -350.0
@export var jump_height : float = 100.0
@export var jump_time_to_peak : float = 0.5
@export var jump_time_to_descent : float = 0.4
#@export var wall_sliding_acceleration: float = 5000
#@export var wall_sliding_speed: float = 200

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0


var is_going_up: bool = false
var is_jumping: bool = false
var last_frame_on_floor: bool = false
var prev_velocity: Vector2 = Vector2.ZERO

func is_allowed_to_jump(body: CharacterBody2D, want_to_jump: bool) -> bool:
	return want_to_jump and (body.is_on_floor() or not coyote_timer.is_stopped())


func has_just_landed(body: CharacterBody2D) -> bool:
	return body.is_on_floor() and not last_frame_on_floor and is_jumping


func has_just_stepped_off_ledge(body: CharacterBody2D) -> bool:
	return not body.is_on_floor() and last_frame_on_floor and not is_jumping


func handle_jump(body: CharacterBody2D, want_to_jump: bool, jump_released: bool, speed: float, left: bool, right: bool, _delta: float) -> void:
	if has_just_landed(body):
		is_jumping = false
	
	if is_allowed_to_jump(body, want_to_jump):
		jump(body)
	handle_wall_jump(body, want_to_jump, speed, right, left)
	handle_coyote_time(body)
	handle_jump_buffer(body, want_to_jump)
	handle_variable_jump_height(body, jump_released)
	#handle_wall_slide(body, delta)
	
	is_going_up = body.velocity.y < 0 and not body.is_on_floor()
	last_frame_on_floor = body.is_on_floor()


func handle_variable_jump_height(body: CharacterBody2D, jump_released: bool) -> void:
	if jump_released and is_going_up:
		body.velocity.y = 0


func handle_jump_buffer(body: CharacterBody2D, want_to_jump: bool) -> void:
	if want_to_jump and not body.is_on_floor():
		jump_buffer_timer.start()


func handle_coyote_time(body: CharacterBody2D) -> void:
	if has_just_stepped_off_ledge(body):
		coyote_timer.start()
	
	if not coyote_timer.is_stopped() and not is_jumping:
		body.velocity.y = 0


#func handle_wall_slide(body: CharacterBody2D, delta: float) -> void:
	#if not body.is_on_wall_only():
		#return
	#var wall_normal = body.get_wall_normal()
	#body.velocity.y += (wall_sliding_speed * delta)
	#body.velocity.y = min(body.velocity.y, wall_sliding_speed)


func handle_wall_jump(body: CharacterBody2D, want_to_jump: bool, speed: float, left: bool, right: bool) -> void:
	if not body.is_on_wall():
		return
	var wall_normal = body.get_wall_normal()
	if want_to_jump:
		jump(body)
		#добавить подтверждение
		#Исправить баг спрайта
		if right or left:
			body.velocity.x = wall_normal.x * (speed/2.5)
		else:
			body.velocity.x = wall_normal.x * (speed)
			print(body.velocity, wall_normal)
			body.last_sprite_direction = !body.last_sprite_direction
		


func jump(body: CharacterBody2D) -> void:
	body.velocity.y = jump_velocity
	jump_buffer_timer.stop()
	is_jumping = true
	coyote_timer.stop()

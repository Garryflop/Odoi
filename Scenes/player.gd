extends CharacterBody2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

@export_subgroup("Components")
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var jump_component: AdvancedJumpComponent

@export_subgroup("Nodes")
@export var wait_timer: Timer
@export var particles: CPUParticles2D
@export var label_anim: AnimationPlayer
@export var attack_zone: Area2D

@export var attacking : bool = false

var last_sprite_direction : bool 
var fight_mode : bool 
var distract : bool = false
var can_move : bool = true
var time_react : bool = false
var died : bool = false

var flag : bool = false

func _ready() -> void:
	Global.Player = self
	$Label.modulate.a = 0.0
	last_sprite_direction = false if (get_wall_normal().x) > 0 else true
	fight_mode = false

func _process(delta):
	if !died:
		attack()


func _physics_process(delta: float) -> void:
	if !died:
		gravity_component.handle_gravity(self, delta)
		movement_component.dash(self, $Sprite2D.flip_h, input_component.get_dash_input())
	if can_move and !died:
		movement_component.handle_horizontal_movement(self, input_component.input_horizontal)
	if !fight_mode and !died:
		jump_component.handle_jump(self, input_component.get_jump_input(), input_component.get_jump_input_released(), movement_component.speed, input_component.get_left_direction(), input_component.get_right_direction(), delta)
	if !died:
		move_and_slide()
		attack()
		get_sprite_direction(input_component.input_horizontal)
		give_distraction(input_component.get_distract_input())
	if wait_timer.time_left > 0:
		if input_component.get_dash_input():
			print("TIMEOUT")
			time_react = true
			wait_timer.stop()
	var animation = get_new_animation()
	animation_player.play(animation)


func give_distraction(distraction):
	if distraction:
		distract = true


func off_distraction():
	distract = false

func get_sprite_direction(input_horizontal: float) -> void:
	if input_horizontal == 0:
		sprite.flip_h = last_sprite_direction
		var dir = -1 if last_sprite_direction else 1
		$Sprite2D/Sprite2D.position.x = 32 *dir
		$Sprite2D/Sprite2D.flip_h = last_sprite_direction
		attack_zone.scale.x = dir
	else:
		last_sprite_direction = false if input_horizontal == 1 else true
		sprite.flip_h = last_sprite_direction
		var dir = -1 if last_sprite_direction else 1
		$Sprite2D/Sprite2D.position.x = 32*dir
		$Sprite2D/Sprite2D.flip_h = last_sprite_direction
		attack_zone.scale.x = dir


func hit_stop(time_scale_value: float, duration: float) -> void:
	Engine.time_scale = time_scale_value
	var timer = get_tree().create_timer(time_scale_value * duration)
	await timer.timeout
	Engine.time_scale = 1


func die() -> void:
	if !died and !movement_component.dashing:
		AudioManager.play_sound($Die.stream)
		Global.die_counter += 1
		died = true
		hit_stop(0.5, 1)
		await animation_player.animation_finished
		get_tree().reload_current_scene()


func attack() -> void:
	if input_component.get_attack_input():
		var overlapping_objects = attack_zone.get_overlapping_areas()
		for area in overlapping_objects:
			var parent = area.get_parent().get_parent()
			if parent != null and parent.is_in_group("Interact") and area.name != "AttackZone":
				parent.take_damage(2)
		attacking = true


func hit_sound() -> void:
	AudioManager.play_sound($Hit.stream)


func wait_reaction(marker_position: Vector2) -> void:
	wait_timer.start()
	if time_react:
		slayer_dash(marker_position)
		time_react = false


func take_damage(damage):
	pass


func label_animation_play(strr: String) -> void:
	label_anim.play(strr)


func slayer_dash(marker_position: Vector2) -> void:
	var player_position : Vector2 = self.global_position
	var tween : Tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	can_move = false
	tween.tween_property(self, "global_position:x", marker_position.x, 0.6)
	await tween.finished
	can_move = true
	

func get_new_animation() -> String:
	var animation_new = ""
	if died:
		animation_new = "die"
	elif attacking:
		animation_new = "attack"
	elif movement_component.dashing:
		animation_new = "dash"
		if flag:
			AudioManager.play_sound($Die.stream)
			flag = false
	else:
		flag = true
		if is_on_floor():
			if abs(velocity.x) > 0.1:
				animation_new = "walk"
			else:
				animation_new = "idle"
		#elif is_on_wall_only() && !is_on_floor():
			#animation_new = "wall_slide"
		else:
			if velocity.y > 100:
				animation_new = "fall"
			else:
				if !is_on_floor():
					animation_new = "jump"
	return animation_new

extends Node2D

@export_subgroup("Nodes")
@export var left_side: RayCast2D
@export var right_side: RayCast2D
@export var reversed_nodes: Node2D
@export var anim: AnimationPlayer
@export var attack_zone: Area2D
@export var hit_box: Area2D
@export var sprite: Sprite2D

@export_subgroup("Variables")
@export var hp_max : int = 50
@export var attacking: bool = false
var action : bool = false
var hp : int = hp_max: set = set_hp, get = get_hp


var direction : int = -1


func _ready() -> void:
	attack_collide()


func _process(delta) -> void:
	if !action:
		right_side_colliding()
		left_side_colliding()
	reversed_nodes.scale.x = direction
	if direction == 1:
		reversed_nodes.position.x = 19.5
	else:
		reversed_nodes.position.x = -19.5
	#reversed_nodes.position.x = direction * reversed_nodes.position.x
	
	hitbox_collide()
	if attacking:
		attack_collide()


func attack() -> void:
	action = true
	anim.play("attack")
	await anim.animation_finished
	anim.play("idle")
	action = false
	check_zone()


func check_zone() -> void:
	if attack_zone.monitoring:
		var overlapping_objects = attack_zone.get_overlapping_bodies()
		for body in overlapping_objects:
			if body.is_in_group('Player'):
				attack()


func set_hp(value) -> void:
	if value != hp:
		hp = clamp(value, 0, hp_max)


func get_hp() -> int:
	return hp


func take_damage(damage: int) -> void:
	if hp > 0:
		hp -= damage
		var tween = get_tree().create_tween()
		tween.tween_property(sprite, "modulate", Color(0.973, 0.121, 1), 0.1).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(sprite, "modulate", Color.WHITE, 0.1).set_ease(Tween.EASE_OUT)
		print(hp)
	else:
		die()


func left_side_colliding() -> void:
	if left_side.is_colliding():
		var collider = left_side.get_collider()
		if collider.is_in_group('Player'):
			direction = -1


func right_side_colliding() -> void:
	if right_side.is_colliding():
		var collider = right_side.get_collider()
		if collider.is_in_group('Player'):
			direction = 1


func die() -> void:
	anim.play("die")
	await anim.animation_finished
	queue_free()


func attack_collide():
	if attack_zone.monitoring:
		var overlapping_objects = attack_zone.get_overlapping_bodies()
		for body in overlapping_objects:
			if body.is_in_group("Player"):
				body.die()


func hitbox_collide():
	if hit_box.monitoring:
		var overlapping_objects = hit_box.get_overlapping_bodies()
		for body in overlapping_objects:
			if body.is_in_group("Player"):
				body.die()


func _on_attack_zone_body_entered(body) -> void:
	if body.is_in_group('Player'):
		attack()

extends Node2D

@export_file("*.tscn") var scene : String
@export var enemy_node : Node2D

var enemy_count : int
var flag = true
var can_next_level = false


func _ready():
	pass


func _process(delta):
	enemy_count = enemy_node.get_child_count()
	if enemy_count == 0 && flag:
		can_next_level = true
		flag = false



func take_damage(damage: int):
	pass


func _on_limit_body_entered(body):
	if body.name == "Player":
		body.label_animation_play("NoPathBack")


func _on_limit_2_body_entered(body):
	if body.is_in_group("Player") and !can_next_level:
		body.label_animation_play("Revenge")
	if body.is_in_group("Player") and can_next_level:
		Global.next_scene(scene)

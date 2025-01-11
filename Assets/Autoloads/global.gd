extends Node


var Player : CharacterBody2D
var camera : Camera2D
@export var transition : CanvasLayer
var die_counter: int = 0

func next_scene(scene:String = "") -> void:
	transition.get_node("AnimationPlayer").play("OUT")
	await transition.get_node("AnimationPlayer").animation_finished
# warning-ignore:return_value_discarded
	get_tree().change_scene_to_packed(load(scene))
	transition.get_node("AnimationPlayer").play("IN")

extends Node2D

@export_file("*.tscn") var scene : String


func _ready():
	AudioManager.change_music("anx")


func _process(delta):
	pass


func _on_zone_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().change_scene_to_packed(load(scene))


func _on_limit_body_entered(body):
	if body.name == "Player":
		body.label_animation_play("NoPathBack")

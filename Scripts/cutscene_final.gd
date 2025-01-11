extends CanvasLayer

@export_file("*.tscn") var scene : String


func _ready():
	pass


func _process(delta):
	pass


func end() -> void:
	Global.next_scene(scene)


func jump_sound() -> void:
	AudioManager.play_sound($Jump.stream)


func hit_sound() -> void:
	AudioManager.play_sound($Hit.stream)


func hit2_sound() -> void:
	AudioManager.play_sound($Hit2.stream)

extends CanvasLayer



func _ready():
	pass


func _process(delta):
	pass

func intro_sound() -> void:
	AudioManager.play_sound($Sound.stream)


func _on_touch_screen_button_released():
	Global.next_scene("res://Scenes/main_menu.tscn")


func _on_animation_player_animation_finished(anim_name):
	Global.next_scene("res://Scenes/main_menu.tscn")

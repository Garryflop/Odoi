extends CanvasLayer


@export_file("*.tscn") var game_scene : String
@export var settings_packed_scene : PackedScene
@export var credits_packed_scene : PackedScene

var settings_scene
var credits_scene
var sub_menu




func _open_sub_menu(menu) -> void:
	sub_menu = menu
	if sub_menu != null:
		sub_menu.show()
		%Back.show()
		%MenuCont.hide()
	else:
		print(sub_menu)


func _close_sub_menu() -> void:
	if sub_menu == null:
		return
	sub_menu.hide()
	sub_menu = null
	%Back.hide()
	%MenuCont.show()


func _setup_options() -> void:
	if settings_packed_scene == null:
		%SettingsCont.hide()
	else:
		settings_scene = settings_packed_scene.instantiate()
		settings_scene.hide()
		%SettingsCont.call_deferred("add_child", settings_scene)


func _setup_credits() -> void:
	if credits_packed_scene == null:
		%CreditsCont.hide()
	else:
		credits_scene = credits_packed_scene.instantiate()
		credits_scene.hide()
		%CreditsCont.call_deferred("add_child", credits_scene)


func _on_play_button_up() -> void:
	AudioManager.play_sound($Start.stream)
	Global.next_scene(game_scene)


func _on_settings_button_up() -> void:
	AudioManager.play_sound($AudioStreamPlayer.stream)
	_open_sub_menu(settings_scene)


func _on_credits_button_up():
	AudioManager.play_sound($AudioStreamPlayer.stream)
	_open_sub_menu(credits_scene)


func _on_quit_button_up():
	AudioManager.play_sound($AudioStreamPlayer.stream)
	get_tree().quit()


func _on_back_button_up():
	AudioManager.play_sound($AudioStreamPlayer.stream)
	_close_sub_menu()

func _ready():
	AudioManager.change_music("MainMenu")
	_setup_options()
	_setup_credits()

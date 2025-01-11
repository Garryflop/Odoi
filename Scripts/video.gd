extends MarginContainer

@onready var fullscreen_button = %Fullscreen_button


func _on_fullscreen_button_toggled(toggled_on):
	var window : Window = get_window()
	window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (toggled_on) else Window.MODE_WINDOWED


func _on_rtx_button_toggled(toggled_on):
	pass # Replace with function body.

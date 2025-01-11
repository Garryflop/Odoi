extends Control

@export var audio_control_scene : PackedScene
@export var hide_busses : Array[String]


func _add_audio_control(bus_name, bus_value):
	if audio_control_scene == null or bus_name in hide_busses:
		return
	var audio_control = audio_control_scene.instantiate()
	audio_control.bus_name = bus_name
	audio_control.bus_value = bus_value
	%AudioCont.call_deferred("add_child", audio_control)
	audio_control.connect("bus_value_changed", AudioSetting.set_bus_volume_from_linear)


func _add_audio_bus_controls():
	for bus_iter in AudioServer.bus_count:
		var bus_name : String = AudioServer.get_bus_name(bus_iter)
		print(bus_name)
		var linear : float = AudioSetting.get_bus_volume_to_linear(bus_name)
		_add_audio_control(bus_name, linear)


func _update_ui():
	_add_audio_bus_controls()


func _ready():
	_update_ui()

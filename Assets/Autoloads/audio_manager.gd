extends Node


@export var Music: Node
@export var Sfx : Node

var current_music:String = ""

func play_sound(stream: AudioStream):
	var instance = AudioStreamPlayer.new()
	instance.stream = stream
	instance.finished.connect(remove_instance.bind(instance))
	add_child(instance)
	instance.play()


func remove_instance(instance: AudioStreamPlayer):
	instance.queue_free()


func change_music(mus_name:String, delay=1.0):
	if !AudioManager.get_node("Music/"+mus_name).is_playing():
		AudioManager.get_node("Music/"+mus_name).play()


	if current_music != "" && current_music != mus_name:
		var tween = create_tween()
		tween.tween_property(AudioManager.get_node("Music/"+current_music), "volume_db", -80, 1)
		tween.tween_property(AudioManager.get_node("Music/"+mus_name), "volume_db", 0, delay)
	current_music = mus_name

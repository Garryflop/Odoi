extends Control


@export var label: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.change_music("MainMenu")
	label.text = "Количество смертей: " + str(Global.die_counter)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

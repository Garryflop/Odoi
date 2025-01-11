extends CanvasLayer

@export var anim : AnimationPlayer
@export_file("*.tscn") var scene : String
@export var number: int = 1
@export var leng: int = 2
var page: int = 1


func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func _unhandled_input(event):
	if event.is_action_released("JUMP"):
		if page < leng:
			page += 1
			anim.play(str(page))
		else:
			AudioManager.change_music("Game")
			Global.next_scene(scene)

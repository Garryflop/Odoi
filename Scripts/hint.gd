extends Area2D


@export var text : String = "BASIC HINT"
@export var lab: Label
@export var anim: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	lab.text = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("Player"):
		anim.play("ON")


func _on_body_exited(body):
	if body.is_in_group("Player"):
		anim.play("OFF")

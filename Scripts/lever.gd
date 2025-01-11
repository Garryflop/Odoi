extends Node2D

@export var door: StaticBody2D
@export var anim : AnimationPlayer

var is_activated: bool = false

func _ready():
	pass


func _process(delta):
	pass

func take_damage(damage: int):
	print(45)
	if !is_activated:
		lever_on()


func lever_on():
	if door != null:
		door.open()
		is_activated = true
	anim.play("ON")
	

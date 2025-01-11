extends Area2D

@export_subgroup("Nodes")
@export var zone: Area2D
@export var indicator: Timer

var state: String = "Idle"
var is_player_in_zone : bool = false
var distract : bool = false

func _ready():
	print($Marker2D.global_position)
	pass


func _process(_delta):
	$Label.text = state + str(indicator.time_left)
	if indicator.time_left > 0:
		if Global.Player.distract:
			indicator.stop()
			distract = true
			#DASH MOMENT
			Global.Player.wait_reaction($Marker2D.global_position)
			print("Distracted")



func _on_zone_body_entered(body):
	is_player_in_zone = true
	if body.is_in_group("Player"):
		state = "Attack"
		indicator.start()
		await indicator.timeout
		if is_player_in_zone and !distract:
			body.die.call_deferred()
	state = "Idle"


func collision_off():
	zone.monitoring = false


func _on_zone_body_exited(body):
	if body.is_in_group("Player"):
		is_player_in_zone = false
		distract = false


func _on_fight_mode_body_entered(body):
	if body.is_in_group("Player"):
		body.fight_mode = true


func _on_fight_mode_body_exited(body):
	if body.is_in_group("Player"):
		body.fight_mode = false


func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.die.call_deferred()

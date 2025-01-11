extends Camera2D

#@export var shake_fade: float = 5.0
#
#var rng = RandomNumberGenerator.new()
#
#var shake_strength: float = 5.0
#
#func apply_shake(random):
	#shake_strength = random
  #
#const DEADZONE = 0

func _ready():
	Global.camera = self


#func _process(delta):
	#if shake_strength > 0:
		#shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		#offset = randomOffset()
  #
#func randomOffset():
	#return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

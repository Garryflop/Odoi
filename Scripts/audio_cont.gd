extends HBoxContainer

signal bus_value_changed(bus_name, bus_value)

@export var bus_name : String :
	set(value):
		bus_name = value
		if is_inside_tree():
			$Label.text = bus_name

@export var bus_value : float :
	set(value):
		bus_value = value
		if is_inside_tree():
			$HSlider.value = bus_value

func _on_h_slider_value_changed(value):
	bus_value = value
	emit_signal("bus_value_changed", bus_name, value)

func _ready():
	bus_name = bus_name
	bus_value = bus_value

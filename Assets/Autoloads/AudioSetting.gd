class_name AudioSetting
extends Node


const MASTER_BUS_INDEX = 0


static func get_bus_volume(bus_name : String) -> float:
	var bus_index : int = AudioServer.get_bus_index(bus_name)
	if bus_index < 0:
		return 0.0
	return AudioServer.get_bus_volume_db(bus_index)


static func get_bus_volume_to_linear(bus_name : String) -> float:
	return db_to_linear(get_bus_volume(bus_name))


static func set_bus_volume(bus_name : String, volume_db : float) -> void:
	var bus_index : int = AudioServer.get_bus_index(bus_name)
	if bus_index < 0:
		return
	AudioServer.set_bus_volume_db(bus_index, volume_db)


static func set_bus_volume_from_linear(bus_name : String, linear : float) -> void:
	set_bus_volume(bus_name, linear_to_db(linear))

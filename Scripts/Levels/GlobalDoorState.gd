extends Node

var opened_doors: Dictionary = {}

func set_door_opened(level_name: String, door_id: String) -> void:
	if not opened_doors.has(level_name):
		opened_doors[level_name] = []
	
	if not door_id in opened_doors[level_name]:
		opened_doors[level_name].append(door_id)

func is_door_opened(level_name: String, door_id: String) -> bool:
	return opened_doors.has(level_name) and door_id in opened_doors[level_name]

func reset_doors() -> void:
	opened_doors.clear()

class_name Event
extends Node2D


func run_laser_sequence() -> void:
	await get_tree().create_timer(2, false)
	var laser1
